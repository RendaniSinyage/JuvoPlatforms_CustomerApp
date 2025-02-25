import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../infrastructure/repository/loans_repository.dart';
import '../../../infrastructure/services/app_helpers.dart';
import '../../../infrastructure/services/tr_keys.dart';
import '../../components/app_bars/common_app_bar.dart';
import '../../components/buttons/custom_button.dart';
import '../../theme/theme.dart';
import 'widgets/loan_document_upload_screen.dart';
import 'widgets/loan_eligibility_screen.dart';
import 'provider/loans_provider.dart';

@RoutePage()
class LoanScreen extends ConsumerStatefulWidget {
  const LoanScreen({super.key});

  @override
  ConsumerState<LoanScreen> createState() => _LoanScreenState();
}

class _LoanScreenState extends ConsumerState<LoanScreen> {
  // Screen state variables
  List<dynamic> _loanTransactions = [];
  bool _isLoading = true;
  bool _isSubmitting = false;

  // Repository
  late LoansRepository _loansRepository;

  @override
  void initState() {
    super.initState();
    _loansRepository = LoansRepository();

    // Fetch existing transactions
    _fetchLoanTransactions();

    // Check for pending contracts
    _checkPendingContractLoans();

    // Check for saved incomplete applications
    _checkForSavedApplication();
  }

  Future<void> _fetchLoanTransactions() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final result = await _loansRepository.fetchLoanTransactions(1);

