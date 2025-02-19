import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodyman/infrastructure/models/data/parcel_order.dart';
import 'package:foodyman/infrastructure/services/app_helpers.dart';
import 'package:foodyman/infrastructure/services/enums.dart';
import 'package:foodyman/infrastructure/services/time_service.dart';
import 'package:foodyman/infrastructure/services/tr_keys.dart';
import 'package:foodyman/presentation/routes/app_router.dart';
import 'package:foodyman/presentation/theme/theme.dart';

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
            borderRadius: BorderRadius.circular(10.r)),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  height: 36.h,
                  width: 36.w,
                  decoration: BoxDecoration(
                    color: (isActive ? AppStyle.primary : AppStyle.bgGrey),
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
                      TimeService.dateFormatMDHm(parcel?.createdAt),
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
