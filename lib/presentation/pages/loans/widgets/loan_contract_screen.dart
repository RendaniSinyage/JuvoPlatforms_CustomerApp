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

  // Scroll controller to track user's reading progress
  final ScrollController _scrollController = ScrollController();
  bool _hasReachedBottom = false;
  double _scrollProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _loansRepository = LoansRepository(); // Initialize repository
    _fetchLoanContract();

    // Add scroll listener to track reading progress
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  // Track scroll position to know when user reaches bottom
  void _onScroll() {
    if (_scrollController.hasClients) {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;

      // Calculate scroll progress percentage
      final newProgress = maxScroll > 0 ? (currentScroll / maxScroll) : 0.0;

      // Check if user has scrolled to at least 90% of the content
      final hasReachedBottom = maxScroll > 0 && currentScroll >= (maxScroll * 0.9);

      setState(() {
        _scrollProgress = newProgress;
        _hasReachedBottom = hasReachedBottom;
      });
    }
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
      // Passing both loanId and contractId parameters
      final result = await _loansRepository.acceptLoanContract(
        loanId: widget.loanApplication['id'],
        contractId: _contract.id, // Access the id property of the contract object
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
        appBar: AppBar(
          title: Text('Loan Contract', style: AppStyle.interSemi(size: 18.sp)),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          // Contract content
          Expanded(
            child: Stack(
              children: [
                // Scrollable contract content
                SingleChildScrollView(
                  controller: _scrollController,
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _contract.title,
                        style: AppStyle.interBold(size: 18.sp),
                      ),
                      24.verticalSpace,
                      Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: AppStyle.white,
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(color: AppStyle.borderColor),
                        ),
                        child: Text(
                          _contract.content,
                          style: AppStyle.interNormal(size: 14.sp),
                        ),
                      ),
                      // Extra space at bottom to ensure scrolling works properly
                      100.verticalSpace,
                    ],
                  ),
                ),

                // Scroll progress indicator
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: SizedBox(
                    height: 4.h,
                    child: LinearProgressIndicator(
                      value: _scrollProgress,
                      backgroundColor: AppStyle.borderColor,
                      valueColor: AlwaysStoppedAnimation<Color>(AppStyle.primary),
                    ),
                  ),
                ),

                // Scrolling hint if not scrolled enough
                if (!_hasReachedBottom)
                  Positioned(
                    bottom: 80.h,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                        decoration: BoxDecoration(
                          color: AppStyle.primary.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.arrow_downward, color: AppStyle.primary, size: 16.r),
                            8.horizontalSpace,
                            Text(
                              'Please review the entire contract',
                              style: AppStyle.interNormal(size: 12.sp, color: AppStyle.primary),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Action buttons
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: AppStyle.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                topRight: Radius.circular(16.r),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppStyle.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(0, -5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Show message about reading the contract
                if (!_hasReachedBottom)
                  Padding(
                    padding: EdgeInsets.only(bottom: 12.h),
                    child: Text(
                      'Please read the full contract terms before accepting',
                      style: AppStyle.interNormal(size: 12.sp, color: AppStyle.textGrey),
                      textAlign: TextAlign.center,
                    ),
                  ),

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
                        onPressed: _hasReachedBottom ? _acceptContract : null,
                        isLoading: _isLoading,
                        // Disable button if user hasn't scrolled to bottom
                        background: _hasReachedBottom
                            ? AppStyle.primary
                            : AppStyle.primary.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}