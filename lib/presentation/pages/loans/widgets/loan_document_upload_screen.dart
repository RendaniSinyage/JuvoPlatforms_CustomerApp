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
import '../../../components/app_bars/common_app_bar.dart';
import '../../../components/buttons/custom_button.dart';
import '../../../components/text_fields/outline_bordered_text_field.dart';
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
      // Create loan application model
      final loanApplication = LoanApplicationModel(
        idNumber: idNumber,
        amount: ref.read(loanAmountProvider), // Assuming this is set previously
        documents: uploadedDocs,
      );
      debugPrint("Created loan application model with amount: ${loanApplication.amount}");

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

          // Navigate back to loan screen to see pending status
          Navigator.of(context).popUntil((route) => route.isFirst);

          // Clear uploaded documents
          ref.read(uploadedDocumentsProvider.notifier).state = {};

          // Navigate back to loan screen or dashboard
          context.router.popUntil((route) => route.isFirst);
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

    // Prepare financial details
    final financialDetails = {
      'id_number': idNumber,
      'loan_amount': ref.read(loanAmountProvider),
      'uploaded_documents': ref
          .read(uploadedDocumentsProvider)
          .map((key, value) => MapEntry(key, value.path)),
    };
    debugPrint("Financial details for incomplete application: $financialDetails");

    setState(() {
      _isSubmitting = true;
    });

    try {
      debugPrint("Calling saveIncompleteLoanApplication API");
      final result = await _loansRepository.saveIncompleteLoanApplication(
        financialDetails: financialDetails,
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

    return Scaffold(
      backgroundColor: AppStyle.bgGrey,
      body: Column(
        children: [
          CommonAppBar(
            child: Text(
              'Loan Document Upload',
              style: AppStyle.interNoSemi(
                size: 18,
                color: AppStyle.black,
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  24.verticalSpace,

                  // ID Number Input
                  Text(
                    'ID Number',
                    style: AppStyle.interSemi(size: 16.sp),
                  ),
                  16.verticalSpace,
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
                          title: 'Save for Later',
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