import 'package:auto_route/auto_route.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodyman/infrastructure/services/time_service.dart';
import 'package:foodyman/application/map/view_map_provider.dart';
import 'package:foodyman/application/map/view_map_state.dart';
import 'package:foodyman/application/order/order_notifier.dart';
import 'package:foodyman/application/order/order_provider.dart';
import 'package:foodyman/application/order/order_state.dart';
import 'package:foodyman/application/orders_list/orders_list_notifier.dart';
import 'package:foodyman/application/payment_methods/payment_provider.dart';
import 'package:foodyman/application/payment_methods/payment_state.dart';
import 'package:foodyman/application/profile/profile_provider.dart';
import 'package:foodyman/application/profile/profile_state.dart';
import 'package:foodyman/application/shop_order/shop_order_notifier.dart';
import 'package:foodyman/application/shop_order/shop_order_provider.dart';
import 'package:foodyman/application/shop_order/shop_order_state.dart';
import 'package:foodyman/infrastructure/models/data/shop_data.dart';
import 'package:foodyman/app_constants.dart';
import 'package:foodyman/infrastructure/services/app_helpers.dart';
import 'package:foodyman/infrastructure/services/enums.dart';
import 'package:foodyman/infrastructure/services/tr_keys.dart';
import 'package:foodyman/presentation/components/buttons/custom_button.dart';
import 'package:foodyman/presentation/pages/order/order_check/price_information.dart';
import 'package:foodyman/presentation/pages/order/order_check/widgets/auto_order_modal.dart';
import 'package:foodyman/presentation/pages/order/order_screen/widgets/image_dialog.dart';
import 'package:foodyman/presentation/pages/profile/phone_verify.dart';
import 'package:foodyman/presentation/routes/app_router.dart';
import 'package:foodyman/presentation/theme/theme.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:foodyman/application/orders_list/orders_list_provider.dart';
import 'package:foodyman/infrastructure/models/data/order_body_data.dart';
import 'package:foodyman/infrastructure/services/local_storage.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:foodyman/infrastructure/models/data/saved_card.dart';
import '../../../../domain/di/dependency_manager.dart';
import '../../cards/payment_screen.dart';
import 'widgets/card_and_promo.dart';
import 'widgets/delivery_info.dart';
import 'widgets/order_button.dart';
import 'widgets/order_info.dart';

// Import the PreloadedWebView provider
final preloadedWebViewProvider = StateProvider<PreloadedWebViewState?>((ref) => null);

// State class for tracking preloaded WebView
class PreloadedWebViewState {
  final WebViewController controller;
  final String url;
  final bool isReady;

  PreloadedWebViewState({
    required this.controller,
    required this.url,
    this.isReady = false,
  });

  PreloadedWebViewState copyWith({
    WebViewController? controller,
    String? url,
    bool? isReady,
  }) {
    return PreloadedWebViewState(
      controller: controller ?? this.controller,
      url: url ?? this.url,
      isReady: isReady ?? this.isReady,
    );
  }
}

class OrderCheck extends ConsumerStatefulWidget {
  final bool isActive;
  final bool isOrder;
  final GlobalKey<ScaffoldState>? globalKey;

  final OrderStatus orderStatus;
  final ConfettiController? controllerCenter;

  const OrderCheck({
    super.key,
    required this.isActive,
    required this.isOrder,
    required this.orderStatus,
    this.globalKey,
    this.controllerCenter,
  });

  @override
  ConsumerState<OrderCheck> createState() => _OrderCheckState();
}

