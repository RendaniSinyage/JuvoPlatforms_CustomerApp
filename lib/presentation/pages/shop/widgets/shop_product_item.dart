import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodyman/infrastructure/services/app_helpers.dart';
import 'package:foodyman/presentation/components/buttons/animation_button_effect.dart';
import 'package:foodyman/presentation/components/custom_network_image.dart';
import 'package:foodyman/presentation/theme/theme.dart';

import 'package:foodyman/infrastructure/models/response/all_products_response.dart';
import 'bonus_screen.dart';

class ShopProductItem extends StatelessWidget {
  final Product product;

  const ShopProductItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(4.r),
      decoration: BoxDecoration(
          color: AppStyle.white,
          borderRadius: BorderRadius.circular(10.r)),
      child: Padding(
        padding: EdgeInsets.all(14.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomNetworkImage(
                url: product.img ?? "",
                height: 100.h,
                width: double.infinity,
                radius: 0),
            8.verticalSpace,
            Text(
              product.translation?.title ?? "",
              style: AppStyle.interNoSemi(
                size: 14,
                color: AppStyle.black,
              ),
              maxLines: 2,
            ),
            Text(
              product.translation?.description ?? "",
              style: AppStyle.interRegular(
                size: 12,
                color: AppStyle.textGrey,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppHelpers.numberFormat(
                          number: (product.discounts?.isNotEmpty ?? false
                                  ? ((product.stock?.price ?? 0) +
                                      (product.stock?.tax ?? 0))
                                  : null) ??
                              (product.stock?.totalPrice ?? 0)),
                      style: AppStyle.interNoSemi(
                          size: 16,
                          color: AppStyle.black,
                          decoration: (product.discounts?.isNotEmpty ?? false
                                      ? ((product.stock?.price ?? 0) +
                                          (product.stock?.tax ?? 0))
                                      : null) ==
                                  null
                              ? TextDecoration.none
                              : TextDecoration.lineThrough),
                    ),
                    (product.discounts?.isNotEmpty ?? false
                                ? ((product.stock?.price ?? 0) +
                                    (product.stock?.tax ?? 0))
                                : null) ==
                            null
                        ? const SizedBox.shrink()
                        : Container(
                            margin: EdgeInsets.only(top: 8.r),
                            decoration: BoxDecoration(
                                color: AppStyle.redBg,
                                borderRadius: BorderRadius.circular(30.r)),
                            padding: EdgeInsets.all(4.r),
                            child: Row(
                              children: [
                                SvgPicture.asset("assets/svgs/discount.svg"),
                                8.horizontalSpace,
                                Text(
                                  AppHelpers.numberFormat(
                                      number: (product.stock?.totalPrice ?? 0)),
                                  style: AppStyle.interNoSemi(
                                      size: 12, color: AppStyle.red),
                                )
                              ],
                            ),
                          ),
                  ],
                ),
                product.stock?.bonus != null
                    ? AnimationButtonEffect(
                        child: InkWell(
                          onTap: () {
                            AppHelpers.showCustomModalBottomSheet(
                              paddingTop: MediaQuery.paddingOf(context).top,
                              context: context,
                              modal: BonusScreen(
                                bonus: product.stock?.bonus,
                              ),
                              isDarkMode: false,
                              isDrag: true,
                              radius: 12,
                            );
                          },
                          child: Container(
                            width: 22.w,
                            height: 22.h,
                            margin: EdgeInsets.only(
                                top: 8.r, left: 8.r, right: 4.r, bottom: 4.r),
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle, color: AppStyle.blueBonus),
                            child: Icon(
                              FlutterRemix.gift_2_fill,
                              size: 16.r,
                              color: AppStyle.white,
                            ),
                          ),
                        ),
                      )
                    : const SizedBox.shrink()
              ],
            ),
          ],
        ),
      ),
    );
  }
}
