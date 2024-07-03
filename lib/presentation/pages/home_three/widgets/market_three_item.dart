import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:riverpodtemp/infrastructure/models/data/shop_data.dart';
import 'package:riverpodtemp/infrastructure/services/app_helpers.dart';
import 'package:riverpodtemp/infrastructure/services/tr_keys.dart';
import 'package:riverpodtemp/presentation/components/badge_item.dart';
import 'package:riverpodtemp/presentation/components/bonus_discount_popular.dart';
import 'package:riverpodtemp/presentation/components/custom_network_image.dart';
import 'package:riverpodtemp/presentation/routes/app_router.dart';

import '../../../theme/app_style.dart';

class MarketThreeItem extends StatelessWidget {
  final ShopData shop;
  final bool isSimpleShop;
  final bool isShop;

  const MarketThreeItem({
    super.key,
    this.isSimpleShop = false,
    required this.shop,
    this.isShop = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushRoute(
            ShopRoute(shopId: (shop.id ?? 0).toString(), shop: shop));
      },
      child: isShop
          ? _shopItem()
          : Container(
              margin: isSimpleShop
                  ? EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h)
                  : EdgeInsets.only(right: 8.r),
              width: 268.w,
              height: 280.h,
              // foregroundDecoration: BoxDecoration(
              //   color: !(shop.open ?? true) ? Style.white.withOpacity(0.5) : Style.transparent
              // ),
              decoration: BoxDecoration(
                  color: AppStyle.bgGrey,
                  borderRadius: BorderRadius.all(Radius.circular(10.r))),
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 180.h,
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10.r),
                              topRight: Radius.circular(10.r)),
                          child: CustomNetworkImage(
                            url: shop.backgroundImg ?? '',
                            height: 180.h,
                            width: double.infinity,
                            radius: 16,
                          ),
                        ),
                      ),
                      Padding(
                        padding: REdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      (shop.translation?.title?.length ?? 0) > 28
                                          ? "${shop.translation?.title?.substring(0, 28) ?? " "}.."
                                          : shop.translation?.title ?? "",
                                      style: AppStyle.interSemi(
                                        size: 16,
                                        color: AppStyle.black,
                                      ),
                                    ),
                                    if(shop.verify ?? false)
                                      Padding(
                                        padding: EdgeInsets.only(left: 4.r),
                                        child: const BadgeItem(),
                                      ),
                                  ],
                                ),

                                Container(
                                  padding: REdgeInsets.all(8),
                                  decoration: const ShapeDecoration(
                                    color: AppStyle.borderColor,
                                    shape: CircleBorder(),
                                  ),
                                  child: Text(
                                    (shop.avgRate ?? ""),
                                    style: AppStyle.interNormal(
                                      size: 12,
                                      color: AppStyle.black,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            4.verticalSpace,
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    shop.bonus != null
                                        ? ((shop.bonus?.type ?? "sum") == "sum")
                                            ? "${AppHelpers.getTranslation(TrKeys.under)} ${AppHelpers.numberFormat(
                                                number: shop.bonus?.value,
                                              )} + ${shop.bonus?.bonusStock?.product?.translation?.title ?? ""}"
                                            : "${AppHelpers.getTranslation(TrKeys.under)} ${shop.bonus?.value ?? 0} + ${shop.bonus?.bonusStock?.product?.translation?.title ?? ""}"
                                        : shop.translation?.description ?? "",
                                    style: AppStyle.interNormal(
                                      size: 12,
                                      color: AppStyle.black,
                                    ),
                                    maxLines: 2,
                                  ),
                                ),
                                6.horizontalSpace,
                                Container(
                                  width: 5.w,
                                  height: 5.h,
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppStyle.separatorDot),
                                ),
                                8.horizontalSpace,
                                Text(
                                  "${shop.deliveryTime?.from ?? 0}-${shop.deliveryTime?.to ?? 0} ${shop.deliveryTime?.type ?? "min"}",
                                  style: AppStyle.interNormal(
                                    size: 12,
                                    color: AppStyle.black,
                                  ),
                                ),
                              ],
                            ),
                            16.verticalSpace,
                          ],
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    top: 150.r,
                    right: 0,
                    left: 0,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 18.w),
                      child: Padding(
                        padding:
                            EdgeInsets.only(bottom: isSimpleShop ? 6.h : 0),
                        child: BonusDiscountPopular(
                            isPopular: shop.isRecommend ?? false,
                            bonus: shop.bonus,
                            isDiscount: shop.isDiscount ?? false),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _shopItem() {
    return Container(
      padding: REdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: AppStyle.borderColor,width: 1.2),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          24.verticalSpace,
          CustomNetworkImage(
            url: shop.logoImg ?? "",
            height: 66.r,
            width: 66.r,
            radius: 33.r,
          ),
          const Spacer(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  shop.translation?.title ?? "",
                  style: AppStyle.interSemi(
                    size: 14,
                    color: AppStyle.black,
                  ),
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if(shop.verify ?? false)
                Padding(
                  padding: EdgeInsets.only(left: 4.r),
                  child: const BadgeItem(),
                )
            ],
          ),
          6.verticalSpace,
          Text(
            "${shop.deliveryTime?.from ?? 0} - ${shop.deliveryTime?.to ?? 0} ${shop.deliveryTime?.type ?? "min"}",
            style: AppStyle.interSemi(
              size: 12,
              color: AppStyle.textGrey,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          28.verticalSpace,
        ],
      ),
    );
  }
}
