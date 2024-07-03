import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:riverpodtemp/application/order/order_notifier.dart';
import 'package:riverpodtemp/application/order/order_provider.dart';
import 'package:riverpodtemp/application/payment_methods/payment_provider.dart';
import 'package:riverpodtemp/game/game.dart';
import 'package:riverpodtemp/game/game_bloc/game_bloc.dart';
import 'package:riverpodtemp/infrastructure/services/app_constants.dart';
import 'package:riverpodtemp/infrastructure/services/app_helpers.dart';
import 'package:riverpodtemp/infrastructure/services/local_storage.dart';
import 'package:riverpodtemp/infrastructure/services/tr_keys.dart';
import 'package:riverpodtemp/presentation/components/app_bars/common_app_bar.dart';
import 'package:riverpodtemp/presentation/components/buttons/custom_button.dart';
import 'package:riverpodtemp/presentation/components/keyboard_dismisser.dart';
import 'package:riverpodtemp/presentation/components/loading.dart';
import 'package:riverpodtemp/presentation/components/shop_avarat.dart';
import 'package:riverpodtemp/presentation/components/title_icon.dart';
import 'package:riverpodtemp/presentation/pages/order/order_check/order_check.dart';
import 'package:riverpodtemp/presentation/pages/order/order_check/widgets/rating_page.dart';
import 'package:riverpodtemp/presentation/pages/order/order_type/widgets/order_map.dart';
import 'package:riverpodtemp/presentation/pages/shop/cart/widgets/cart_order_item.dart';
import 'package:riverpodtemp/presentation/theme/app_style.dart';

import '../../../../application/order/order_state.dart';
import '../../../components/buttons/pop_button.dart';
import '../order_check/widgets/refund_info.dart';
import 'widgets/order_status.dart';

@RoutePage()
class OrderProgressPage extends ConsumerStatefulWidget {
  final num? orderId;

  const OrderProgressPage({
    super.key,
    this.orderId,
  });

  @override
  ConsumerState<OrderProgressPage> createState() => _OrderProgressPageState();
}

class _OrderProgressPageState extends ConsumerState<OrderProgressPage> {
  RefreshController refreshController = RefreshController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late OrderNotifier event;
  late bool isLtr;
  Timer? timer;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(orderProvider.notifier)
          .showOrder(context, widget.orderId ?? 0, false);
      ref.read(paymentProvider.notifier).fetchPayments(context);
    });
    timer = Timer.periodic(const Duration(seconds: 120), (Timer t) {
      ref
          .read(orderProvider.notifier)
          .showOrder(context, widget.orderId ?? 0, true);
    });
    super.initState();
  }

  @override
  void dispose() {
    refreshController.dispose();
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(orderProvider);
    final event = ref.read(orderProvider.notifier);
    final isLtr = LocalStorage.getLangLtr();
    ref.listen(orderProvider, (previous, next) {
      if (AppHelpers.getOrderStatus(next.orderData?.status ?? "") ==
              OrderStatus.delivered &&
          !(next.orderData?.review != null||next.orderData?.tips!=null) &&
          previous?.orderData?.status != next.orderData?.status) {
        AppHelpers.showCustomModalBottomSheet(
          context: context,
          modal: RatingPage(totalPrice: next.orderData?.totalPrice),
          isDarkMode: false,
        );
      }
    });

    return Directionality(
      textDirection: isLtr ? TextDirection.ltr : TextDirection.rtl,
      child: KeyboardDismisser(
        child: Scaffold(
          key: _scaffoldKey,
          resizeToAvoidBottomInset: false,
          backgroundColor: AppStyle.bgGrey,
          body: state.isLoading
              ? const Loading()
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _appBar(context, state),
                    _orderScreen(event, context, state),
                  ],
                ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: _bottom(context),
        ),
      ),
    );
  }

  Widget _bottom(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          const PopButton(),
          16.horizontalSpace,
          Expanded(
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
          ),
        ],
      ),
    );
  }

  Widget _orderScreen(
      OrderNotifier event, BuildContext context, OrderState state) {
    return Expanded(
      child: SmartRefresher(
        enablePullDown: true,
        enablePullUp: false,
        controller: refreshController,
        onRefresh: () {
          event.showOrder(context, state.orderData?.id ?? 0, true);
          refreshController.refreshCompleted();
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              16.verticalSpace,
              state.orderData?.refunds?.isNotEmpty ?? false
                  ? RefundInfoScreen(
                      refundModel: state.orderData?.refunds?.last,
                    )
                  : const SizedBox.shrink(),
              OrderMap(
                isLoading: state.isMapLoading,
                polylineCoordinates: state.polylineCoordinates,
                markers: Set<Marker>.of(state.markers.values),
                latLng: LatLng(state.orderData?.shop?.location?.latitude ?? 0,
                    state.orderData?.shop?.location?.longitude ?? 0),
              ),
              24.verticalSpace,
              TitleAndIcon(
                title: AppHelpers.getTranslation(TrKeys.compositionOrder),
              ),
              Consumer(builder: (context, ref, child) {
                return ListView.builder(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount:
                        ref.watch(orderProvider).orderData?.details?.length ??
                            0,
                    itemBuilder: (context, index) {
                      return CartOrderItem(
                        isAddComment: true,
                        symbol: state.orderData?.currencyModel?.symbol ?? "",
                        isActive: false,
                        add: () {},
                        remove: () {},
                        cartTwo:
                            ref.watch(orderProvider).orderData?.details?[index],
                        cart: null,
                      );
                    });
              }),
              OrderCheck(
                orderStatus:
                    AppHelpers.getOrderStatus(state.orderData?.status ?? ""),
                isOrder: true,
                isActive: state.isActive,
                globalKey: _scaffoldKey,
              ),
              42.verticalSpace
            ],
          ),
        ),
      ),
    );
  }

  CommonAppBar _appBar(BuildContext context, OrderState state) {
    return CommonAppBar(
      height: 170,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ShopAvatar(
                shopImage: state.orderData?.shop?.logoImg ?? "",
                size: 40,
                padding: 4,
                radius: 8,
                bgColor: AppStyle.black.withOpacity(0.06),
              ),
              10.horizontalSpace,
              SizedBox(
                width: MediaQuery.sizeOf(context).width - 98.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      state.orderData?.shop?.translation?.title ?? "",
                      style: AppStyle.interSemi(
                        size: 16,
                        color: AppStyle.black,
                      ),
                      maxLines: 1,
                    ),
                    Text(
                      state.orderData?.shop?.translation?.description ?? "",
                      style: AppStyle.interNormal(
                        size: 12,
                        color: AppStyle.black,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          OrderStatusScreen(
            status: AppHelpers.getOrderStatus(state.orderData?.status ?? ""),
          )
        ],
      ),
    );
  }
}
