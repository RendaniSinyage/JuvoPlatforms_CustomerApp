import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../../infrastructure/repository/loans_repository.dart';
import '../../../../infrastructure/services/app_helpers.dart';
import '../../../../infrastructure/services/tr_keys.dart';
import '../../../components/buttons/custom_button.dart';
import '../../../components/text_fields/outline_bordered_text_field.dart';
import '../../../components/title_icon.dart';
import '../../../theme/theme.dart';
import '../provider/loans_provider.dart';
import 'loan_document_upload_screen.dart';
import 'loan_ineligibility_dialog.dart';
import 'loan_qualification_dialog.dart';

@RoutePage()
class LoanEligibilityScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic>? financialDetails;

  const LoanEligibilityScreen({
    super.key,
    this.financialDetails,
  });

  @override
  ConsumerState<LoanEligibilityScreen> createState() =>
      _LoanEligibilityScreenState();
}

class _LoanEligibilityScreenState extends ConsumerState<LoanEligibilityScreen> {

  // Controllers for financial details
  final _monthlyIncomeController = TextEditingController();
  final _groceryExpensesController = TextEditingController();
  final _otherExpensesController = TextEditingController();
  final _existingCreditsController = TextEditingController();

  // Repositories
  late LoansRepository _loansRepository;

  // State variables
  bool _fieldsReadOnly = false;
  bool _isLoading = false;
  bool _hasDisqualifyingHistory = false;
  Map<String, dynamic>? _disqualificationReasons;

