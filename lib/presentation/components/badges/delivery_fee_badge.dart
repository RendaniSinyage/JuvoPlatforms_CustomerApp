//import 'dart:math' show cos, sqrt, asin;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:remixicon/remixicon.dart';
//import 'package:flutter_svg/flutter_svg.dart';
import '../../../infrastructure/models/data/shop_data.dart';
//import '../../../infrastructure/services/app_constants.dart';
import '../../../infrastructure/services/app_helpers.dart';
//import '../../../infrastructure/services/tr_keys.dart';
import '../../../infrastructure/services/tr_keys.dart';
import '../../theme/app_style.dart';
//import 'package:riverpodtemp/application/shop/shop_provider.dart';
//import '../../../infrastructure/services/local_storage.dart';
//import '../../../utils/utils.dart';

class DeliveryFeeBadge extends StatelessWidget {
  final ShopData shop;
  final double? bottom;
  final String? workTime;
  final double? left;
  final double? right;
  final double? top;

  const DeliveryFeeBadge({
    super.key,
    required this.shop,
    this.bottom,
    this.left,
    this.workTime,
    this.right,
    this.top,
  });

  @override
  Widget build(BuildContext context) {
    Color color = (shop.deliveryRange! > 0 || shop.price! > 0)
        ? AppStyle.black.withOpacity(0.3)
        : AppStyle.red;
    return Positioned(
      bottom: bottom ?? 20.h,
      left: left,
      right: right ?? 98.w,
      top: top,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
            decoration: BoxDecoration(
              color: color,
            borderRadius: BorderRadius.circular(10.r),
            ),
            child: shop.open == false //&& AppHelpers.getTranslation(TrKeys.close) == workTime
                ? Row(
                  children: [
                    const Icon(
                      Remix.time_fill,
                      color: AppStyle.white,
                      size:15,
                    ),
                    8.horizontalSpace,
                    Text(
                        AppHelpers.getTranslation(
                            TrKeys.close),
                        style: AppStyle.interNormal(
                          size: 12,
                          color: AppStyle.white,
                        ),
                        textAlign: TextAlign.start,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                  ],
                )
                :
            Row(
              children: [
                (shop.deliveryRange! > 0 || shop.price! > 0)
                    ?  Row(
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                               const Icon(Remix.truck_fill,
                                  color: AppStyle.white, size: 12),
                              5.horizontalSpace,
                              Text(
                                "from ${AppHelpers.numberFormat(number: shop.price)}",
                                style: AppStyle.interNormal(
                                  size: 13,
                                  color: AppStyle.white,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              // const SizedBox(width: 10),
                            ],
                          )
                        ],
                      ) :
                Row(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Remix.price_tag_3_line,
                            color: AppStyle.white, size: 15),
                        5.horizontalSpace,
                        Text(
                          "Free Delivery",
                          style: AppStyle.interNormal(
                            size: 13,
                            color: AppStyle.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        // const SizedBox(width: 10),
                      ],
                    )
                  ],
                ),
              ],
            ),
            ),
          ),
        ),

    );
  }
}
