// ignore_for_file: unused_result

import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart' as l;
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:riverpodtemp/application/order/order_notifier.dart';
import 'package:riverpodtemp/application/order/order_provider.dart';
import 'package:riverpodtemp/application/order/order_state.dart';
import 'package:riverpodtemp/application/shop_order/shop_order_state.dart';
import 'package:riverpodtemp/game/game.dart';
import 'package:riverpodtemp/game/game_bloc/game_bloc.dart';
import 'package:riverpodtemp/infrastructure/services/app_constants.dart';
import 'package:riverpodtemp/infrastructure/services/app_helpers.dart';
import 'package:riverpodtemp/infrastructure/services/local_storage.dart';
import 'package:riverpodtemp/infrastructure/services/tr_keys.dart';
import 'package:riverpodtemp/presentation/components/app_bars/common_app_bar.dart';
import 'package:riverpodtemp/presentation/components/buttons/custom_button.dart';
import 'package:riverpodtemp/presentation/components/buttons/pop_button.dart';
import 'package:riverpodtemp/presentation/components/keyboard_dismisser.dart';
import 'package:riverpodtemp/presentation/components/loading.dart';
import 'package:riverpodtemp/presentation/components/shop_avarat.dart';
import 'package:riverpodtemp/presentation/theme/theme.dart';
import '../../../../application/payment_methods/payment_provider.dart';
import '../../../../application/shop_order/shop_order_provider.dart';
import '../order_check/order_check.dart';
import '../order_type/widgets/order_map.dart';
import '../order_type/order_type.dart';
import '../order_check/widgets/rating_page.dart';
import 'widgets/order_carts.dart';
import 'widgets/order_status.dart';

@RoutePage()
class OrderPage extends ConsumerStatefulWidget {
  const OrderPage({
    super.key,
  });

