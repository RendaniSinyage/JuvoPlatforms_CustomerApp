import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:riverpodtemp/infrastructure/models/data/order_active_model.dart';
import 'package:riverpodtemp/application/orders_list/orders_list_provider.dart';
import 'package:riverpodtemp/application/shop/shop_provider.dart';
import 'package:riverpodtemp/infrastructure/services/app_helpers.dart';
import 'package:riverpodtemp/presentation/components/shop_avarat.dart';
import 'package:riverpodtemp/infrastructure/services/tr_keys.dart';
import 'package:riverpodtemp/infrastructure/models/data/shop_data.dart';
import 'package:riverpodtemp/presentation/components/title_icon.dart';
import 'package:riverpodtemp/presentation/theme/theme.dart';

import '../../../infrastructure/services/local_storage.dart';
import '../../routes/app_router.dart';
import '../buttons/animation_button_effect2.dart';

class UpComingList extends ConsumerStatefulWidget {
  const UpComingList({super.key});

  @override
  _UpComingListState createState() => _UpComingListState();
}

class _UpComingListState extends ConsumerState<UpComingList> {
  Timer? _timer;
  final ValueNotifier<OrderActiveModel?> _currentOrderNotifier = ValueNotifier(null);
  final ValueNotifier<bool> _isLoadingNotifier = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _startPeriodicUpdate();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _currentOrderNotifier.dispose();
    _isLoadingNotifier.dispose();
    super.dispose();
  }

  void _startPeriodicUpdate() {
    _fetchLatestOrderStatus();
    _timer = Timer.periodic(const Duration(minutes: 10), (_) {
      _fetchLatestOrderStatus();
    });
  }

  Future<void> _fetchLatestOrderStatus() async {
    _isLoadingNotifier.value = true;
    await ref.read(ordersListProvider.notifier).fetchActiveOrders(context);
    final ordersState = ref.read(ordersListProvider);
    final mostRecentOrder = ordersState.activeOrders.isNotEmpty ? ordersState.activeOrders.first : null;

    _currentOrderNotifier.value = mostRecentOrder;
    _isLoadingNotifier.value = false;
  }

  @override
  Widget build(BuildContext context) {
    final firstName = LocalStorage.getFirstName();

    return ValueListenableBuilder<OrderActiveModel?>(
      valueListenable: _currentOrderNotifier,
      builder: (context, currentOrder, child) {
        if (currentOrder == null) {
          return const SizedBox.shrink(); // Hide the widget when there's no order
        }

        return Column(
          children: [
            TitleAndIcon(
              title: "$firstName\u{1F44B}, ${AppHelpers.getTranslation(TrKeys.mostRecentOrder)}",
              titleColor: AppStyle.black,
            ),
            8.verticalSpace,
            SizedBox(
              height: 120.h,
              child: FutureBuilder<ShopData?>(
                future: ref.read(shopProvider.notifier).fetchShopData(currentOrder.shop?.id?.toString() ?? ''),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    return ValueListenableBuilder<bool>(
                      valueListenable: _isLoadingNotifier,
                      builder: (context, isLoading, _) {
                        return _orderItem(currentOrder, snapshot.data!, context, isLoading);
                      },
                    );
                  } else {
                    return const Center(child: Text('No shop data available'));
                  }
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _orderItem(OrderActiveModel order, ShopData shopData, BuildContext context, bool isLoading) {
    return ButtonEffectAnimation(
      onTap: () {
        context.pushRoute(
          OrderProgressRoute(
            orderId: (order.id ?? 0),
          ),
        );
      },
      child: UpcomingOrderWidget(
        order: order,
        shopData: shopData,
        isLoading: isLoading,
      ),
    );
  }
}

class UpcomingOrderWidget extends StatelessWidget {
  final OrderActiveModel order;
  final ShopData shopData;
  final bool isLoading;

  const UpcomingOrderWidget({
    super.key,
    required this.order,
    required this.shopData,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 120.h,
      decoration: BoxDecoration(
        color: _getStatusColor(order.status),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Stack(
        children: [
          Row(
            children: [
              Padding(
                padding: EdgeInsets.all(16.r),
                child: ShopAvatar(
                  radius: 30,
                  shopImage: shopData.logoImg ?? "",
                  size: 50,
                  padding: 0,
                  bgColor: AppStyle.transparent,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RichText(
                          text: TextSpan(
                            style: AppStyle.interNormal(color: AppStyle.white, size: 14),
                            children: [
                              TextSpan(text: "Order №${(order.id ?? "").toString()} is "),
                              TextSpan(
                                text: (order.status ?? "").isNotEmpty
                                    ? order.status![0].toUpperCase() + order.status!.substring(1)
                                    : "",
                                style: AppStyle.interBold(color: AppStyle.white, size: 14),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 16.r),
                          child: ETADisplay(order: order, shopData: shopData),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                  ],
                ),
              ),
            ],
          ),
          if (isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.3),
                child: const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppStyle.white),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'accepted':
        return Colors.blue;
      case 'processing':
        return Colors.orange;
      case 'ready':
        return Colors.green;
      case 'on_a_way':
        return Colors.deepPurple;
      case 'delivered':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}

class ETADisplay extends StatefulWidget {
  final OrderActiveModel order;
  final ShopData shopData;

  const ETADisplay({super.key, required this.order, required this.shopData});

  @override
  _ETADisplayState createState() => _ETADisplayState();
}

class _ETADisplayState extends State<ETADisplay> {
  late Timer _timer;
  late ValueNotifier<bool> _toggleNotifier;
  late ValueNotifier<String> _etaTextNotifier;

  @override
  void initState() {
    super.initState();
    _toggleNotifier = ValueNotifier(true);
    _etaTextNotifier = ValueNotifier(_getEtaText());
    _startAlternating();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _etaTextNotifier.value = _getEtaText();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _toggleNotifier.dispose();
    _etaTextNotifier.dispose();
    super.dispose();
  }

  void _startAlternating() async {
    while (true) {
      await Future.delayed(const Duration(seconds: 3));
      _toggleNotifier.value = true;
      await Future.delayed(const Duration(seconds: 3));
      _toggleNotifier.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _toggleNotifier,
      builder: (context, isShowingFirstPart, child) {
        return ValueListenableBuilder<String>(
          valueListenable: _etaTextNotifier,
          builder: (context, etaText, child) {
            final isDelayed = etaText == "Order Delayed";
            final displayText = isShowingFirstPart
                ? AppHelpers.getTranslation(TrKeys.ETA)
                : etaText;

            return GestureDetector(
              onTap: () {
                _showInfoPopup(context);
              },
              child: Container(
                width: 80.r,
                height: 40.r,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: isShowingFirstPart ? AppStyle.white : (isDelayed ? Colors.red : AppStyle.brandGreen),
                ),
                child: Center(
                  child: Text(
                    displayText,
                    style: AppStyle.interBold(
                      size: 16,
                      color: isShowingFirstPart ? AppStyle.brandGreen : AppStyle.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showInfoPopup(BuildContext context) {
    AppHelpers.showAlertDialog(
      context: context,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AppHelpers.getTranslation(TrKeys.TitleETA),
            style: AppStyle.interBold(
              size: 14,
              color: AppStyle.black,
            ),
          ),
          Text(
            AppHelpers.getTranslation(TrKeys.ETAtimeDialog),
            style: AppStyle.interNormal(
              size: 12,
              color: AppStyle.textGrey,
            ),
          ),
        ],
      ),
    );
  }

  String _getEtaText() {
    final createdAt = widget.order.createdAt;
    final deliveryTime = widget.shopData.deliveryTime;

    if (createdAt == null) {
      return "N/A";
    }

    if (deliveryTime == null || deliveryTime.to == null || deliveryTime.type == null) {
      return "N/A";
    }

    final int deliveryMinutes = _convertToMinutes(deliveryTime.to, deliveryTime.type);
    final now = DateTime.now();
    final int elapsedMinutes = now.difference(createdAt).inMinutes;

    if (elapsedMinutes > deliveryMinutes) {
      return "Order Delayed";
    } else {
      final int remainingMinutes = deliveryMinutes - elapsedMinutes;
      return _formatDuration(remainingMinutes);
    }
  }

  int _convertToMinutes(String? to, String? type) {
    if (to == null || type == null) {
      return 0;
    }

    double value = double.tryParse(to) ?? 0;
    switch (type.toLowerCase()) {
      case "min":
      case "minute":
        return value.round();
      case "hour":
        return (value * 60).round();
      case "day":
        return (value * 24 * 60).round();
      default:
        return value.round();
    }
  }

  String _formatDuration(int minutes) {
    if (minutes < 60) {
      return "$minutes min";
    } else {
      int hours = minutes ~/ 60;
      int remainingMinutes = minutes % 60;
      return "$hours${remainingMinutes > 0 ? ':${remainingMinutes.toString().padLeft(2, '0')}' : ''}";
    }
  }
}