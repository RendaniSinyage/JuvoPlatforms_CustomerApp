import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:riverpodtemp/infrastructure/models/data/parcel_order.dart';
import 'package:riverpodtemp/infrastructure/services/app_helpers.dart';
import 'package:riverpodtemp/infrastructure/services/tr_keys.dart';
import 'package:riverpodtemp/presentation/routes/app_router.dart';
import 'package:riverpodtemp/presentation/theme/theme.dart';

import '../../../../infrastructure/services/app_constants.dart';
import 'package:intl/intl.dart' as intl;

class ParcelItem extends StatelessWidget {
  final ParcelOrder? parcel;
  final bool isActive;

  const ParcelItem({
    super.key,
    required this.isActive,
    this.parcel,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushRoute(
          ParcelProgressRoute(
            parcelId: (parcel?.id ?? 0),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
            color: AppStyle.white,
            borderRadius: BorderRadius.all(Radius.circular(10.r))),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  height: 36.h,
                  width: 36.w,
                  decoration: BoxDecoration(
                    color: (isActive ? AppStyle.brandGreen : AppStyle.bgGrey),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(8),
                    ),
                  ),
                  child: Center(
                    child: isActive
                        ? Stack(
                            children: [
                              Center(
                                  child: SvgPicture.asset(
                                      "assets/svgs/orderTime.svg")),
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
                            AppHelpers.getOrderStatus(parcel?.status ?? "") ==
                                    OrderStatus.delivered
                                ? Icons.done_all
                                : Icons.cancel_outlined,
                            size: 16.r,
                          ),
                  ),
                ),
                10.horizontalSpace,
                Text(
                  "#${AppHelpers.getTranslation(TrKeys.id)}${parcel?.id}",
                  style: AppStyle.interNoSemi(
                    size: 16,
                  ),
                )
              ],
            ),
            22.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppHelpers.numberFormat(
                          isOrder: parcel?.currency?.symbol != null,
                          symbol: parcel?.currency?.symbol,
                          number: (parcel?.totalPrice?.isNegative ?? true)
                              ? 0
                              : (parcel?.totalPrice ?? 0)),
                      style: AppStyle.interNoSemi(
                        size: 16,
                      ),
                    ),
                    Text(
                      intl.DateFormat("MMM dd, HH:mm")
                          .format(parcel?.createdAt ?? DateTime.now()),
                      style: AppStyle.interRegular(
                        size: 12,
                      ),
                    )
                  ],
                ),
                Container(
                  width: 40.w,
                  height: 40.h,
                  decoration: const BoxDecoration(
                      color: AppStyle.enterOrderButton, shape: BoxShape.circle),
                  child: const Icon(
                    Icons.keyboard_arrow_right,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
