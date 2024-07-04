import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:riverpodtemp/infrastructure/models/data/shop_data.dart';
import 'package:riverpodtemp/infrastructure/services/app_helpers.dart';
import 'package:riverpodtemp/infrastructure/services/tr_keys.dart';
import 'package:riverpodtemp/presentation/components/badges.dart';
import 'package:riverpodtemp/presentation/components/custom_network_image.dart';
import 'package:riverpodtemp/presentation/components/shop_avarat.dart';
import 'package:riverpodtemp/presentation/routes/app_router.dart';
import 'package:riverpodtemp/presentation/theme/theme.dart';

class RecommendedItem extends StatelessWidget {
  final ShopData shop;

  const RecommendedItem({
    super.key,
    required this.shop,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      final isNarrow = constraints.maxWidth < screenWidth / 2;
      return GestureDetector(
        onTap: () {
          // context.pushRoute(ShopRoute(shopId: (shop.id ?? 0).toString()));
          context.pushRoute(
              ShopRoute(shopId: (shop.id ?? 0).toString(), shop: shop));
        },
        child: Container(
          margin: EdgeInsets.only(left: 0, right: 9.r),
          width: MediaQuery.sizeOf(context).width / 3,
          height: 190.h,
          decoration: BoxDecoration(
              color: AppStyle.recommendBg,
              borderRadius: BorderRadius.all(Radius.circular(10.r))),
          child: Stack(
            children: [
              CustomNetworkImage(
                  url: shop.backgroundImg ?? "",
                  width: MediaQuery.sizeOf(context).width / 2,
                  height: 190.h,
                  radius: 10.r),
              Padding(
                padding: EdgeInsets.all(12.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        ShopBadge(
                          shop: shop,
                          top: 8.h,
                         // left: 0.w,
                          iconSize: isNarrow ? 22 : 22,
                          containerHeight: isNarrow ? 30 : 30.h,
                         // containerHeight: isNarrow ? 30 : 50.h,
                          containerWidth: isNarrow ? 130.w : 100.w,
                         // containerWidth: isNarrow ? 130.w : 150.w,
                          //containerWidth: isNarrow ? 130.w : 190.w,
                          fontSize: isNarrow ? 10 : 8,
                          maxTextLength: 12,
                        ),
                       // 8.horizontalSpace,

                      ],
                    ),

                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 4.h, horizontal: 12.w),
                      decoration: BoxDecoration(
                          color: AppStyle.black.withOpacity(0.8),
                          borderRadius:
                              BorderRadius.all(Radius.circular(100.r))),
                      child: Text(
                        "${shop.productsCount ?? 0}  ${AppHelpers.getTranslation(TrKeys.products)}",
                        style: AppStyle.interNormal(
                          size: 12,
                          color: AppStyle.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