class _OrderCheckState extends ConsumerState<OrderCheck> {
  // Method to preload a WebView
  void _preloadWebView(String url) {
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Theme.of(context).scaffoldBackgroundColor)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            ref.read(preloadedWebViewProvider.notifier).state =
                ref.read(preloadedWebViewProvider)?.copyWith(isReady: true);
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith(AppConstants.baseUrl)) {
              context.replaceRoute(const MainRoute());
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(url));

    ref.read(preloadedWebViewProvider.notifier).state = PreloadedWebViewState(
      controller: controller,
      url: url,
    );
  }

  // Check if PayFast is selected
  bool _isPayFastSelected(PaymentState paymentState, OrderState state) {
    if (AppHelpers.getPaymentType() == "admin") {
      return paymentState.payments[paymentState.currentIndex].tag?.toLowerCase() == "pay-fast";
    } else {
      return state.shopData?.shopPayments?[paymentState.currentIndex]?.payment?.tag?.toLowerCase() == "pay-fast";
    }
  }

  void _createOrder(
      {required OrderState state,
        required OrderNotifier event,
        required ShopOrderState stateOrderShop,
        required ShopOrderNotifier eventShopOrder,
        required ViewMapState stateMap,
        required PaymentState paymentState,
        required ProfileState stateProfile,
        required OrdersListNotifier eventOrderList}) {

    // Validation checks
    if ((state.shopData?.minAmount ?? 0) > (state.calculateData?.price ?? 0)) {
      AppHelpers.showCheckTopSnackBarInfo(
        context,
        "${AppHelpers.getTranslation(TrKeys.yourOrderDidNotReachMinAmountMinAmountIs)} ${AppHelpers.numberFormat(number: (state.shopData?.minAmount ?? 0))}",
      );
      return;
    }

    if (state.sendOtherUser &&
        (state.username?.isEmpty ?? true) &&
        (state.phoneNumber?.isEmpty ?? true) &&
        state.tabIndex == 0) {
      AppHelpers.showCheckTopSnackBarInfo(
        context,
        AppHelpers.getTranslation(TrKeys.youWritePhoneAndFirstname),
      );
      return;
    }

    if (!((AppHelpers.getPaymentType() == "admin")
        ? (paymentState.payments.isNotEmpty)
        : (state.shopData?.shopPayments?.isNotEmpty ?? false))) {
      AppHelpers.showCheckTopSnackBarInfo(
        context,
        AppHelpers.getTranslation(TrKeys.youCantCreateOrder),
      );
      return;
    }

    if (state.selectDate == null) {
      AppHelpers.showCheckTopSnackBarInfo(
        context,
        AppHelpers.getTranslation(TrKeys.notWorkTodayAndTomorrow),
      );
      return;
    }

    if ((LocalStorage.getUser()?.phone == null ||
        (LocalStorage.getUser()?.phone?.isEmpty ?? true)) &&
        AppHelpers.getPhoneRequired()) {
      AppHelpers.showCustomModalBottomSheet(
          context: context,
          modal: const PhoneVerify(),
          isDarkMode: false,
          paddingTop: MediaQuery.paddingOf(context).top);
      return;
    }

    // Create order data
    OrderBodyData orderBodyData = OrderBodyData(
        paymentId: ((AppHelpers.getPaymentType() == "admin")
            ? (paymentState.payments[paymentState.currentIndex].id)
            : state.shopData?.shopPayments?[paymentState.currentIndex]?.payment?.id),
        username: state.username,
        phone: state.phoneNumber ?? LocalStorage.getUser()?.phone,
        email: LocalStorage.getUser()?.email,
        notes: state.notes,
        cartId: stateOrderShop.cart?.id ?? 0,
        shopId: state.shopData?.id ?? 0,
        coupon: state.promoCode,
        deliveryFee: state.calculateData?.deliveryFee ?? 0,
        deliveryType: state.tabIndex == 0
            ? DeliveryTypeEnum.delivery
            : DeliveryTypeEnum.pickup,
        location: Location(
            longitude: stateMap.place?.location?.last ??
                LocalStorage.getAddressSelected()?.location?.longitude ??
                AppConstants.demoLongitude,
            latitude: stateMap.place?.location?.first ??
                LocalStorage.getAddressSelected()?.location?.latitude ??
                AppConstants.demoLatitude),
        address: AddressModel(
          address: LocalStorage.getAddressSelected()?.address ?? "",
          house: state.house,
          floor: state.floor,
          office: state.office,
        ),
        note: state.note,
        deliveryDate:
        "${state.selectDate?.year ?? 0}-${(state.selectDate?.month ?? 0).toString().padLeft(2, '0')}-${(state.selectDate?.day ?? 0).toString().padLeft(2, '0')}",
        deliveryTime: state.selectTime.hour.toString().length == 2
            ? "${state.selectTime.hour}:${state.selectTime.minute.toString().padLeft(2, '0')}"
            : "0${state.selectTime.hour}:${state.selectTime.minute.toString().padLeft(2, '0')}");

    // Check if PayFast is the selected payment method
    final bool isPayFast = _isPayFastSelected(paymentState, state);

    if (isPayFast && AppConstants.cardDirect) {
      // Open the payment screen as a bottom sheet
      AppHelpers.showCustomModalBottomSheet(
        isDismissible: true,
        context: context,
        modal:
        PaymentScreen(
                    orderData: orderBodyData,
                    onPaymentComplete: (success) {
                      // Close the bottom sheet
                      Navigator.pop(context);

                      if (success) {
                        // Handle successful payment
                        widget.controllerCenter?.play();
                        eventShopOrder.getCart(context, () {});
                        eventOrderList.fetchActiveOrders(context);

                        // Navigate back to main screen if needed
                        context.replaceRoute(const MainRoute());
                      } else {
                        // Handle payment failure
                        AppHelpers.showCheckTopSnackBarInfo(
                          context,
                          AppHelpers.getTranslation(TrKeys.paymentRejected),
                        );
                      }
                    },
                  ),
              isDarkMode: false,
            );
    } else {
      // Use the standard flow
      event.createOrder(
        context: context,
        data: orderBodyData,
        payment: ((AppHelpers.getPaymentType() == "admin")
            ? (paymentState.payments[paymentState.currentIndex])
            : state.shopData?.shopPayments?[paymentState.currentIndex]?.payment),
        onSuccess: () {
          widget.controllerCenter?.play();
          eventShopOrder.getCart(context, () {});
          eventOrderList.fetchActiveOrders(context);
        },
        onWebview: (paymentUrl, transactionId) {
          if (isPayFast) {
            // For PayFast, use our preloaded WebView if available
            final preloadedState = ref.read(preloadedWebViewProvider);

            if (preloadedState != null && preloadedState.url == paymentUrl && preloadedState.isReady) {
              // If we have a preloaded and ready WebView for this URL, use it
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) =>
                    WebViewPage(
                      url: paymentUrl,
                      preloadedController: preloadedState.controller,
                    )
                ),
              );
            } else {
              // Otherwise use standard WebView but with improved loading
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => WebViewPage(url: paymentUrl)),
              );
            }
          } else {
            // For non-PayFast payments, use the standard WebView
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => WebViewPage(url: paymentUrl)),
            );
          }
        },
      );
    }
  }

  _checkShopOrder() {
    AppHelpers.showAlertDialog(
        context: context,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppHelpers.getTranslation(TrKeys.allPreviouslyAdded),
              style: AppStyle.interNormal(),
              textAlign: TextAlign.center,
            ),
            16.verticalSpace,
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                      title: AppHelpers.getTranslation(TrKeys.cancel),
                      background: AppStyle.transparent,
                      borderColor: AppStyle.borderColor,
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                ),
                10.horizontalSpace,
                Expanded(child: Consumer(builder: (contextTwo, ref, child) {
                  return CustomButton(
                      isLoading: ref.watch(shopOrderProvider).isDeleteLoading,
                      title: AppHelpers.getTranslation(TrKeys.clearAll),
                      onPressed: () {
                        ref
                            .read(shopOrderProvider.notifier)
                            .deleteCart(context);
                        ref.read(orderProvider.notifier).repeatOrder(
                          context: context,
                          shopId: 0,
                          listOfProduct:
                          ref.watch(orderProvider).orderData?.details ??
                              [],
                          onSuccess: () {
                            ref
                                .read(shopOrderProvider.notifier)
                                .getCart(context, () {
                              context.maybePop();
                              context.pushRoute(const OrderRoute());
                            });
                          },
                        );
                      });
                })),
              ],
            )
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppStyle.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.r),
          topRight: Radius.circular(10.r),
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Consumer(builder: (context, ref, child) {
        final state = ref.watch(orderProvider);
        final event = ref.read(orderProvider.notifier);
        final paymentState = ref.watch(paymentProvider);

        // Listen for changes in payment selection to potentially preload WebView
        ref.listen(paymentProvider, (previous, next) {
          if (previous?.currentIndex != next.currentIndex) {
            // If PayFast is selected, we could potentially start preloading
            final isPayFast = _isPayFastSelected(next, state);
            if (isPayFast) {
              // This will occur after we have the URL from the process method
            }
          }
        });

        ref.listen(orderProvider, (previous, next) {
          if (next.isCheckShopOrder &&
              (next.isCheckShopOrder !=
                  (previous?.isCheckShopOrder ?? false))) {
            _checkShopOrder();
          }
        });
        num subTotal = 0;
        state.orderData?.details?.forEach((element) {
          subTotal = subTotal + (element.totalPrice ?? 0);
        });
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            widget.isOrder ? const OrderInfo() : const CardAndPromo(),
            PriceInformation(isOrder: widget.isOrder, state: state),
            const DeliveryInfo(),
            26.verticalSpace,
            Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.paddingOf(context).bottom,
                  right: 16.w,
                  left: 16.w),
              child: OrderButton(
                autoOrder: () {
                  AppHelpers.showCustomModalBottomSheet(
                      context: context,
                      modal: AutoOrderModal(
                        repeatData: state.orderData?.repeat,
                        orderId: state.orderData?.id ?? 0,
                        time: TimeService.timeFormat(
                            state.orderData?.createdAt ?? DateTime.now()),
                      ),
                      isDarkMode: false);
                },
                isRepeatLoading: state.isAddLoading,
                isLoading: ref.watch(shopOrderProvider).isAddAndRemoveLoading ||
                    state.isButtonLoading,
                isOrder: widget.isOrder,
                isAutoLoading: state.isButtonLoading,
                orderStatus: widget.orderStatus,
                createOrder: () {
                  _createOrder(
                    state: state,
                    stateMap: ref.watch(viewMapProvider),
                    stateOrderShop: ref.watch(shopOrderProvider),
                    event: event,
                    eventShopOrder: ref.read(shopOrderProvider.notifier),
                    paymentState: paymentState,
                    stateProfile: ref.watch(profileProvider),
                    eventOrderList: ref.read(ordersListProvider.notifier),
                  );
                },
                cancelOrder: () {
                  event.cancelOrder(context, state.orderData?.id ?? 0, () {
                    ref
                        .read(ordersListProvider.notifier)
                        .fetchActiveOrders(context);
                    ref
                        .read(ordersListProvider.notifier)
                        .fetchHistoryOrders(context);
                    ref
                        .read(ordersListProvider.notifier)
                        .fetchRefundOrders(context);
                  });
                },
                callShop: () async {
                  final Uri launchUri = Uri(
                    scheme: 'tel',
                    path: state.orderData?.shop?.phone ?? "",
                  );
                  await launchUrl(launchUri);
                },
                callDriver: () async {
                  if (state.orderData?.deliveryMan != null) {
                    final Uri launchUri = Uri(
                      scheme: 'tel',
                      path: state.orderData?.deliveryMan?.phone ?? "",
                    );
                    await launchUrl(launchUri);
                  } else {
                    AppHelpers.showCheckTopSnackBarInfo(
                      context,
                      AppHelpers.getTranslation(TrKeys.noDriver),
                    );
                  }
                },
                sendSmsDriver: () async {
                  if (state.orderData?.deliveryMan != null) {
                    final Uri launchUri = Uri(
                      scheme: 'sms',
                      path: state.orderData?.deliveryMan?.phone ?? "",
                    );
                    await launchUrl(launchUri);
                  } else {
                    AppHelpers.showCheckTopSnackBarInfo(
                      context,
                      AppHelpers.getTranslation(TrKeys.noDriver),
                    );
                  }
                },
                isRefund: (state.orderData?.refunds?.isEmpty ?? true) ||
                    state.orderData?.refunds?.last.status == "canceled",
                repeatOrder: () {
                  event.repeatOrder(
                    context: context,
                    shopId: ref.watch(shopOrderProvider).cart?.shopId ?? 0,
                    listOfProduct: state.orderData?.details ?? [],
                    onSuccess: () {
                      ref.read(shopOrderProvider.notifier).getCart(context, () {
                        context.maybePop();
                        context.pushRoute(const OrderRoute());
                      });
                    },
                  );
                },
                showImage: state.orderData?.afterDeliveredImage != null
                    ? () {
                  AppHelpers.showAlertDialog(
                    context: context,
                    child: ImageDialog(
                      img: state.orderData?.afterDeliveredImage,
                    ),
                  );
                }
                    : null,
              ),
            ),
          ],
        );
      }),
    );
  }
}

