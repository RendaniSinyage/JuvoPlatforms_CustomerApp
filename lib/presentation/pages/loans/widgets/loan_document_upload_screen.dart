import 'dart:io';
import 'package:auto_route/auto_route.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path/path.dart' as path;

import '../../../../infrastructure/models/data/loans/loan_application.dart';
import '../../../../infrastructure/repository/loans_repository.dart';
import '../../../../infrastructure/services/app_helpers.dart';
import '../../../../infrastructure/services/local_storage.dart';
import '../../../../infrastructure/services/tr_keys.dart';
import '../../../components/buttons/custom_button.dart';
import '../../../components/keyboard_dismisser.dart';
import '../../../components/text_fields/outline_bordered_text_field.dart';
import '../../../components/title_icon.dart';
import '../../../theme/theme.dart';
import '../provider/loans_provider.dart';

@RoutePage()
class LoanDocumentUploadScreen extends ConsumerStatefulWidget {
  final String? prefilledIdNumber;

  const LoanDocumentUploadScreen({
    super.key,
    this.prefilledIdNumber,
  });

  @override
  ConsumerState<LoanDocumentUploadScreen> createState() =>
      _LoanDocumentUploadScreenState();
}

class _LoanDocumentUploadScreenState
    extends ConsumerState<LoanDocumentUploadScreen> {
  bool _idNumberReadOnly = false;
  // Controllers
  late TextEditingController _idNumberController;

  // Repositories
  late LoansRepository _loansRepository;

  // Document types for upload
  final List<String> _documentTypes = [
    'ID Copy',
    '3 Months Bank Statement',
    'Latest Payslip',
    'Proof of Address'
  ];

  // State variables
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();

    // Initialize repository
    _loansRepository = LoansRepository();

    // Initialize ID number controller
    _idNumberController =
        TextEditingController(text: widget.prefilledIdNumber ?? '');

    // If ID number is prefilled, make it read-only
    _idNumberReadOnly = widget.prefilledIdNumber != null && widget.prefilledIdNumber!.isNotEmpty;


    // Set initial ID number in provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(idNumberProvider.notifier).state = _idNumberController.text;
    });
  }

  @override
  void dispose() {
    _idNumberController.dispose();
    super.dispose();
  }

  Future<void> _uploadDocument(String docType) async {
    try {
      debugPrint("Picking file for document type: $docType");
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        final File file = File(result.files.single.path!);
        debugPrint("File selected: ${file.path}");

        // Validate file size (max 5MB)
        final fileSize = await file.length();
        debugPrint("File size: $fileSize bytes");

        if (fileSize > 5 * 1024 * 1024) {
          AppHelpers.showCheckTopSnackBarInfo(
            context,
            'File size must be less than 5MB',
          );
          return;
        }

        // Update the uploaded documents map
        final currentDocs = ref.read(uploadedDocumentsProvider);
        debugPrint("Updating documents map - adding $docType");
        ref.read(uploadedDocumentsProvider.notifier).state = {
          ...currentDocs,
          docType: file
        };
      }
    } catch (e) {
      debugPrint("Error uploading document: $e");
      AppHelpers.showCheckTopSnackBarInfo(
        context,
        'Failed to upload document',
      );
    }
  }

  Future<void> _submitDocuments() async {
    // Validate ID number (13 digits for South African ID)
    final idNumber = _idNumberController.text.trim();
    debugPrint("Submitting documents with ID: $idNumber");

    if (idNumber.isEmpty || idNumber.length != 13) {
      AppHelpers.showCheckTopSnackBarInfo(
        context,
        'Please enter a valid 13-digit ID number',
      );
      return;
    }

    // Validate uploaded documents
    final uploadedDocs = ref.read(uploadedDocumentsProvider);
    debugPrint("Uploaded documents count: ${uploadedDocs.length}");
    debugPrint("Document types: ${uploadedDocs.keys.toList()}");

    if (uploadedDocs.length < _documentTypes.length) {
      AppHelpers.showCheckTopSnackBarInfo(
        context,
        'Please upload all required documents',
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      // Get saved application ID if this is continuing from a saved application
      // This is typically stored when loading a saved application from LoanScreen
      final savedApplicationId = ref.read(savedApplicationIdProvider);
      debugPrint("Saved application ID: $savedApplicationId");

      // Create loan application model with documents properly formatted for the API
      final loanApplication = LoanApplicationModel(
        idNumber: idNumber,
        amount: ref.read(loanAmountProvider),
        documents: uploadedDocs,
        savedApplicationId: savedApplicationId, // Pass the saved application ID if available
      );

      debugPrint("Created loan application model with amount: ${loanApplication.amount}");
      debugPrint("Document count: ${loanApplication.documents.length}");
      debugPrint("Using saved application ID: ${loanApplication.savedApplicationId}");

      // Submit loan application
      debugPrint("Submitting loan application");
      final result = await _loansRepository.submitLoanApplication(
        applicationData: loanApplication,
      );

      result.when(
        success: (response) {
          debugPrint("Loan application submitted successfully: $response");
          // Show success message
          AppHelpers.showCheckTopSnackBarDone(
            context,
            'Loan application submitted successfully',
          );

          // Reset saved application ID since it's been submitted
          ref.read(savedApplicationIdProvider.notifier).state = null;

          // Navigate back to loan screen to see pending status
          Navigator.of(context).popUntil((route) => route.isFirst);

          // Clear uploaded documents
          ref.read(uploadedDocumentsProvider.notifier).state = {};
        },
        failure: (error, statusCode) {
          debugPrint("Loan application submission failed: $error, code: $statusCode");
          AppHelpers.showCheckTopSnackBarInfo(
            context,
            error,
          );
        },
      );
    } catch (e) {
      debugPrint("Exception submitting loan application: $e");
      AppHelpers.showCheckTopSnackBarInfo(
        context,
        'Failed to submit loan application',
      );
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  Future<void> _saveIncompleteLoanApplication() async {
    // Validate ID number
    final idNumber = _idNumberController.text.trim();
    debugPrint("Saving incomplete application with ID: $idNumber");

    if (idNumber.isEmpty || idNumber.length != 13) {
      AppHelpers.showCheckTopSnackBarInfo(
        context,
        'Please enter a valid 13-digit ID number',
      );
      return;
    }

    // Get uploaded documents
    final uploadedDocs = ref.read(uploadedDocumentsProvider);
    debugPrint("Uploaded documents: ${uploadedDocs.keys.toList()}");

    // Get financial details from the provider
    final financialDetails = ref.read(financialDetailsProvider);
    debugPrint("Financial details from provider: $financialDetails");

    setState(() {
      _isSubmitting = true;
    });

    try {
      // Create the data structure for saving
      final data = {
        'id_number': idNumber,
        'loan_amount': ref.read(loanAmountProvider),
        'financial_details': financialDetails,
        'uploaded_documents': uploadedDocs
            .map((key, value) => MapEntry(key, value.path)),
      };

      debugPrint("Financial details for incomplete application: $data");

      debugPrint("Calling saveIncompleteLoanApplication API");
      final result = await _loansRepository.saveIncompleteLoanApplication(
        financialDetails: data,
      );

      result.when(
        success: (applicationId) {
          debugPrint("Save incomplete application success - ID: $applicationId");
          AppHelpers.showCheckTopSnackBarDone(
            context,
            'Loan application saved. You can continue later.',
          );

          // Navigate back
          Navigator.of(context).pop();
        },
        failure: (error, statusCode) {
          debugPrint("Save incomplete application failed: $error, code: $statusCode");
          AppHelpers.showCheckTopSnackBarInfo(
            context,
            error,
          );
        },
      );
    } catch (e) {
      debugPrint("Exception saving incomplete application: $e");
      AppHelpers.showCheckTopSnackBarInfo(
        context,
        'Failed to save loan application',
      );
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final uploadedDocs = ref.watch(uploadedDocumentsProvider);
    debugPrint("Building UI with ${uploadedDocs.length} uploaded documents");

    return Directionality(
      textDirection: LocalStorage.getLangLtr() ? TextDirection.ltr : TextDirection.rtl,
      child: KeyboardDismisser(
        child: Container(
          decoration: BoxDecoration(
            color: AppStyle.bgGrey.withOpacity(0.96),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.r),
              topRight: Radius.circular(16.r),
            ),
          ),
          width: double.infinity,
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.85, // Use 85% of screen height
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                8.verticalSpace,
                Center(
                  child: Container(
                    height: 4.h,
                    width: 48.w,
                    decoration: BoxDecoration(
                      color: AppStyle.dragElement,
                      borderRadius: BorderRadius.all(Radius.circular(40.r)),
                    ),
                  ),
                ),
                24.verticalSpace,
                TitleAndIcon(
                  title: 'Loan Document Upload',
                  paddingHorizontalSize: 0,
                  titleSize: 18,
                ),
                24.verticalSpace,
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ID Number Input
                        Text(
                          'ID Number',
                          style: AppStyle.interSemi(size: 16.sp),
                        ),
                        16.verticalSpace,
                        Stack(
                          children: [
                            OutlinedBorderTextField(
                              textController: _idNumberController,
                              label: 'Enter 13-digit ID Number',
                              onChanged: (value) {
                                // Update ID number in provider
                                ref.read(idNumberProvider.notifier).state = value;
                              },
                              inputType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(13),
                              ],
                            ),
                            if (_idNumberReadOnly)
                              Positioned.fill(
                                child: GestureDetector(
                                  onTap: () {
                                    AppHelpers.showCheckTopSnackBarInfo(
                                        context,
                                        'ID number cannot be modified for a saved application'
                                    );
                                  },
                                  child: Container(
                                    color: Colors.transparent,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        24.verticalSpace,

                        // Document Uploads
                        Text(
                          'Required Documents (PDF Only)',
                          style: AppStyle.interSemi(size: 16.sp),
                        ),
                        16.verticalSpace,
                        ..._buildDocumentUploadList(uploadedDocs),

                        24.verticalSpace,

                        // Action Buttons
                        Row(
                          children: [
                            Expanded(
                              child: CustomButton(
                                title: AppHelpers.getTranslation(TrKeys.saveForLater),
                                background: AppStyle.white,
                                borderColor: AppStyle.primary,
                                textColor: AppStyle.primary,
                                onPressed: _saveIncompleteLoanApplication,
                              ),
                            ),
                            16.horizontalSpace,
                            Expanded(
                              child: CustomButton(
                                title: 'Submit Application',
                                isLoading: _isSubmitting,
                                onPressed: _submitDocuments,
                              ),
                            ),
                          ],
                        ),

                        24.verticalSpace,
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildDocumentUploadList(Map<String, File> uploadedDocs) {
    return _documentTypes.map((docType) {
      final isUploaded = uploadedDocs.containsKey(docType);
      final uploadedFile = isUploaded ? uploadedDocs[docType] : null;

      return Container(
        margin: EdgeInsets.only(bottom: 12.h),
        decoration: BoxDecoration(
          color: AppStyle.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: AppStyle.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ListTile(
          title: Text(
            docType,
            style: AppStyle.interNormal(size: 14.sp),
          ),
          subtitle: isUploaded
              ? Text(
            path.basename(uploadedFile!.path),
            style: AppStyle.interNormal(
              size: 12.sp,
              color: AppStyle.textGrey,
            ),
          )
              : null,
          trailing: isUploaded
              ? IconButton(
            icon: Icon(Icons.close, color: Colors.red, size: 24.r),
            onPressed: () {
              // Remove the specific document
              final currentDocs = ref.read(uploadedDocumentsProvider);
              final updatedDocs = Map<String, File>.from(currentDocs);
              updatedDocs.remove(docType);
              ref.read(uploadedDocumentsProvider.notifier).state =
                  updatedDocs;
            },
          )
              : IconButton(
            icon: Icon(Icons.upload_file,
                color: AppStyle.primary, size: 24.r),
            onPressed: () => _uploadDocument(docType),
          ),
          onTap: isUploaded ? null : () => _uploadDocument(docType),
        ),
      );
    }).toList();
  }
}