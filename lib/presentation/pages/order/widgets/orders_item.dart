import 'package:auto_route/auto_route.dart';
//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
//import 'package:flutter_svg/flutter_svg.dart';
import 'package:riverpodtemp/infrastructure/models/data/order_active_model.dart';
import 'package:riverpodtemp/infrastructure/models/data/refund_data.dart';
import 'package:riverpodtemp/infrastructure/services/app_helpers.dart';
import 'package:riverpodtemp/infrastructure/services/tr_keys.dart';
import 'package:riverpodtemp/presentation/components/title_icon.dart';
//import 'package:riverpodtemp/presentation/components/shop_avarat.dart';
import 'package:riverpodtemp/presentation/routes/app_router.dart';
import 'package:riverpodtemp/presentation/theme/theme.dart';

//import '../../../../infrastructure/services/app_constants.dart';
import 'package:intl/intl.dart' as intl;

class OrdersItem extends StatelessWidget {
  final OrderActiveModel? order;
  final RefundModel? refund;
  final bool isActive;
  final bool isRefund;

  const OrdersItem({
    super.key,
    required this.isActive,
    this.isRefund = false,
    this.order,
    this.refund,
  });

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () {
        context.pushRoute(
          OrderProgressRoute(
            orderId: isRefund ? (refund?.order?.id ?? 0) : (order?.id ?? 0),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: AppStyle.white,
          borderRadius: BorderRadius.all(Radius.circular(10.r)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 2),
                Text(
                  intl.DateFormat("MMM").format(order?.createdAt ?? DateTime.now()).toUpperCase(),
                  style: AppStyle.interRegular(
                    size: 20,
                  ),
                ),
                Text(
                  intl.DateFormat("dd").format(order?.createdAt ?? DateTime.now()),
                  style: AppStyle.interNoSemi(
                    size: 20,
                  ),
                ),
                Text(
                  intl.DateFormat("HH:mm").format(order?.createdAt ?? DateTime.now()),
                  style: AppStyle.interRegular(
                    size: 12,
                  ),
                ),
              ],
            ),
            SizedBox(width: 10.w),
           /* Container(
              height: 36.h,
              width: 36.w,
              decoration: BoxDecoration(
                color: isRefund
                    ? ((refund?.status ?? "") == "pending"
                    ? AppStyle.brandGreen
                    : AppStyle.bgGrey)
                    : (isActive ? AppStyle.brandGreen : AppStyle.bgGrey),
                borderRadius: const BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
              child: isRefund
                  ? Center(
                child: (refund?.status ?? "") == "pending"
                    ? Stack(
                  children: [
                    Center(
                      child: SvgPicture.asset(
                        "assets/svgs/orderTime.svg",
                      ),
                    ),
                    Center(
                      child: Text(
                        "15",
                        style: AppStyle.interNoSemi(
                          size: 10,
                        ),
                      ),
                    ),
                  ],
                )
                    : Icon(
                  (refund?.status ?? "") == "accepted"
                      ? Icons.done_all
                      : Icons.cancel_outlined,
                  size: 16.r,
                ),
              )
                  : Center(
                child: isActive
                    ? Stack(
                  children: [
                    Center(
                      child: SvgPicture.asset(
                        "assets/svgs/orderTime.svg",
                      ),
                    ),
                    Center(
                      child: Text(
                        "15",
                        style: AppStyle.interNoSemi(
                          size: 10,
                        ),
                      ),
                    ),
                  ],
                )
                    : Icon(
                  AppHelpers.getOrderStatus(order?.status ?? "") ==
                      OrderStatus.delivered
                      ? Icons.done_all
                      : Icons.cancel_outlined,
                  size: 16.r,
                ),
              ),
            ), */
        //    SizedBox(width: 6.w),
        /*    ShopAvatar(
              shopImage: isRefund
                  ? (refund?.order?.shop?.logoImg ?? "")
                  : (order?.shop?.logoImg ?? ""),
              size: 36,
              padding: 4,
              radius: 6,
              bgColor: AppStyle.bgGrey,
            ), */
          //  SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10.h),
                  Text(
                    isRefund
                        ? (refund?.order?.shop?.translation?.title ?? "")
                        : (order?.shop?.translation?.title ?? ""),
                    style: AppStyle.interNoSemi(
                      size: 20,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    children: [
                      Text(
                        "№${order?.id.toString() ?? "0"} • ${order?.deliveryType ?? ""} • ",
                        style: AppStyle.interRegular(
                          size: 14,
                        ),
                      ),
                      Text(
                        isRefund
                            ? AppHelpers.getTranslation(TrKeys.cause)
                            : AppHelpers.numberFormat(
                            isOrder: order?.currencyModel?.symbol != null,
                            symbol: order?.currencyModel?.symbol,
                            number: isRefund
                                ? 0
                                : (order?.totalPrice?.isNegative ?? true)
                                ? 0
                                : (order?.totalPrice ?? 0)),
                        style: AppStyle.interBold(
                          size: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    /*  Text(
                        " • ",
                        style: TextStyle(color: Colors.black),
                      ),
                      Text(
                        intl.DateFormat("HH:mm").format(order?.createdAt ?? DateTime.now()),
                        style: AppStyle.interRegular(
                          size: 12,
                        ),
                      ), */
                    ],
                  ),
                  if (isRefund)
                    Text(
                      refund?.cause ?? "",
                      style: AppStyle.interRegular(
                        size: 12,
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(width: 10.w),
            TitleAndIcon(
              // rightTitle: AppHelpers.getTranslation(TrKeys.seeAll),
              isIcon: true,
              //title: AppHelpers.getTranslation(TrKeys.favouriteBrand),
              onRightTap: () {
                context.pushRoute(
                  OrderProgressRoute(
                    orderId: isRefund ? (refund?.order?.id ?? 0) : (order?.id ?? 0),
                  ),
                );
              },

            ),
         /*  Container(
              width: 50.w,
              height: 50.h,
              decoration: const BoxDecoration(
                  color: AppStyle.black, shape: BoxShape.circle),
              child: const Icon(
                Icons.arrow_forward,
                 color: AppStyle.white,
              ),
            ), */
          ],
        ),
      ),
    );
  }
}