  @override
  void initState() {
    super.initState();

    // Check if financial details exist
    _fieldsReadOnly = widget.financialDetails != null &&
        (widget.financialDetails!['monthly_income'] != null ||
            widget.financialDetails!['grocery_expenses'] != null ||
            widget.financialDetails!['other_expenses'] != null ||
            widget.financialDetails!['existing_credits'] != null);

    // Initialize repository
    _loansRepository = LoansRepository();

    // Pre-populate controllers with saved data if available
    _populateFieldsFromSavedData();

    // Use post-frame callback to ensure the widget is built before showing snackbar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkLoanHistory();
    });
  }

  void _populateFieldsFromSavedData() {
    if (widget.financialDetails != null) {
      debugPrint('Populating fields from saved data: ${widget.financialDetails}');

      // Extract values from financial details
      final monthlyIncome = widget.financialDetails!['monthly_income'];
      final groceryExpenses = widget.financialDetails!['grocery_expenses'];
      final otherExpenses = widget.financialDetails!['other_expenses'];
      final existingCredits = widget.financialDetails!['existing_credits'];

      // Set controller values with proper formatting
      if (monthlyIncome != null) {
        _monthlyIncomeController.text = _formatCurrency(monthlyIncome);
      }

      if (groceryExpenses != null) {
        _groceryExpensesController.text = _formatCurrency(groceryExpenses);
      }

      if (otherExpenses != null) {
        _otherExpensesController.text = _formatCurrency(otherExpenses);
      }

      if (existingCredits != null) {
        _existingCreditsController.text = _formatCurrency(existingCredits);
      }
    }
  }

  // Helper to format currency values
  String _formatCurrency(dynamic value) {
    if (value == null) return '';

    // Convert to double if it's not already
    double numValue = 0;
    if (value is String) {
      numValue = double.tryParse(value) ?? 0;
    } else if (value is num) {
      numValue = value.toDouble();
    }

    // Format with commas
    final formatter = NumberFormat('#,##0');
    return formatter.format(numValue);
  }

  @override
  void dispose() {
    _monthlyIncomeController.dispose();
    _groceryExpensesController.dispose();
    _otherExpensesController.dispose();
    _existingCreditsController.dispose();
    super.dispose();
  }

  Future<void> _checkLoanHistory() async {
    debugPrint("Starting loan history check");
    setState(() {
      _isLoading = true;
    });

    try {
      final result = await _loansRepository.checkLoanHistoryEligibility();
      debugPrint("Got loan history eligibility result");

      result.when(
        success: (historyData) {
          debugPrint("Loan history success: $historyData");
          setState(() {
            _hasDisqualifyingHistory =
                historyData['has_disqualifying_history'] ?? false;
            _disqualificationReasons = historyData;
            _isLoading = false;
          });
        },
        failure: (error, statusCode) {
          debugPrint("Loan history failure: $error, code: $statusCode");
          setState(() {
            _isLoading = false;
          });
          AppHelpers.showCheckTopSnackBarInfo(context, error);
        },
      );
    } catch (e) {
      debugPrint("Loan history exception: $e");
      setState(() {
        _isLoading = false;
      });
      AppHelpers.showCheckTopSnackBarInfo(
        context,
        'Failed to check loan history',
      );
    }
  }


  Future<void> _checkFinancialEligibility() async {
    // Validate input fields
    if (!_validateInputs()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Parse and store financial details
      final monthlyIncome = double.parse(_monthlyIncomeController.text.replaceAll(',', ''));
      final groceryExpenses = double.parse(_groceryExpensesController.text.replaceAll(',', ''));
      final otherExpenses = double.parse(_otherExpensesController.text.replaceAll(',', ''));
      final existingCredits = double.parse(_existingCreditsController.text.replaceAll(',', ''));

      // Create financial details map
      final financialDetails = {
        'monthly_income': monthlyIncome,
        'grocery_expenses': groceryExpenses,
        'other_expenses': otherExpenses,
        'existing_credits': existingCredits,
      };

      // Store financial details in provider
      ref.read(financialDetailsProvider.notifier).state = financialDetails;

      // Check basic eligibility first
      final result = await _loansRepository.checkFinancialEligibility(
        monthlyIncome: monthlyIncome,
        groceryExpenses: groceryExpenses,
        otherExpenses: otherExpenses,
        existingCredits: existingCredits,
      );

      result.when(
        success: (eligibilityData) {
          if (eligibilityData['is_eligible'] ?? false) {
            // If eligible, calculate pre-approval amount
            _calculatePreApprovalAmount(financialDetails);
          } else {
            // Show ineligibility dialog
            setState(() {
              _isLoading = false;
            });
            _showIneligibilityDialog(eligibilityData);
          }
        },
        failure: (error, statusCode) {
          setState(() {
            _isLoading = false;
          });
          AppHelpers.showCheckTopSnackBarInfo(context, error);
        },
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      AppHelpers.showCheckTopSnackBarInfo(
        context,
        'Failed to check financial eligibility',
      );
    }
  }

  Future<void> _calculatePreApprovalAmount(Map<String, dynamic> financialDetails) async {
    try {
      // Pass the financial details to the repository method
      final preApprovalResult = await _loansRepository.calculatePreApprovalAmount(financialDetails);

      preApprovalResult.when(
        success: (amount) {
          setState(() {
            _isLoading = false;
          });
          _showQualificationDialog(amount);
        },
        failure: (error, statusCode) {
          setState(() {
            _isLoading = false;
          });
          AppHelpers.showCheckTopSnackBarInfo(context, error);
        },
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      AppHelpers.showCheckTopSnackBarInfo(
        context,
        'Failed to calculate pre-approval amount',
      );
    }
  }

  void _showQualificationDialog(double preApprovalAmount) {
    AppHelpers.showAlertDialog(
      isDismissible: false,
      context: context,
      child: LoanQualificationDialog(
        eligibilityData: {},
        qualifyingAmount: preApprovalAmount,
        onAccept: () {
          // Store the pre-approved amount
          ref.read(loanAmountProvider.notifier).state = preApprovalAmount;
          ref.read(acceptedQualifyingAmountProvider.notifier).state = preApprovalAmount;

          // Continue to document upload
          _navigateToDocumentUpload();
        },
        onDecline: () {
          // Mark application as cancelled
          _cancelApplication();
        },
      ),
    );
  }

  // Add this method to handle application cancellation
  Future<void> _cancelApplication() async {
    try {
      // Get current financial details
      final financialDetails = ref.read(financialDetailsProvider);

      // Prepare data for cancellation
      final cancellationData = {
        'id_number': ref.read(idNumberProvider),
        'loan_amount': ref.read(loanAmountProvider),
        'status': 'cancelled',  // Explicitly set status to cancelled
        'additional_data': {
          'financial_details': financialDetails,
          'cancellation_reason': 'User declined pre-approval offer',
          'cancellation_date': DateTime.now().toIso8601String(),
        }
      };

      debugPrint('Cancelling application with data: $cancellationData');

      // Use saveIncompleteLoanApplication to save with cancelled status
      final result = await _loansRepository.saveIncompleteLoanApplication(
        financialDetails: cancellationData,
      );

      result.when(
        success: (_) {
          AppHelpers.showCheckTopSnackBarInfo(
              context,
              'Loan application cancelled'
          );
        },
        failure: (error, _) {
          debugPrint('Failed to mark application as cancelled: $error');
        },
      );

      // Return to loan screen
      Navigator.of(context).pop();

    } catch (e) {
      debugPrint('Error in cancel flow: $e');
      // Still return to loan screen
      Navigator.of(context).pop();
    }
  }

// Also update the save method to use the provider
  Future<void> _saveIncompleteLoanApplication() async {
    // Validate input fields
    if (!_validateInputs()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      debugPrint("Saving incomplete loan application");

      // Parse financial values from input fields
      final monthlyIncome = double.parse(_monthlyIncomeController.text.replaceAll(',', ''));
      final groceryExpenses = double.parse(_groceryExpensesController.text.replaceAll(',', ''));
      final otherExpenses = double.parse(_otherExpensesController.text.replaceAll(',', ''));
      final existingCredits = double.parse(_existingCreditsController.text.replaceAll(',', ''));

      // Store financial details in the provider for access in document upload screen
      ref.read(financialDetailsProvider.notifier).state = {
        'monthly_income': monthlyIncome,
        'grocery_expenses': groceryExpenses,
        'other_expenses': otherExpenses,
        'existing_credits': existingCredits,
      };

      final financialDetails = {
        'monthly_income': monthlyIncome,
        'grocery_expenses': groceryExpenses,
        'other_expenses': otherExpenses,
        'existing_credits': existingCredits,
      };

      debugPrint("Financial details: $financialDetails");

      final result = await _loansRepository.saveIncompleteLoanApplication(
        financialDetails: {
          'id_number': ref.read(idNumberProvider),
          'loan_amount': ref.read(loanAmountProvider),
          'financial_details': financialDetails,
        },
      );

      result.when(
        success: (applicationId) {
          debugPrint(
              "Save incomplete success - Application ID: $applicationId");
          setState(() {
            _isLoading = false;
          });

          AppHelpers.showCheckTopSnackBarDone(
            context,
            'Application saved. You can continue later.',
          );

          // Optionally navigate back or to a dashboard
          Navigator.of(context).pop();
        },
        failure: (error, statusCode) {
          debugPrint("Save incomplete failure: $error, code: $statusCode");
          setState(() {
            _isLoading = false;
          });
          AppHelpers.showCheckTopSnackBarInfo(context, error);
        },
      );
    } catch (e) {
      debugPrint("Save incomplete exception: $e");
      setState(() {
        _isLoading = false;
      });
      AppHelpers.showCheckTopSnackBarInfo(
        context,
        'Failed to save loan application',
      );
    }
  }

  bool _validateInputs() {
    // Check for empty fields
    if (_monthlyIncomeController.text.isEmpty ||
        _groceryExpensesController.text.isEmpty ||
        _otherExpensesController.text.isEmpty ||
        _existingCreditsController.text.isEmpty) {
      AppHelpers.showCheckTopSnackBarInfo(
        context,
        'Please fill in all financial details',
      );
      return false;
    }

    // Parse values to check for zeros
    try {
      final monthlyIncome = double.parse(_monthlyIncomeController.text.replaceAll(',', ''));
      final groceryExpenses = double.parse(_groceryExpensesController.text.replaceAll(',', ''));
      final otherExpenses = double.parse(_otherExpensesController.text.replaceAll(',', ''));

      // Check for zero or negative values
      if (groceryExpenses <= 0) {
        AppHelpers.showCheckTopSnackBarInfo(
          context,
          'Grocery expenses must be greater than zero',
        );
        return false;
      }

      if (otherExpenses <= 0) {
        AppHelpers.showCheckTopSnackBarInfo(
          context,
          'Other monthly expenses must be greater than zero',
        );
        return false;
      }

      // Make sure monthly income is at least greater than expenses
      if (monthlyIncome <= 0) {
        AppHelpers.showCheckTopSnackBarInfo(
          context,
          'Monthly income must be greater than zero',
        );
        return false;
      }

    } catch (e) {
      debugPrint('Error parsing financial values: $e');
      AppHelpers.showCheckTopSnackBarInfo(
        context,
        'Please enter valid financial details',
      );
      return false;
    }

    return true;
  }

  void _navigateToDocumentUpload() {
    WidgetsBinding.instance.addPostFrameCallback((_) {

    // First pop the current screen
    Navigator.of(context).pop();

    AppHelpers.showCustomModalBottomSheet(
      context: context,
      modal: ProviderScope(
        child: Consumer(
          builder: (context, ref, _) => LoanDocumentUploadScreen(
            prefilledIdNumber: ref.read(idNumberProvider),
          ),
        ),
      ),
      isDarkMode: false,
    );
    });
  }

  void _showIneligibilityDialog(Map<String, dynamic> eligibilityData) {
    AppHelpers.showAlertDialog(
      isDismissible: false,
      context: context,
      child: LoanIneligibilityDialog(
        eligibilityData: eligibilityData,
        onUnderstood: () {
          // Mark application as rejected and return to loan screen
          _markApplicationAsRejected();
          Navigator.of(context).pop(); // Pop this dialog
          Navigator.of(context).pop(); // Pop eligibility screen
        },
      ),
    );
  }

  Future<void> _markApplicationAsRejected() async {
    try {
      // Get financial details to store them with the rejection
      final financialDetails = {
        'id_number': ref.read(idNumberProvider),
        'loan_amount': ref.read(loanAmountProvider),
        'financial_details': {
          'monthly_income':
          double.tryParse(_monthlyIncomeController.text.replaceAll(',', '')) ?? 0,
          'grocery_expenses':
          double.tryParse(_groceryExpensesController.text.replaceAll(',', '')) ?? 0,
          'other_expenses':
          double.tryParse(_otherExpensesController.text.replaceAll(',', '')) ?? 0,
          'existing_credits':
          double.tryParse(_existingCreditsController.text.replaceAll(',', '')) ?? 0,
        },
        'rejection_reason': 'Failed eligibility check',
        'rejection_date': DateTime.now().toIso8601String(),
        'status': 'rejected'  // Explicitly set the status
      };

      debugPrint('Marking application as rejected with data: $financialDetails');

      // Call API to mark application as rejected
      final result = await _loansRepository.markApplicationAsRejected(
        financialDetails: financialDetails,
      );

      result.when(
        success: (_) {
          AppHelpers.showCheckTopSnackBarDone(
            context,
            'Your loan application has been marked as ineligible',
          );
        },
        failure: (error, _) {
          // Show error to user if marking fails
          AppHelpers.showCheckTopSnackBarInfo(
            context,
            'Failed to mark application as ineligible: $error',
          );
          debugPrint('Failed to mark application as rejected: $error');
        },
      );
    } catch (e) {
      AppHelpers.showCheckTopSnackBarInfo(
        context,
        'An error occurred while processing your application',
      );
      debugPrint('Error marking application as rejected: $e');
    }
  }


  List<Widget> _buildIneligibilityReasons(
      Map<String, dynamic> eligibilityData) {
    List<Widget> reasons = [];

    if (eligibilityData['income_too_low'] == true) {
      reasons.add(Text(
        '• Monthly income is insufficient',
        style: AppStyle.interNormal(size: 14.sp),
      ));
    }

    if (eligibilityData['debt_to_income_ratio_high'] == true) {
      reasons.add(Text(
        '• Debt-to-income ratio is too high',
        style: AppStyle.interNormal(size: 14.sp),
      ));
    }

    // Add more specific reasons as needed

    return reasons;
  }

  @override
  Widget build(BuildContext context) {
    // If there's a disqualifying history, show immediate ineligibility
    if (_hasDisqualifyingHistory) {
      return Container(
        decoration: BoxDecoration(
          color: AppStyle.bgGrey.withOpacity(0.96),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.r),
            topRight: Radius.circular(16.r),
          ),
        ),
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
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
                title: 'Loan Eligibility',
                paddingHorizontalSize: 0,
                titleSize: 18,
              ),
              Expanded(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64.r,
                          color: AppStyle.red,
                        ),
                        16.verticalSpace,
                        Text(
                          'Loan Application Declined',
                          style: AppStyle.interBold(
                            size: 18.sp,
                            color: AppStyle.red,
                          ),
                        ),
                        16.verticalSpace,
                        Text(
                          'Based on your loan history, we are unable to process your application.',
                          style: AppStyle.interNormal(
                            size: 14.sp,
                            color: AppStyle.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        16.verticalSpace,
                        ..._buildHistoryDisqualificationReasons(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Main eligibility input screen
    return Container(
      decoration: BoxDecoration(
        color: AppStyle.bgGrey.withOpacity(0.96),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.r),
          topRight: Radius.circular(16.r),
        ),
      ),
      width: double.infinity,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.75,
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
              title: 'Loan Eligibility',
              paddingHorizontalSize: 0,
              titleSize: 18,
            ),
            24.verticalSpace,
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Financial Details',
                      style: AppStyle.interSemi(size: 16.sp),
                    ),
                    16.verticalSpace,

                    // Monthly Income
                    Text(
                      'Monthly Income',
                      style: AppStyle.interNormal(size: 14.sp),
                    ),
                    8.verticalSpace,
                    Stack(
                      children: [
                        OutlinedBorderTextField(
                          textController: _monthlyIncomeController,
                          label: 'Enter monthly income',
                          inputType: TextInputType.number,
                          inputFormatters: _fieldsReadOnly
                              ? [] // No formatters needed if read-only
                              : [
                            FilteringTextInputFormatter.digitsOnly,
                            _CurrencyInputFormatter(),
                          ],
                        ),
                        if (_fieldsReadOnly)
                          Positioned.fill(
                            child: GestureDetector(
                              onTap: () {
                                AppHelpers.showCheckTopSnackBarInfo(
                                    context,
                                    'This field cannot be modified for a saved application'
                                );
                              },
                              child: Container(
                                color: Colors.transparent,
                              ),
                            ),
                          ),
                      ],
                    ),

                    16.verticalSpace,

                    // Grocery Expenses
                    Text(
                      'Monthly Grocery Expenses',
                      style: AppStyle.interNormal(size: 14.sp),
                    ),
                    8.verticalSpace,
                    Stack(
                      children: [
                        OutlinedBorderTextField(
                          textController: _groceryExpensesController,
                          label: 'Enter grocery expenses',
                          inputType: TextInputType.number,
                          inputFormatters: _fieldsReadOnly
                              ? [] // No formatters needed if read-only
                              : [
                            FilteringTextInputFormatter.digitsOnly,
                            _CurrencyInputFormatter(),
                          ],
                        ),
                        if (_fieldsReadOnly)
                          Positioned.fill(
                            child: GestureDetector(
                              onTap: () {
                                AppHelpers.showCheckTopSnackBarInfo(
                                    context,
                                    'This field cannot be modified for a saved application'
                                );
                              },
                              child: Container(
                                color: Colors.transparent,
                              ),
                            ),
                          ),
                      ],
                    ),

                    16.verticalSpace,

                    // Other Expenses
                    Text(
                      'Other Monthly Expenses',
                      style: AppStyle.interNormal(size: 14.sp),
                    ),
                    8.verticalSpace,
                    Stack(
                      children: [
                        OutlinedBorderTextField(
                          textController: _otherExpensesController,
                          label: 'Enter other expenses',
                          inputType: TextInputType.number,
                          inputFormatters: _fieldsReadOnly
                              ? [] // No formatters needed if read-only
                              : [
                            FilteringTextInputFormatter.digitsOnly,
                            _CurrencyInputFormatter(),
                          ],
                        ),
                        if (_fieldsReadOnly)
                          Positioned.fill(
                            child: GestureDetector(
                              onTap: () {
                                AppHelpers.showCheckTopSnackBarInfo(
                                    context,
                                    'This field cannot be modified for a saved application'
                                );
                              },
                              child: Container(
                                color: Colors.transparent,
                              ),
                            ),
                          ),
                      ],
                    ),

                    16.verticalSpace,

                    // Existing Credits
                    Text(
                      'Total Existing Credits',
                      style: AppStyle.interNormal(size: 14.sp),
                    ),
                    8.verticalSpace,
                    Stack(
                      children: [
                        OutlinedBorderTextField(
                          textController: _existingCreditsController,
                          label: 'Enter existing credits',
                          inputType: TextInputType.number,
                          inputFormatters: _fieldsReadOnly
                              ? [] // No formatters needed if read-only
                              : [
                            FilteringTextInputFormatter.digitsOnly,
                            _CurrencyInputFormatter(),
                          ],
                        ),
                        if (_fieldsReadOnly)
                          Positioned.fill(
                            child: GestureDetector(
                              onTap: () {
                                AppHelpers.showCheckTopSnackBarInfo(
                                    context,
                                    'This field cannot be modified for a saved application'
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

                    // Buttons
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            title: AppHelpers.getTranslation(TrKeys.saveForLater),
                            background: AppStyle.white,
                            borderColor: AppStyle.primary,
                            textColor: AppStyle.primary,
                            onPressed: _saveIncompleteLoanApplication,
                            isLoading: _isLoading,
                          ),
                        ),
                        16.horizontalSpace,
                        Expanded(
                          child: CustomButton(
                            title: 'Check Eligibility',
                            isLoading: _isLoading,
                            onPressed: _checkFinancialEligibility,
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
    );
  }

  List<Widget> _buildHistoryDisqualificationReasons() {
    final reasons = <Widget>[];

    if (_disqualificationReasons?['has_unpaid_loans'] == true) {
      reasons.add(Text(
        '• Unpaid previous loans detected',
        style: AppStyle.interNormal(
          size: 14.sp,
          color: AppStyle.black,
        ),
      ));
    }

    if (_disqualificationReasons?['has_declined_loans'] == true) {
      reasons.add(Text(
        '• Previous loan applications were declined',
        style: AppStyle.interNormal(
          size: 14.sp,
          color: AppStyle.black,
        ),
      ));
    }

    return reasons;
  }

}

// Custom currency input formatter
class _CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // Remove all non-digits
    String newText = newValue.text.replaceAll(RegExp(r'[^\d]'), '');

    // Convert to number and format
    double value = double.parse(newText);
    final formatter = NumberFormat('#,##0');
    String formattedText = formatter.format(value);

    return newValue.copyWith(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}