import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodyman/domain/di/dependency_manager.dart';
import 'package:foodyman/infrastructure/models/data/saved_card.dart';
import 'package:foodyman/infrastructure/services/app_helpers.dart';
import 'package:foodyman/infrastructure/services/local_storage.dart';
import 'package:foodyman/infrastructure/services/tr_keys.dart';
import 'package:foodyman/presentation/components/keyboard_dismisser.dart';
import 'package:foodyman/presentation/components/title_icon.dart';
import 'package:foodyman/presentation/theme/theme.dart';
import 'package:foodyman/utils/payfast/payfast_webview.dart';

import '../../cards/payment_card.dart';

class WalletTopUpScreen extends ConsumerStatefulWidget {
  const WalletTopUpScreen({super.key});

  @override
  ConsumerState<WalletTopUpScreen> createState() => _WalletTopUpScreenState();
}

class _WalletTopUpScreenState extends ConsumerState<WalletTopUpScreen> {
  final _amountController = TextEditingController();
  final _repository = ordersRepository;
  bool _isLoading = false;
  bool _loadingCards = true;
  List<SavedCardModel> _savedCards = [];
  SavedCardModel? _selectedCard;

  // Predefined amount options for quick selection
  final List<double> _amountOptions = [50, 100, 200, 500, 1500, 2000];

