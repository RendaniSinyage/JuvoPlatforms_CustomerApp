import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:riverpodtemp/infrastructure/services/app_helpers.dart';
import 'package:riverpodtemp/infrastructure/services/local_storage.dart';
import 'package:riverpodtemp/infrastructure/services/tr_keys.dart';
import 'package:riverpodtemp/presentation/components/custom_tab_bar.dart';
import 'package:riverpodtemp/presentation/theme/theme.dart';
import 'widgets/order_delivery.dart';
import 'widgets/order_pick_up.dart';

class OrderType extends StatefulWidget {
  final ValueChanged<bool> onChange;
  final VoidCallback getLocation;
  final TabController tabController;
  final int shopId;
  final bool sendUser;

  const OrderType({
    super.key,
    required this.onChange,
    required this.getLocation,
    required this.tabController,
    required this.shopId,
    required this.sendUser,
  });

  @override
  State<OrderType> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderType> {
  final _tabs = [
    Tab(text: AppHelpers.getTranslation(TrKeys.delivery)),
    Tab(text: AppHelpers.getTranslation(TrKeys.pickup)),
  ];

  @override
  Widget build(BuildContext context) {
    final bool isLtr = LocalStorage.getLangLtr();
    return Directionality(
      textDirection: isLtr ? TextDirection.ltr : TextDirection.rtl,
      child: Container(
        padding: EdgeInsets.only(top: 16.r, right: 16.r, left: 16.r),
        decoration: BoxDecoration(
            color: AppStyle.white,
            borderRadius: BorderRadius.all(Radius.circular(10.r))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTabBar(
              tabController: widget.tabController,
              tabs: _tabs,
            ),
            SizedBox(
              height: widget.sendUser ? 550.r : 496.r,
              child: TabBarView(controller: widget.tabController, children: [
                OrderDelivery(
                  onChange: widget.onChange,
                  getLocation: widget.getLocation,
                  shopId: widget.shopId,
                ),
                const OrderPickUp(),
              ]),
            )
          ],
        ),
      ),
    );
  }
}
