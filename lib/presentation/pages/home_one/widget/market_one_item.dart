import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:riverpodtemp/infrastructure/models/data/shop_data.dart';
import 'package:riverpodtemp/presentation/components/badge_item.dart';
import 'package:riverpodtemp/presentation/components/bonus_discount_popular.dart';
import 'package:riverpodtemp/presentation/components/custom_network_image.dart';
import 'package:riverpodtemp/presentation/components/shop_avarat.dart';
import 'package:riverpodtemp/presentation/routes/app_router.dart';

import '../../../theme/app_style.dart';

class MarketOneItem extends StatelessWidget {
  final ShopData shop;
  final bool isSimpleShop;
  final bool isShop;
  final bool isNewRestaurant;

  const MarketOneItem({
    super.key,
    this.isSimpleShop = false,
    required this.shop,
    this.isShop = false,
    this.isNewRestaurant = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushRoute(
            ShopRoute(shopId: (shop.id ?? 0).toString(), shop: shop));
      },
      child: isShop ? _shopItem() : _regularItem(context),
    );
  }

  Widget _regularItem(BuildContext context) {
    return Container(
      margin: isSimpleShop
          ? EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h)
          : EdgeInsets.only(right: 8.r),
      width: isNewRestaurant ? 250.w : 268.w,
      height: isNewRestaurant ? 250.h : 250.h,
      decoration: BoxDecoration(
          color: AppStyle.transparent,
          borderRadius: BorderRadius.all(Radius.circular(isNewRestaurant ? 40.r : 24.r))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppStyle.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(isNewRestaurant ? 40.r : 24.r),
                      topRight: Radius.circular(isNewRestaurant ? 40.r : 24.r),
                      bottomLeft: Radius.circular(isNewRestaurant ? 40.r : 0),
                      bottomRight: Radius.circular(isNewRestaurant ? 40.r : 0)),
                ),
                width: double.infinity,
                height: isNewRestaurant ? 190.h : 190.h,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(isNewRestaurant ? 40.r : 24.r),
                      topRight: Radius.circular(isNewRestaurant ? 40.r : 24.r),
                      bottomLeft: Radius.circular(isNewRestaurant ? 40.r : 0),
                      bottomRight: Radius.circular(isNewRestaurant ? 40.r : 0)),
                  child: CustomNetworkImage(
                    url: shop.backgroundImg ?? '',
                    height: isNewRestaurant ? 190.h : 190.h,
                    width: double.infinity,
                    radius: 0,
                  ),
                ),
              ),
              Positioned(
                top: 16.h,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18.w),
                  child: Padding(
                    padding: EdgeInsets.only(bottom: isSimpleShop ? 6.h : 0),
                    child: BonusDiscountPopular(
                        isPopular: shop.isRecommend ?? false,
                        bonus: shop.bonus,
                        isDiscount: shop.isDiscount ?? false),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        (shop.translation?.title?.length ?? 0) > 12
                            ? "${shop.translation?.title?.substring(0, 12) ?? " "}.."
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
                        )
                    ],
                  ),
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width / 2 + 30.r,
                    child: Text(
                      "${shop.deliveryTime?.from ?? 0} - ${shop.deliveryTime?.to ?? 0} ${shop.deliveryTime?.type ?? "min"}",
                      style: AppStyle.interNormal(
                        size: 14,
                        color: AppStyle.black,
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              ShopAvatar(
                shopImage: shop.logoImg ?? "",
                size: isSimpleShop ? 50 : 44,
                padding: 4.r,
                bgColor: AppStyle.transparent,
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _shopItem() {
    return Padding(
      padding: EdgeInsets.only(right: 10.r),
      child: Column(
        children: [
          if (isNewRestaurant)
            Container(
              width: 60.r,
              height: 60.r,
              decoration: BoxDecoration(
                color: AppStyle.white,
                borderRadius: BorderRadius.all(Radius.circular(12.r)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(12.r)),
                child: CustomNetworkImage(
                  url: shop.logoImg ?? "",
                  height: 60.r,
                  width: 60.r,
                  radius: 0,
                ),
              ),
            )
          else
            CustomNetworkImage(
              url: shop.logoImg ?? "",
              height: 60.r,
              width: 60.r,
              radius: 30.r,
            ),
        ],
      ),
    );
  }
}