      result.when(
        success: (transactions) {
          setState(() {
            _loanTransactions = transactions;
            _isLoading = false;
          });
        },
        failure: (error, statusCode) {
          setState(() {
            _isLoading = false;
            _loanTransactions = [];
          });
          AppHelpers.showCheckTopSnackBarInfo(context, error);
        },
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
        _loanTransactions = [];
      });
      AppHelpers.showCheckTopSnackBarInfo(
        context,
        'Failed to load loan transactions',
      );
    }
  }

  Future<void> _checkPendingContractLoans() async {
    try {
      // Fetch loans with pending contract status
      final result = await _loansRepository.fetchLoanTransactions(1);

      result.when(
        success: (transactions) {
          // Find loans with 'pending_contract' status
          final pendingContractLoans = transactions
              .where((loan) =>
          loan['status']?.toString().toLowerCase() ==
              'pending_contract')
              .toList();

          if (pendingContractLoans.isNotEmpty) {
            // Update the pending contract provider
            ref.read(pendingContractProvider.notifier).state =
                pendingContractLoans.first;

            // Fetch contract details
            _fetchLoanContract(pendingContractLoans.first['id']?.toString());
          }
        },
        failure: (error, statusCode) {
          AppHelpers.showCheckTopSnackBarInfo(context, error);
        },
      );
    } catch (e) {
      AppHelpers.showCheckTopSnackBarInfo(
        context,
        'Failed to check pending contract loans',
      );
    }
  }

  Future<void> _checkForSavedApplication() async {
    try {
      final result = await _loansRepository.fetchSavedApplication();

      result.when(
          success: (applicationData) {
            if (applicationData.isNotEmpty) {
              // Update amount in provider
              if (applicationData['amount'] != null) {
                ref.read(loanAmountProvider.notifier).state =
                    double.tryParse(applicationData['amount'].toString()) ?? 200.0;
              }

              // Show a notification to the user that they have a saved application
              AppHelpers.showCheckTopSnackBarInfo(
                context,
                'You have a saved loan application. Your previous details have been loaded.',
              );

              // Optionally, ask if they want to continue with the saved application
              _showContinueSavedApplicationDialog(applicationData);
            }
          },
          failure: (error, statusCode) {
            // Silently handle error - no need to show to user
            debugPrint('Failed to check for saved applications: $error');
          }
      );
    } catch (e) {
      debugPrint('Error checking saved applications: $e');
    }
  }

  // Add this method to show a dialog for continuing a saved application
  Future<void> _showContinueSavedApplicationDialog(Map<String, dynamic> applicationData) async {
    final shouldContinue = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Continue Saved Application',
            style: AppStyle.interBold(size: 18.sp),
          ),
          content: Text(
            'You have a saved loan application. Would you like to continue where you left off?',
            style: AppStyle.interNormal(size: 14.sp),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Start New',
                style: AppStyle.interNormal(
                  size: 16.sp,
                  color: AppStyle.textGrey,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppStyle.primary,
              ),
              child: Text(
                'Continue',
                style: AppStyle.interSemi(
                  size: 16.sp,
                  color: AppStyle.white,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    ) ?? false;

    if (shouldContinue) {
      // Determine which screen to navigate to based on application state
      if (applicationData['documents'] != null) {
        // If documents were uploaded, go to document screen
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => LoanDocumentUploadScreen(
              prefilledIdNumber: applicationData['id_number'],
            ),
          ),
        );
      } else {
        // Otherwise go to eligibility screen
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const LoanEligibilityScreen()),
        );
      }
    }
  }

  Future<void> _fetchLoanContract(String? loanId) async {
    if (loanId == null) return;

    try {
      final result = await _loansRepository.fetchLoanContract(loanId);

      result.when(
        success: (contract) {
          // Show contract modal automatically
          _showDynamicContractModal(contract);
        },
        failure: (error, statusCode) {
          AppHelpers.showCheckTopSnackBarInfo(context, error);
        },
      );
    } catch (e) {
      AppHelpers.showCheckTopSnackBarInfo(
        context,
        'Failed to fetch loan contract',
      );
    }
  }

  Future<void> _showDynamicContractModal(dynamic contract) async {
    final accepted = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            contract.title,
            style: AppStyle.interBold(size: 18.sp),
          ),
          content: SingleChildScrollView(
            child: Text(
              contract.content,
              style: AppStyle.interNormal(size: 14.sp),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Decline',
                style: AppStyle.interNormal(
                  size: 16.sp,
                  color: AppStyle.red,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppStyle.primary,
              ),
              child: Text(
                'Accept',
                style: AppStyle.interSemi(
                  size: 16.sp,
                  color: AppStyle.white,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    ) ??
        false;

    if (accepted) {
      await _acceptLoanContract(contract);
    }
  }

  Future<void> _acceptLoanContract(dynamic contract) async {
    final pendingLoan = ref.read(pendingContractProvider);

    if (pendingLoan == null) {
      AppHelpers.showCheckTopSnackBarInfo(
        context,
        'No pending loan found',
      );
      return;
    }

    try {
      final result = await _loansRepository.acceptLoanContract(
        loanId: pendingLoan['id'].toString(),
        contractId: contract.id,
      );

      result.when(
        success: (_) {
          AppHelpers.showCheckTopSnackBarDone(
            context,
            'Loan contract accepted successfully',
          );

          // Clear pending contract
          ref.read(pendingContractProvider.notifier).state = null;

          // Refresh loan transactions
          _fetchLoanTransactions();
        },
        failure: (error, statusCode) {
          AppHelpers.showCheckTopSnackBarInfo(
            context,
            error,
          );
        },
      );
    } catch (e) {
      AppHelpers.showCheckTopSnackBarInfo(
        context,
        'Failed to accept loan contract',
      );
    }
  }

  void _navigateToLoanEligibilityScreen() {
    // Store the selected loan amount in provider before navigating
    // (The slider already updates the provider value when changed)

    // Navigate to the eligibility screen
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const LoanEligibilityScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Check for pending contract
    final pendingContract = ref.watch(pendingContractProvider);

    // If there's a pending contract, show contract acceptance view
    if (pendingContract != null) {
      return _buildPendingContractView(pendingContract);
    }

    return Scaffold(
      backgroundColor: AppStyle.bgGrey,
      body: Column(
        children: [
          CommonAppBar(
            child: Text(
              AppHelpers.getTranslation(TrKeys.loans),
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
                  16.verticalSpace,
                  // Previous Loans Section
                  _buildPreviousLoansSection(),

                  24.verticalSpace,

                  // Loan Amount Slider
                  Text(
                    'Loan Amount',
                    style: AppStyle.interSemi(size: 16.sp),
                  ),
                  16.verticalSpace,
                  _buildLoanAmountSlider(),

                  24.verticalSpace,

                  // Continue to Eligibility Check Button
                  CustomButton(
                    title: 'Continue to Eligibility Check',
                    onPressed: _navigateToLoanEligibilityScreen,
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

  Widget _buildPendingContractView(dynamic pendingLoan) {
    return Scaffold(
      backgroundColor: AppStyle.bgGrey,
      body: Column(
        children: [
          CommonAppBar(
            child: Text(
              'Loan Contract',
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
                      Icons.description_outlined,
                      size: 64.r,
                      color: AppStyle.primary,
                    ),
                    16.verticalSpace,
                    Text(
                      'Loan Contract Pending',
                      style: AppStyle.interBold(
                        size: 18.sp,
                        color: AppStyle.black,
                      ),
                    ),
                    16.verticalSpace,
                    Text('Your loan application requires contract acceptance.',
                        style: AppStyle.interNormal(
                          size: 14.sp,
                          color: AppStyle.black,
                        )),
                    16.verticalSpace,
                    Text(
                      'Loan Amount: ${AppHelpers.numberFormat(number: pendingLoan['amount'])}',
                      style: AppStyle.interNormal(
                        size: 14.sp,
                        color: AppStyle.textGrey,
                      ),
                    ),
                    24.verticalSpace,
                    CustomButton(
                      title: 'View Contract',
                      onPressed: () {
                        // Fetch and show contract details
                        _fetchLoanContract(pendingLoan['id']?.toString());
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviousLoansSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
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
      child: _isLoading
          ? Center(
        child: CircularProgressIndicator(color: AppStyle.primary),
      )
          : _loanTransactions.isEmpty
          ? Column(
        children: [
          Icon(
            Icons.credit_score_outlined,
            size: 48.r,
            color: AppStyle.textGrey,
          ),
          16.verticalSpace,
          Text(
            'No Previous Loans',
            style: AppStyle.interSemi(
              size: 16.sp,
              color: AppStyle.black,
            ),
          ),
          8.verticalSpace,
          Text(
            'Your active and previous loans will appear here',
            style: AppStyle.interNormal(
              size: 14.sp,
              color: AppStyle.textGrey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      )
          : ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _loanTransactions.length,
        separatorBuilder: (context, index) =>
        const Divider(color: AppStyle.borderColor),
        itemBuilder: (context, index) {
          final transaction = _loanTransactions[index];
          return ListTile(
            title: Text(
              'Loan Amount: ${AppHelpers.numberFormat(number: transaction['price'])}',
              style: AppStyle.interSemi(size: 14.sp),
            ),
            subtitle: Text(
              'Date: ${DateFormat('MMM dd, yyyy').format(DateTime.parse(transaction['created_at'] ?? DateTime.now().toString()))}',
              style: AppStyle.interNormal(
                size: 12.sp,
                color: AppStyle.textGrey,
              ),
            ),
            trailing: Text(
              transaction['status'] ?? '',
              style: AppStyle.interSemi(
                size: 14.sp,
                color: _getStatusColor(transaction['status']),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoanAmountSlider() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
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
      child: Column(
        children: [
          Text(
            'R ${NumberFormat('#,##0').format(ref.watch(loanAmountProvider))}',
            style: AppStyle.interBold(
              size: 18.sp,
              color: AppStyle.primary,
            ),
          ),
          16.verticalSpace,
          Slider(
            value: ref.watch(loanAmountProvider),
            min: 200,
            max: 10000,
            divisions: 98, // (10000 - 200) / 100
            label:
            'R ${NumberFormat('#,##0').format(ref.watch(loanAmountProvider))}',
            activeColor: AppStyle.primary,
            inactiveColor: AppStyle.borderColor,
            onChanged: (double value) {
              ref.read(loanAmountProvider.notifier).state =
                  value.roundToDouble();
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'R 200',
                style: AppStyle.interNormal(
                  size: 12.sp,
                  color: AppStyle.textGrey,
                ),
              ),
              Text(
                'R 10,000',
                style: AppStyle.interNormal(
                  size: 12.sp,
                  color: AppStyle.textGrey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String? status) {
    if (status == null) return AppStyle.textGrey;
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'rejected':
        return Colors.red;
      case 'pending_contract':
        return Colors.blue;
      default:
        return AppStyle.textGrey;
    }
  }
}