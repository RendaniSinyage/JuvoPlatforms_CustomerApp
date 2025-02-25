import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../infrastructure/repository/loans_repository.dart';
import '../../../../infrastructure/services/app_helpers.dart';
import '../../../components/buttons/custom_button.dart';
import '../../../theme/theme.dart';

class LoanContractScreen extends ConsumerStatefulWidget {
  final dynamic loanApplication;

  const LoanContractScreen({
    super.key,
    required this.loanApplication,
  });

  @override
  ConsumerState<LoanContractScreen> createState() => _LoanContractScreenState();
}

class _LoanContractScreenState extends ConsumerState<LoanContractScreen> {
  late LoansRepository _loansRepository;
  bool _isLoading = false;
  dynamic _contract;

  @override
  void initState() {
    super.initState();
    _loansRepository = LoansRepository(); // Initialize repository
    _fetchLoanContract();
  }

  Future<void> _fetchLoanContract() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final result = await _loansRepository.fetchLoanContract(
          widget.loanApplication['id']
      );

      result.when(
        success: (contract) {
          setState(() {
            _contract = contract;
            _isLoading = false;
          });
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
        'Failed to fetch loan contract',
      );
    }
  }

  Future<void> _acceptContract() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Now passing both loanId and contractId parameters
      final result = await _loansRepository.acceptLoanContract(
        loanId: widget.loanApplication['id'],
        contractId: _contract['id'], // Add the missing contractId parameter
      );

      result.when(
        success: (_) {
          // Generate and send contract PDF
          _generateAndSendContractPdf(true);

          AppHelpers.showCheckTopSnackBarDone(
            context,
            'Contract accepted successfully',
          );

          // Use Navigator.pop instead of context.router.pop
          Navigator.of(context).pop();
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
        'Failed to accept contract',
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _declineContract() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final result = await _loansRepository.declineLoanContract(
        loanId: widget.loanApplication['id'],
      );

      result.when(
        success: (_) {
          AppHelpers.showCheckTopSnackBarDone(
            context,
            'Contract declined',
          );

          // Use Navigator.pop instead of context.router.pop
          Navigator.of(context).pop();
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
        'Failed to decline contract',
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _generateAndSendContractPdf(bool isAcceptance) async {
    try {
      // Request to backend to generate and email PDF
      final result = await _loansRepository.generateAndEmailContractPdf(
        loanId: widget.loanApplication['id'],
        isAcceptance: isAcceptance,
      );

      result.when(
        success: (_) {
          AppHelpers.showCheckTopSnackBarDone(
            context,
            'Contract PDF sent to your email',
          );
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
        'Failed to generate contract PDF',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: AppStyle.primary),
        ),
      );
    }

    if (_contract == null) {
      return Scaffold(
        body: Center(
          child: Text(
            'No contract available',
            style: AppStyle.interNormal(size: 16.sp),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Loan Contract', style: AppStyle.interSemi(size: 18.sp)),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _contract['title'],
              style: AppStyle.interBold(size: 18.sp),
            ),
            24.verticalSpace,
            Text(
              _contract['content'],
              style: AppStyle.interNormal(size: 14.sp),
            ),
            24.verticalSpace,
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    title: 'Decline',
                    background: AppStyle.white,
                    borderColor: AppStyle.red,
                    textColor: AppStyle.red,
                    onPressed: _declineContract,
                  ),
                ),
                16.horizontalSpace,
                Expanded(
                  child: CustomButton(
                    title: 'Accept',
                    onPressed: _acceptContract,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}