// Enhanced WebView component for PayFast
class WebViewPage extends StatefulWidget {
  final String url;
  final WebViewController? preloadedController;
  final Function(bool)? onComplete;

  const WebViewPage({
    super.key,
    required this.url,
    this.preloadedController,
    this.onComplete,
  });

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late WebViewController controller;
  bool isLoading = true;
  bool isPaymentComplete = false;

  @override
  void initState() {
    super.initState();

    // Use preloaded controller if available, otherwise create a new one
    if (widget.preloadedController != null) {
      controller = widget.preloadedController!;

      // Check if already loaded
      controller.currentUrl().then((currentUrl) {
        if (currentUrl == widget.url) {
          setState(() {
            isLoading = false;
          });
        } else {
          // Load the URL if it's different
          controller.loadRequest(Uri.parse(widget.url));
        }
      });

      // Set up navigation delegate to detect payment completion
      controller.setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            if (mounted) {
              setState(() {
                isLoading = false;
              });
            }

            // Check for payment completion
            _checkForPaymentCompletion(url);
          },
          onNavigationRequest: (NavigationRequest request) {
            // Check for payment completion URLs
            if (_checkForPaymentCompletion(request.url)) {
              return NavigationDecision.prevent;
            }

            // Prevent navigation to app domains (they should be handled by callbacks)
            if (request.url.startsWith(AppConstants.baseUrl)) {
              if (widget.onComplete != null) {
                widget.onComplete!(true);
              }
              context.replaceRoute(const MainRoute());
              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
        ),
      );
    } else {
      // Initialize a new controller
      controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(Theme.of(context).scaffoldBackgroundColor)
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageFinished: (String url) {
              if (mounted) {
                setState(() {
                  isLoading = false;
                });
              }

              // Check for payment completion
              _checkForPaymentCompletion(url);
            },
            onNavigationRequest: (NavigationRequest request) {
              // Check for payment completion URLs
              if (_checkForPaymentCompletion(request.url)) {
                return NavigationDecision.prevent;
              }

              // Prevent navigation to app domains (they should be handled by callbacks)
              if (request.url.startsWith(AppConstants.baseUrl)) {
                if (widget.onComplete != null) {
                  widget.onComplete!(true);
                }
                context.replaceRoute(const MainRoute());
                return NavigationDecision.prevent;
              }

              return NavigationDecision.navigate;
            },
          ),
        )
        ..loadRequest(Uri.parse(widget.url));
    }
  }

  // Check if the URL indicates payment completion
  bool _checkForPaymentCompletion(String url) {
    // Don't process if already detected payment completion
    if (isPaymentComplete) return false;

    // Check if the URL contains success indicators
    if (url.contains('order-stripe-success') ||
        url.contains('payment-success') ||
        url.contains('redirect-success') ||
        url.contains(AppConstants.baseUrl)) {

      isPaymentComplete = true;

      // Perform success actions
      if (widget.onComplete != null) {
        widget.onComplete!(true);
      }

      // Navigate back to main route
      Future.delayed(const Duration(milliseconds: 500), () {
        context.replaceRoute(const MainRoute());
      });

      return true;
    }
    // Check if the URL contains cancel/failure indicators
    else if (url.contains('payment-cancel') ||
        url.contains('payment-failed') ||
        url.contains('redirect-cancel')) {

      isPaymentComplete = true;

      // Show error message
      AppHelpers.showCheckTopSnackBarInfo(
        context,
        AppHelpers.getTranslation(TrKeys.paymentRejected),
      );

      // Inform parent about failure
      if (widget.onComplete != null) {
        widget.onComplete!(false);
      }

      // Navigate back
      Navigator.pop(context);

      return true;
    }

    // Not a completion URL
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppStyle.white,
        elevation: 0,
        title: Text(
          AppHelpers.getTranslation(TrKeys.checkout),
          style: AppStyle.interNormal(),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppStyle.black),
          onPressed: () {
            Navigator.pop(context);

            // Inform parent about cancellation
            if (widget.onComplete != null) {
              widget.onComplete!(false);
            }
          },
        ),
      ),
      body: Stack(
        children: [
          // The WebView is always present but initially invisible while loading
          AnimatedOpacity(
            opacity: isLoading ? 0.0 : 1.0,
            duration: const Duration(milliseconds: 300),
            child: WebViewWidget(controller: controller),
          ),

          // Loading indicator shows while content is loading
          if (isLoading)
            Center(
              child: CircularProgressIndicator(
                color: AppStyle.primary,
              ),
            ),
        ],
      ),
    );
  }
}