  @override
  void initState() {
    super.initState();
    _loadSavedCards();
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _loadSavedCards() async {
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
            'Failed to load saved cards: $error',
          );
        },
      );
    } catch (e) {
      setState(() {
        _loadingCards = false;
      });

      AppHelpers.showCheckTopSnackBarInfo(
        context,
        'Failed to load saved cards',
      );
    }
  }

  void _navigateBack() {
    Navigator.of(context).pop();
  }

  // Process top-up with saved card token
  Future<void> _processTokenTopUp() async {
    if (_selectedCard == null) {
      AppHelpers.showCheckTopSnackBarInfo(
        context,
        AppHelpers.getTranslation(TrKeys.selectCard),
      );
      return;
    }

    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      AppHelpers.showCheckTopSnackBarInfo(
        context,
        AppHelpers.getTranslation(TrKeys.pleaseEnterValidAmount),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Get the user's wallet ID
      final user = LocalStorage.getUser();
      final walletId = user?.wallet?.id;

      if (walletId == null) {
        AppHelpers.showCheckTopSnackBarInfo(
          context,
          "Wallet not found",
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // Create the payload for wallet top-up
      final data = {
        'wallet_id': walletId,
        'total_price': amount,
        'currency_id': LocalStorage.getSelectedCurrency()?.id ?? 1,
        'token': _selectedCard!.token,
      };

      // Process the token payment
      final client = dioHttp.client(requireAuth: true);
      final response = await client.post(
        '/api/v1/dashboard/user/pay-fast-token-wallet',
        data: data,
      );

      setState(() {
        _isLoading = false;
      });

      // Handle successful payment
      AppHelpers.showCheckTopSnackBarDone(
        context,
        AppHelpers.getTranslation(TrKeys.topUpSuccessful),
      );
      _navigateBack();
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      AppHelpers.showCheckTopSnackBarInfo(
        context,
        'Failed to process payment: $e',
      );
    }
  }

  // Process top-up with new card
  Future<void> _topUpWithNewCard() async {
    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      AppHelpers.showCheckTopSnackBarInfo(
        context,
        AppHelpers.getTranslation(TrKeys.pleaseEnterValidAmount),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await _repository.processWalletTopUp(
        amount,
        context: context,
        forceCardPayment: true,
        enableTokenization: true,
      );

      setState(() {
        _isLoading = false;
      });

      result.when(
        success: (paymentUrl) {
          if (paymentUrl.isEmpty) {
            AppHelpers.showCheckTopSnackBarInfo(
              context,
              'Invalid payment URL received',
            );
            return;
          }

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PayFastWebView(
                url: paymentUrl,
                onComplete: (success) {
                  if (success) {
                    // Refresh the saved cards if a new card was added
                    _loadSavedCards();

                    AppHelpers.showCheckTopSnackBarDone(
                      context,
                      AppHelpers.getTranslation(TrKeys.topUpSuccessful),
                    );
                    _navigateBack();
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
        'Failed to start top-up process: $e',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isLtr = LocalStorage.getLangLtr();
    return Directionality(
      textDirection: isLtr ? TextDirection.ltr : TextDirection.rtl,
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
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
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
                    title: AppHelpers.getTranslation(TrKeys.topUpWallet),
                    paddingHorizontalSize: 0,
                    titleSize: 18,
                  ),
                  24.verticalSpace,
                  Text(
                    AppHelpers.getTranslation(TrKeys.enterAmount),
                    style: AppStyle.interSemi(size: 16.sp),
                  ),
                  16.verticalSpace,
                  TextField(
                    controller: _amountController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      hintText: '0.00',
                      prefixIcon: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        child: Text(
                          'R',
                          style: AppStyle.interBold(size: 18.sp),
                        ),
                      ),
                      prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide: const BorderSide(color: AppStyle.borderColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide: BorderSide(color: AppStyle.primary),
                      ),
                    ),
                  ),
                  24.verticalSpace,
                  Text(
                    AppHelpers.getTranslation(TrKeys.quickAmount),
                    style: AppStyle.interSemi(size: 16.sp),
                  ),
                  16.verticalSpace,
                  Wrap(
                    spacing: 10.w,
                    runSpacing: 10.h,
                    children: _amountOptions.map((amount) {
                      return InkWell(
                        onTap: () {
                          setState(() {
                            _amountController.text = amount.toString();
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                          decoration: BoxDecoration(
                            color: AppStyle.white,
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(color: AppStyle.borderColor),
                            boxShadow: [
                              BoxShadow(
                                color: AppStyle.black.withOpacity(0.05),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            'R ${amount.toStringAsFixed(2)}',
                            style: AppStyle.interNormal(size: 14.sp),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  24.verticalSpace,

                  // Saved Cards Section
                  if (_loadingCards)
                    Center(child: CircularProgressIndicator(color: AppStyle.primary))
                  else if (_savedCards.isNotEmpty) ...[
                    Text(
                      AppHelpers.getTranslation(TrKeys.selectCard),
                      style: AppStyle.interSemi(size: 16.sp),
                    ),
                    16.verticalSpace,

                    // Saved Cards Widget
                    SavedCardsWidget(
                      onCardSelected: (card) {
                        setState(() {
                          _selectedCard = card;
                        });
                      },
                      hideManagement: false,
                    ),

                    16.verticalSpace,

                    // Pay with selected card button
                    if (_selectedCard != null)
                      ElevatedButton(
                        onPressed: _isLoading ? null : _processTokenTopUp,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppStyle.primary,
                          minimumSize: Size(double.infinity, 50.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        child: _isLoading
                            ? SizedBox(
                          height: 20.h,
                          width: 20.w,
                          child: CircularProgressIndicator(
                            color: AppStyle.white,
                            strokeWidth: 2,
                          ),
                        )
                            : Text(
                          AppHelpers.getTranslation(TrKeys.payWithSavedCard),
                          style: AppStyle.interSemi(
                            size: 16.sp,
                            color: AppStyle.white,
                          ),
                        ),
                      ),
                    4.verticalSpace,
                    Row(
                      children: [
                        const Expanded(child: Divider(color: AppStyle.black)),
                      ],
                    ),
                    4.verticalSpace,
                  ],

                  // Pay with new card button
                  ElevatedButton(
                    onPressed: _isLoading ? null : _topUpWithNewCard,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _savedCards.isNotEmpty ? AppStyle.transparent : AppStyle.primary,
                      foregroundColor: _savedCards.isNotEmpty ? AppStyle.primary : AppStyle.white,
                      minimumSize: Size(double.infinity, 50.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        side: _savedCards.isNotEmpty
                            ? BorderSide(color: AppStyle.primary)
                            : BorderSide.none,
                      ),
                      elevation: _savedCards.isNotEmpty ? 0 : 2,
                    ),
                    child: _isLoading
                        ? SizedBox(
                      height: 20.h,
                      width: 20.w,
                      child: CircularProgressIndicator(
                        color: _savedCards.isNotEmpty ? AppStyle.primary : AppStyle.white,
                        strokeWidth: 2,
                      ),
                    )
                        : Text(
                      _savedCards.isNotEmpty
                          ? AppHelpers.getTranslation(TrKeys.payWithNewCard)
                          : AppHelpers.getTranslation(TrKeys.topUpNow),
                      style: AppStyle.interSemi(
                        size: 16.sp,
                        color: _savedCards.isNotEmpty ? AppStyle.primary : AppStyle.white,
                      ),
                    ),
                  ),

                  24.verticalSpace,
                  Center(
                    child: Text(
                      AppHelpers.getTranslation(TrKeys.cardWillBeSaved),
                      style: AppStyle.interNormal(
                        size: 12.sp,
                        color: AppStyle.textGrey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  24.verticalSpace,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}