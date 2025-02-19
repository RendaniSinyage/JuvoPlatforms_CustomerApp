import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodyman/infrastructure/models/data/shop_data.dart';
import 'package:foodyman/infrastructure/services/app_helpers.dart';
import 'package:foodyman/infrastructure/services/tr_keys.dart';
import 'package:foodyman/presentation/components/bonus_discount_popular.dart';
import 'package:foodyman/presentation/components/custom_network_image.dart';
import 'package:foodyman/presentation/routes/app_router.dart';

import 'package:foodyman/presentation/theme/theme.dart';
import 'badge_item.dart';
import 'shop_avarat.dart';

class MarketItem extends StatelessWidget {
  final ShopData shop;
  final bool isSimpleShop;
  final bool isShop;

  const MarketItem({
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
          ? _shopItem(context)
          : Container(
              margin: isSimpleShop
                  ? EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h)
                  : EdgeInsets.only(right: 8.r),
              width: 268.w,
              height: 260.h,
              decoration: BoxDecoration(
                  color: AppStyle.white,
                  borderRadius: BorderRadius.circular(10.r)),
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 118.h,
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10.r),
                            topRight: Radius.circular(10.r),
                          ),
                          child: CustomNetworkImage(
                            url: shop.backgroundImg ?? '',
                            height: 118.h,
                            width: double.infinity,
                            radius: 0,
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: Row(
                              children: [
                                Text(
                                  (shop.translation?.title?.length ?? 0) > 12
                                      ? "${shop.translation?.title?.substring(0, 12) ?? " "}.."
                                      : shop.translation?.title ?? "",
                                  style: AppStyle.interSemi(
                                    size: 15,
                                    color: AppStyle.black,
                                  ),
                                ),
                                if (shop.verify ?? false)
                                  Padding(
                                    padding: EdgeInsets.only(left: 4.r),
                                    child: const BadgeItem(),
                                  )
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
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
                          8.verticalSpace,
                          Divider(
                            color: AppStyle.black.withOpacity(0.3),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                top: 8.h,
                                right: 16.w,
                                left: 16.w,
                                bottom: 14.h),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SvgPicture.asset("assets/svgs/delivery.svg"),
                                10.horizontalSpace,
                                Text(
                                  "${shop.deliveryTime?.from ?? 0} - ${shop.deliveryTime?.to ?? 0} ${shop.deliveryTime?.type ?? "min"}",
                                  style: AppStyle.interNormal(
                                    size: 14,
                                    color: AppStyle.black,
                                  ),
                                ),
                                10.horizontalSpace,
                                Container(
                                  width: 5.w,
                                  height: 5.h,
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppStyle.separatorDot),
                                ),
                                10.horizontalSpace,
                                SvgPicture.asset("assets/svgs/star.svg"),
                                10.horizontalSpace,
                                Text(
                                  (shop.avgRate ?? ""),
                                  style: AppStyle.interNormal(
                                    size: 14,
                                    color: AppStyle.black,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  Positioned(
                    top: 86.h,
                    right: 0,
                    left: 0,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 18.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          ShopAvatar(
                            shopImage: shop.logoImg ?? "",
                            size: isSimpleShop ? 50 : 44,
                            padding: 4.r,
                          ),
                          Padding(
                            padding:
                                EdgeInsets.only(bottom: isSimpleShop ? 6.h : 0),
                            child: BonusDiscountPopular(
                                isPopular: shop.isRecommend ?? false,
                                bonus: shop.bonus,
                                isDiscount: shop.isDiscount ?? false),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _shopItem(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(4.r),
      width: MediaQuery.sizeOf(context).width / 2 - 32,
      height: 140.r,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
          color: AppStyle.white,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: AppStyle.borderColor)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomNetworkImage(
            url: shop.logoImg ?? "",
            height: 80,
            width: 80,
            radius: 40,
          ),
          8.verticalSpace,
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  (shop.translation?.title?.length ?? 0) > 12
                      ? "${shop.translation?.title?.substring(0, 12) ?? " "}.."
                      : shop.translation?.title ?? "",
                  style: AppStyle.interSemi(
                    size: 15,
                    color: AppStyle.black,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (shop.verify ?? false)
                  Padding(
                    padding: EdgeInsets.only(left: 4.r),
                    child: const BadgeItem(),
                  )
              ],
            ),
          ),
          8.verticalSpace,
          Text(
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
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}