// PayFast Payment Screen Widget
class PayFastPaymentScreen extends ConsumerStatefulWidget {
  final OrderBodyData orderData;
  final Function(bool) onPaymentComplete;

  const PayFastPaymentScreen({
    super.key,
    required this.orderData,
    required this.onPaymentComplete,
  });

  @override
  ConsumerState<PayFastPaymentScreen> createState() => _PayFastPaymentScreenState();
}

class _PayFastPaymentScreenState extends ConsumerState<PayFastPaymentScreen> {
  final _repository = ordersRepository;
  bool _isLoading = false;
  bool _loadingCards = true;
  List<SavedCardModel> _savedCards = [];
  SavedCardModel? _selectedCard;

  @override
  void initState() {
    super.initState();
    _loadSavedCards();
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
        widget.orderData,
        _selectedCard!.token,
      );

      result.when(
        success: (transactionId) {
          widget.onPaymentComplete(true);
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
  void _redirectToPayFastWebView() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final result = await _repository.process(
        widget.orderData,
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
              builder: (_) => WebViewPage(
                url: paymentUrl,
                onComplete: (success) {
                  if (success) {
                    widget.onPaymentComplete(true);
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
    return _loadingCards
        ? Center(child: CircularProgressIndicator(color: AppStyle.primary))
        : Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppHelpers.getTranslation(TrKeys.payment),
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        20.verticalSpace,

        // Show saved cards section if available
        if (_savedCards.isNotEmpty) ...[
          Text(
            AppHelpers.getTranslation(TrKeys.selectSavedCard),
            style: AppStyle.interSemi(size: 16.sp),
          ),
          12.verticalSpace,
          SizedBox(
            height: 80.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _savedCards.length,
              itemBuilder: (context, index) {
                final card = _savedCards[index];
                final isSelected = _selectedCard?.id == card.id;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCard = isSelected ? null : card;
                    });
                  },
                  child: Container(
                    width: 160.w,
                    margin: EdgeInsets.only(right: 12.w),
                    padding: EdgeInsets.all(12.r),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppStyle.primary
                          : AppStyle.white,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: isSelected
                            ? AppStyle.primary
                            : AppStyle.borderColor,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              card.cardType,
                              style: AppStyle.interSemi(size: 14.sp),
                            ),
                            Text(
                              '${AppHelpers.getTranslation(TrKeys.expires)} ${card.expiryDate}',
                              style: AppStyle.interNormal(size: 12.sp),
                            ),
                          ],
                        ),
                        Text(
                          '•••• ${card.lastFour}',
                          style: AppStyle.interSemi(size: 14.sp),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          24.verticalSpace,

          // Pay with selected card button
          if (_selectedCard != null)
            CustomButton(
              isLoading: _isLoading,
              title: AppHelpers.getTranslation(TrKeys.payWithSavedCard),
              onPressed: _processTokenPayment,
            ),

          24.verticalSpace,
        ],

        // Button to use PayFast WebView for new card
        CustomButton(
          isLoading: _isLoading,
          title: _savedCards.isEmpty
              ? AppHelpers.getTranslation(TrKeys.payNow)
              : AppHelpers.getTranslation(TrKeys.payWithCard),
          onPressed: _redirectToPayFastWebView,
        ),

        12.verticalSpace,

        Center(
          child: Text(
            _savedCards.isEmpty
                ? AppHelpers.getTranslation(TrKeys.completeCardDetails)
                : AppHelpers.getTranslation(TrKeys.enterCardDirectly),
            style: AppStyle.interNormal(
              size: 13.sp,
              color: AppStyle.textGrey,
            ),
          ),
        ),
      ],
    );
  }
}