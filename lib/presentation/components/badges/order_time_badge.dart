//import 'dart:math' show cos, sqrt, asin;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:remixicon/remixicon.dart';
import '../../../infrastructure/models/data/shop_data.dart';
import '../../../infrastructure/services/app_helpers.dart';
import '../../../infrastructure/services/tr_keys.dart';
import '../../theme/app_style.dart';

class OpTimeBadge extends StatelessWidget {
  final ShopData shop;
  final double? bottom;
  final String? workTime;
  final double? left;
  final double? right;
  final double? top;

  const OpTimeBadge({
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
    //final double rating = double.tryParse(shop.avgRate ?? '0') ?? 0;
    return


    Positioned(
      bottom: bottom,
      left: left,
      right: right,
      top: top,
      child: //(shop.avgRate == 3) //&& AppHelpers.getTranslation(TrKeys.close) == workTime
         // ?
       ClipRRect(
        borderRadius: BorderRadius.circular(10.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
            decoration: BoxDecoration(
              color:  //(AppHelpers.getTranslation(TrKeys.close) == workTime)
              shop.open == true
                 ? Colors.green.withOpacity(0.3) : AppStyle.red,
            borderRadius: BorderRadius.circular(10.r),
            ),
            child:   //(AppHelpers.getTranslation(TrKeys.close) == workTime)
              shop.open == true
                ? Row(
                  children: [
                    const Icon(
                      Remix.time_fill,
                      color: AppStyle.white,
                      size:15,
                    ),
                    8.horizontalSpace,
                    Text(
                     // "${shop.deliveryTime?.from ?? 0}-${shop.deliveryTime?.to ?? 0} ${shop.deliveryTime?.type ?? "min"}",
                      //"in i want  ${shop.deliveryTime?.type ?? "min"}",
                      //"in ${shop.deliveryTime?.to ?? 0} ${shop.deliveryTime?.type ?? "min"}",
                      "ETA: ${shop.deliveryTime?.to?.toString() ?? 0} ${shop.deliveryTime?.type ?? "min"}",
                        style: AppStyle.interNormal(
                          size: 12,
                          color: AppStyle.white,
                        ),
                        textAlign: TextAlign.start,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                  ],
                ) : Row(
              children: [
                const Icon(
                  Remix.emotion_sad_fill,
                  color: AppStyle.white,
                  size:15,
                ),
                8.horizontalSpace,
                Text(
                  // "${shop.deliveryTime?.from ?? 0}-${shop.deliveryTime?.to ?? 0} ${shop.deliveryTime?.type ?? "min"}",
                  //"in i want  ${shop.deliveryTime?.type ?? "min"}",
                  //"in ${shop.deliveryTime?.to ?? 0} ${shop.deliveryTime?.type ?? "min"}",
                  "We are Closed",
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
            ),
          ),
        ),

    );
  }
}
