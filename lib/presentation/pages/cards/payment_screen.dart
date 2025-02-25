import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../application/shop_order/shop_order_provider.dart';
import '../../../domain/di/dependency_manager.dart';
import '../../../infrastructure/models/data/order_body_data.dart';
import '../../../infrastructure/models/data/saved_card.dart';
import '../../../infrastructure/services/app_helpers.dart';
import '../../../infrastructure/services/tr_keys.dart';
import '../../../utils/payfast/payfast_webview.dart';
import '../../components/buttons/custom_button.dart';
import '../../routes/app_router.dart';
import '../../theme/theme.dart';
import 'payment_card.dart';

class PaymentScreen extends ConsumerStatefulWidget {
  final OrderBodyData? orderData;
  final Function(bool) onPaymentComplete;
  final ScrollController? scrollController;
  final bool tokenizeOnly;

  const PaymentScreen({
    super.key,
    this.orderData,
    required this.onPaymentComplete,
    this.scrollController,
    this.tokenizeOnly = false,
  });

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  final _repository = ordersRepository;
  bool _isLoading = false;
  bool _loadingCards = true;
  List<SavedCardModel> _savedCards = [];
  SavedCardModel? _selectedCard;

  @override
  void initState() {
    super.initState();
    _checkSavedCards();
  }

  Future<void> _checkSavedCards() async {
    setState(() {
      _loadingCards = true;
    });

    try {
      final result = await _repository.getSavedCards();

      result.when(
        success: (cards) {
          setState(() {
            _savedCards = cards;
            _loadingCards = false;
          });
        },
        failure: (error, statusCode) {
          setState(() {
            _loadingCards = false;
          });
          AppHelpers.showCheckTopSnackBarInfo(
            context,
            'Failed to check saved cards: $error',
          );
        },
      );
    } catch (e) {
      setState(() {
        _loadingCards = false;
      });

      AppHelpers.showCheckTopSnackBarInfo(
        context,
        'Failed to check saved cards',
      );
    }
  }

  // Process payment with saved card token
  Future<void> _processTokenPayment() async {
    if (_selectedCard == null) {
      AppHelpers.showCheckTopSnackBarInfo(
        context,
        AppHelpers.getTranslation(TrKeys.selectCard),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await _repository.processTokenPayment(
        widget.orderData!,
        _selectedCard!.token,
      );

      result.when(
        success: (transactionId) {
          // Show success message
          AppHelpers.showCheckTopSnackBarDone(
              context,
              AppHelpers.getTranslation(TrKeys.paymentSuccessful)
          );

          // Add a slight delay to ensure snackbar is visible
          Future.delayed(const Duration(milliseconds: 1000), () {
            // Refresh cart
            ref.read(shopOrderProvider.notifier).getCart(
                context,
                    () {},
                isShowLoading: false
            );

            // Call the payment complete callback
            widget.onPaymentComplete(true);

            // Optional: Navigate to main route if needed
            context.replaceRoute(const MainRoute());
          });
        },
        failure: (error, statusCode) {
          setState(() {
            _isLoading = false;
          });

          AppHelpers.showCheckTopSnackBarInfo(
            context,
            error,
          );
        },
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      AppHelpers.showCheckTopSnackBarInfo(
        context,
        'Payment processing failed. Please try again.',
      );
    }
  }

  // Redirects to PayFast WebView for payment
  Future<void> _redirectToPayFastWebView() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final result = await _repository.process(
        widget.orderData!,
        'pay-fast',
        context: context,
        forceCardPayment: true,
        enableTokenization: true,
      );

      setState(() {
        _isLoading = false;
      });

      result.when(
        success: (paymentUrl) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PayFastWebView(
                url: paymentUrl,
                onComplete: (success) {
                  if (success) {
                    // Refresh the cards list
                    _checkSavedCards();
                    widget.onPaymentComplete(true);
                  } else {
                    widget.onPaymentComplete(false);
                  }
                },
              ),
            ),
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
      setState(() {
        _isLoading = false;
      });

      AppHelpers.showCheckTopSnackBarInfo(
        context,
        'Failed to start payment process',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine height constraint based on number of saved cards
    BoxConstraints? heightConstraint;

    // Only apply height constraint if there are fewer than 2 saved cards
    if (!_loadingCards && _savedCards.length <= 2) {
      heightConstraint = BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.3, // Smaller height with fewer cards
      );
    }

    // Base container with background styling for all modes
    return Container(
      decoration: BoxDecoration(
        color: AppStyle.bgGrey.withOpacity(0.96),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.r),
          topRight: Radius.circular(16.r),
        ),
      ),
      width: double.infinity,
      // Conditionally apply height constraint
      constraints: heightConstraint,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    if (widget.tokenizeOnly) {
      // Simplified tokenize-only mode
      return _loadingCards
          ? Center(child: CircularProgressIndicator(color: AppStyle.primary))
          : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          4.verticalSpace,
          Center(
            child: Container(
              height: 4.h,
              width: 48.w,
              decoration: BoxDecoration(
                color: AppStyle.dragElement,
                borderRadius: BorderRadius.all(
                  Radius.circular(40.r),
                ),
              ),
            ),
          ),
          8.verticalSpace,
          Text(
            AppHelpers.getTranslation(TrKeys.cards),
            style: AppStyle.interBold(
              size: 20.sp, // Slightly smaller text
              color: AppStyle.black,
            ),
          ),
          8.verticalSpace,
          SavedCardsWidget(
            onCardSelected: (_) {}, // No action needed
            hideManagement: false, // Hide card management options
          ),
          16.verticalSpace, // Reduced bottom spacing
        ],
      );
    } else {
      // Regular payment mode with proper styling
      return _loadingCards
          ? Center(child: CircularProgressIndicator(color: AppStyle.primary))
          : SingleChildScrollView(
        controller: widget.scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            4.verticalSpace,
            Center(
              child: Container(
                height: 4.h,
                width: 48.w,
                decoration: BoxDecoration(
                  color: AppStyle.dragElement,
                  borderRadius: BorderRadius.all(
                    Radius.circular(40.r),
                  ),
                ),
              ),
            ),
            // Only show this section if we have saved cards
            if (_savedCards.isNotEmpty) ...[
              // Use the SavedCardsWidget
              SavedCardsWidget(
                onCardSelected: (card) {
                  setState(() {
                    _selectedCard = card;
                  });
                },
                hideManagement: false,
              ),

              4.verticalSpace,

              // Pay with selected card button - only show if card is selected
              if (_selectedCard != null)
                CustomButton(
                  isLoading: _isLoading,
                  title: AppHelpers.getTranslation(TrKeys.payWithSavedCard),
                  onPressed: _processTokenPayment,
                ),

              4.verticalSpace,
              Row(
                children: [
                  const Expanded(child: Divider(color: AppStyle.black)),
                ],
              ),
              4.verticalSpace,
            ],

            // Button to use PayFast WebView for new card
            CustomButton(
              isLoading: _isLoading,
              title: _selectedCard != null
                  ? AppHelpers.getTranslation(TrKeys.payWithNewCard)
                  : AppHelpers.getTranslation(TrKeys.payWithCard),
              onPressed: _redirectToPayFastWebView,
            ),

            10.verticalSpace,

            Center(
              child: Text(
                AppHelpers.getTranslation(TrKeys.cardWillBeSaved),
                style: AppStyle.interNormal(
                  size: 13.sp,
                  color: AppStyle.textGrey,
                ),
              ),
            ),
            16.verticalSpace,
          ],
        ),
      );
    }
  }
}
