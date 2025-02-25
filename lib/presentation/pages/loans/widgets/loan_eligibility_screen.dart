import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../../infrastructure/repository/loans_repository.dart';
import '../../../../infrastructure/services/app_helpers.dart';
import '../../../components/app_bars/common_app_bar.dart';
import '../../../components/buttons/custom_button.dart';
import '../../../components/text_fields/outline_bordered_text_field.dart';
import '../../../theme/theme.dart';
import '../provider/loans_provider.dart';
import 'loan_document_upload_screen.dart';
import 'loan_ineligibility_dialog.dart';

@RoutePage()
class LoanEligibilityScreen extends ConsumerStatefulWidget {
  const LoanEligibilityScreen({super.key});

  @override
  ConsumerState<LoanEligibilityScreen> createState() => _LoanEligibilityScreenState();
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
  bool _isLoading = false;
  bool _hasDisqualifyingHistory = false;
  Map<String, dynamic>? _disqualificationReasons;

  @override
  void initState() {
    super.initState();

    // Initialize repository - THIS WAS MISSING
    _loansRepository = LoansRepository();

    // Use post-frame callback to ensure the widget is built before showing snackbar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkLoanHistory();
    });
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
            _hasDisqualifyingHistory = historyData['has_disqualifying_history'] ?? false;
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
      debugPrint("Checking financial eligibility");
      final result = await _loansRepository.checkFinancialEligibility(
        monthlyIncome: double.parse(_monthlyIncomeController.text.replaceAll(',', '')),
        groceryExpenses: double.parse(_groceryExpensesController.text.replaceAll(',', '')),
        otherExpenses: double.parse(_otherExpensesController.text.replaceAll(',', '')),
        existingCredits: double.parse(_existingCreditsController.text.replaceAll(',', '')),
      );

      result.when(
        success: (eligibilityData) {
          debugPrint("Financial eligibility success: $eligibilityData");
          setState(() {
            _isLoading = false;
          });

          if (eligibilityData['is_eligible'] ?? false) {
            // Navigate to document upload screen
            _navigateToDocumentUpload();
          } else {
            // Show ineligibility reasons
            _showIneligibilityDialog(eligibilityData);
          }
        },
        failure: (error, statusCode) {
          debugPrint("Financial eligibility failure: $error, code: $statusCode");
          setState(() {
            _isLoading = false;
          });
          AppHelpers.showCheckTopSnackBarInfo(context, error);
        },
      );
    } catch (e) {
      debugPrint("Financial eligibility exception: $e");
      setState(() {
        _isLoading = false;
      });
      AppHelpers.showCheckTopSnackBarInfo(
        context,
        'Failed to check financial eligibility',
      );
    }
  }

  Future<void> _saveIncompleteLoanApplication() async {
    // Validate input fields
    if (!_validateInputs()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      debugPrint("Saving incomplete loan application");
      final financialDetails = {
        'monthly_income': double.parse(_monthlyIncomeController.text.replaceAll(',', '')),
        'grocery_expenses': double.parse(_groceryExpensesController.text.replaceAll(',', '')),
        'other_expenses': double.parse(_otherExpensesController.text.replaceAll(',', '')),
        'existing_credits': double.parse(_existingCreditsController.text.replaceAll(',', '')),
      };

      debugPrint("Financial details: $financialDetails");

      final result = await _loansRepository.saveIncompleteLoanApplication(
        financialDetails: financialDetails,
      );

      result.when(
        success: (applicationId) {
          debugPrint("Save incomplete success - Application ID: $applicationId");
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
    // Validate all input fields
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

    // Additional validation can be added here
    return true;
  }

  void _navigateToDocumentUpload() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const LoanDocumentUploadScreen(),
      ),
    );
  }

  void _showIneligibilityDialog(Map<String, dynamic> eligibilityData) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: LoanIneligibilityDialog(
            eligibilityData: eligibilityData,
            onUnderstood: () {
              // Mark application as rejected and return to loan screen
              _markApplicationAsRejected();
              Navigator.of(context).pop(); // Pop this dialog
              Navigator.of(context).pop(); // Pop eligibility screen
            },
          ),
        );
      },
    );
  }

  Future<void> _markApplicationAsRejected() async {
    try {
      // Get financial details to store them with the rejection
      final financialDetails = {
        'monthly_income': double.parse(_monthlyIncomeController.text.replaceAll(',', '')),
        'grocery_expenses': double.parse(_groceryExpensesController.text.replaceAll(',', '')),
        'other_expenses': double.parse(_otherExpensesController.text.replaceAll(',', '')),
        'existing_credits': double.parse(_existingCreditsController.text.replaceAll(',', '')),
        'rejection_reason': 'Failed eligibility check',
        'rejection_date': DateTime.now().toIso8601String(),
      };

      // Call API to mark application as rejected
      final result = await _loansRepository.markApplicationAsRejected(
        financialDetails: financialDetails,
        amount: ref.read(loanAmountProvider),
      );

      result.when(
        success: (_) {
          AppHelpers.showCheckTopSnackBarInfo(
            context,
            'Your application has been marked as ineligible',
          );
        },
        failure: (error, _) {
          // Silently handle error
          debugPrint('Failed to mark application as rejected: $error');
        },
      );
    } catch (e) {
      debugPrint('Error marking application as rejected: $e');
    }
  }

  List<Widget> _buildIneligibilityReasons(Map<String, dynamic> eligibilityData) {
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
      return Scaffold(
        backgroundColor: AppStyle.bgGrey,
        body: Column(
          children: [
            CommonAppBar(
              child: Text(
                'Loan Eligibility',
                style: AppStyle.interNoSemi(
                  size: 18,
                  color: AppStyle.black,
                ),
              ),
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
      );
    }

    // Main eligibility input screen
    return Scaffold(
      backgroundColor: AppStyle.bgGrey,
      body: Column(
        children: [
          CommonAppBar(
            child: Text(
              'Loan Eligibility',
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
                  OutlinedBorderTextField(
                    textController: _monthlyIncomeController,
                    label: 'Enter monthly income',
                    inputType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      _CurrencyInputFormatter(),
                    ],
                  ),

                  16.verticalSpace,

                  // Grocery Expenses
                  Text(
                    'Monthly Grocery Expenses',
                    style: AppStyle.interNormal(size: 14.sp),
                  ),
                  8.verticalSpace,
                  OutlinedBorderTextField(
                    textController: _groceryExpensesController,
                    label: 'Enter grocery expenses',
                    inputType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      _CurrencyInputFormatter(),
                    ],
                  ),

                  16.verticalSpace,

                  // Other Expenses
                  Text(
                    'Other Monthly Expenses',
                    style: AppStyle.interNormal(size: 14.sp),
                  ),
                  8.verticalSpace,
                  OutlinedBorderTextField(
                    textController: _otherExpensesController,
                    label: 'Enter other expenses',
                    inputType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      _CurrencyInputFormatter(),
                    ],
                  ),

                  16.verticalSpace,

                  // Existing Credits
                  Text(
                    'Total Existing Credits',
                    style: AppStyle.interNormal(size: 14.sp),
                  ),
                  8.verticalSpace,
                  OutlinedBorderTextField(
                    textController: _existingCreditsController,
                    label: 'Enter existing credits',
                    inputType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      _CurrencyInputFormatter(),
                    ],
                  ),

                  24.verticalSpace,

                  // Buttons
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