  @override
  ConsumerState<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends ConsumerState<OrderPage>
    with SingleTickerProviderStateMixin {
  late RefreshController refreshController;
  late TabController _tabController;
  late ConfettiController _controllerCenter;
  late double long;
  late double lat;
  int tabIndex = 0;
  int reviewOpen = 1;
  bool check = false;

  void getAddress() {
    long = LocalStorage.getAddressSelected()?.location?.longitude ??
        AppConstants.demoLongitude;
    lat = LocalStorage.getAddressSelected()?.location?.latitude ??
        AppConstants.demoLatitude;
  }

  checkCart(ShopOrderState stateShopOrder, OrderState state) {
    final cart = stateShopOrder.cart;
    check = !(!(cart == null ||
            (cart.userCarts?.isEmpty ?? true) ||
            ((cart.userCarts?.isEmpty ?? true)
                    ? true
                    : (cart.userCarts?.first.cartDetails?.isEmpty ?? true)) &&
                !(cart.group ?? false)) ||
        state.orderData != null);
  }

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _controllerCenter =
        ConfettiController(duration: const Duration(seconds: 2));
    refreshController = RefreshController();
    if (ref.read(shopOrderProvider).cart != null) {
      _tabController.addListener(() {
        ref.read(orderProvider.notifier).changeTabIndex(_tabController.index);
        if (_tabController.index == 1) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ref.read(orderProvider.notifier).getCalculate(
                isLoading: false,
                context: context,
                cartId: ref.read(shopOrderProvider).cart?.id ?? 0,
                long: long,
                lat: lat,
                type: DeliveryTypeEnum.pickup);
          });
        } else {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ref.read(orderProvider.notifier).getCalculate(
                isLoading: false,
                context: context,
                cartId: ref.read(shopOrderProvider).cart?.id ?? 0,
                long: long,
                lat: lat,
                type: DeliveryTypeEnum.delivery);
          });
        }
      });
      getAddress();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(shopOrderProvider.notifier).getCart(context, () {});
        ref.read(orderProvider.notifier)
          ..resetState()
          ..fetchShop(context,
              (ref.watch(shopOrderProvider).cart?.shopId ?? 0).toString())
          ..fetchShopBranch(
              context, (ref.watch(shopOrderProvider).cart?.shopId ?? 0))
          ..getCalculate(
            context: context,
            cartId: ref.watch(shopOrderProvider).cart?.id ?? 0,
            long: long,
            lat: lat,
            type: DeliveryTypeEnum.delivery,
          );
        ref.refresh(paymentProvider);
        ref.read(paymentProvider.notifier).fetchPayments(context);
      });
    }

    super.initState();
  }

  @override
  void dispose() {
    refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = LocalStorage.getAppThemeMode();
    final isLtr = LocalStorage.getLangLtr();
    final state = ref.watch(orderProvider);
    final event = ref.read(orderProvider.notifier);
    checkCart(ref.watch(shopOrderProvider), state);
    ref.listen(orderProvider, (previous, next) {
      if (AppHelpers.getOrderStatus(next.orderData?.status ?? "") ==
              OrderStatus.delivered
          && next.orderData?.review == null
          && previous?.orderData?.status != next.orderData?.status
      ) {
        AppHelpers.showCustomModalBottomSheet(
          context: context,
          modal: RatingPage(totalPrice: next.orderData?.totalPrice),
          isDarkMode: isDarkMode,
        );
      }
    });
    return Directionality(
      textDirection: isLtr ? TextDirection.ltr : TextDirection.rtl,
      child: KeyboardDismisser(
        child: ConfettiWidget(
          blastDirectionality: BlastDirectionality.explosive,
          confettiController: _controllerCenter,
          particleDrag: 0.02,
          emissionFrequency: 0.02,
          numberOfParticles: 45,
          gravity: 0.1,
          shouldLoop: false,
          displayTarget: true,
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor:
                isDarkMode ? AppStyle.mainBackDark : AppStyle.bgGrey,
            body: check
                ? _resultEmpty()
                : state.isLoading
                    ? const Loading()
                    : _orderScreen(context, state, event),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: _bottom(state, context),
          ),
        ),
      ),
    );
  }

  Widget _bottom(OrderState state, BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          const PopButton(),
          16.horizontalSpace,
          state.orderData != null
              ? Expanded(
                  child: CustomButton(
                      icon: const Icon(
                        FlutterRemix.gamepad_fill,
                        color: AppStyle.black,
                      ),
                      title: AppHelpers.getTranslation(TrKeys.wantToPlayGame),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => BlocProvider(
                              create: (context) =>
                                  GameBloc()..add(const GameEvent.init()),
                              child: const Game(),
                            ),
                          ),
                        );
                      }),
                )
              : const Spacer(),
        ],
      ),
    );
  }

  Widget _orderScreen(
      BuildContext context, OrderState state, OrderNotifier event) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _appBar(context, state),
        Expanded(
          child: SmartRefresher(
            enablePullDown: state.orderData != null,
            enablePullUp: false,
            controller: state.orderData == null
                ? RefreshController()
                : refreshController,
            onRefresh: () {
              event.showOrder(context, state.orderData?.id ?? 0, true);
              refreshController.refreshCompleted();
            },
            child: SingleChildScrollView(
              child: Column(
                children: [
                  16.verticalSpace,
                  state.orderData != null
                      ? OrderMap(
                          isLoading: state.isMapLoading,
                          polylineCoordinates: state.polylineCoordinates,
                          markers: Set<Marker>.of(state.markers.values),
                          latLng: LatLng(
                              state.orderData?.shop?.location?.latitude ?? 0,
                              state.orderData?.shop?.location?.longitude ?? 0),
                        )
                      : OrderType(
                          sendUser: ref.watch(orderProvider).sendOtherUser,
                          shopId: state.shopData?.id ?? 0,
                          tabController: _tabController,
                          onChange: (s) => event.changeActive(s),
                          getLocation: () {
                            getAddress();
                            event.getCalculate(
                              isLoading: false,
                              context: context,
                              cartId: ref.read(shopOrderProvider).cart?.id ?? 0,
                              long: long,
                              lat: lat,
                              type: _tabController.index == 0
                                  ? DeliveryTypeEnum.delivery
                                  : DeliveryTypeEnum.pickup,
                            );
                          },
                        ),
                  Stack(
                    children: [
                      OrderCarts(
                        lat: lat,
                        long: long,
                        tabBarIndex: _tabController.index,
                      ),
                      if (ref.watch(shopOrderProvider).isAddAndRemoveLoading)
                        _customLoading(),
                    ],
                  ),
                  OrderCheck(
                    orderStatus: AppHelpers.getOrderStatus(
                        state.orderData?.status ?? ""),
                    isOrder: state.orderData != null,
                    isActive: state.isActive,
                    controllerCenter: _controllerCenter,
                  ),
                  64.verticalSpace
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _resultEmpty() {
    return Column(
      children: [
        100.verticalSpace,
        l.Lottie.asset('assets/lottie/girl_empty.json'),
        24.verticalSpace,
        Text(
          AppHelpers.getTranslation(TrKeys.cartIsEmpty),
          style: AppStyle.interSemi(size: 18.sp),
        ),
      ],
    );
  }

  CommonAppBar _appBar(BuildContext context, OrderState state) {
    return CommonAppBar(
      height: state.orderData != null ? 170 : 70,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ShopAvatar(
                shopImage: state.orderData == null
                    ? (state.shopData?.logoImg ?? "")
                    : (state.orderData?.shop?.logoImg ?? ""),
                size: 40,
                padding: 4,
                radius: 8,
                bgColor: AppStyle.black.withOpacity(0.06),
              ),
              10.horizontalSpace,
              SizedBox(
                width: MediaQuery.sizeOf(context).width - 86.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      state.orderData == null
                          ? (state.shopData?.translation?.title ?? "")
                          : (state.orderData?.shop?.translation?.title ?? ""),
                      style: AppStyle.interSemi(
                        size: 16,
                        color: AppStyle.black,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      state.orderData == null
                          ? (state.shopData?.translation?.description ?? "")
                          : (state.orderData?.shop?.translation?.description ??
                              ""),
                      style: AppStyle.interNormal(
                        size: 12,
                        color: AppStyle.black,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          state.orderData != null
              ? OrderStatusScreen(
                  status:
                      AppHelpers.getOrderStatus(state.orderData?.status ?? ""),
                )
              : const SizedBox.shrink()
        ],
      ),
    );
  }
}

Widget _customLoading() {
  return BackdropFilter(
    filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
    child: Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: AppStyle.white.withOpacity(0.5),
      ),
      child: Container(
        width: 80,
        height: 80,
        alignment: Alignment.center,
        child: const Loading(),
      ),
    ),
  );
}
