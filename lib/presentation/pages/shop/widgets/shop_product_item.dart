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
      decoration: BoxDecoration(
          color: AppStyle.white,
          borderRadius: BorderRadius.circular(10.r)),
      child: Padding(
        padding: EdgeInsets.all(10.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child: Center(
                child: CustomNetworkImage(
                  url: product.img ?? "",
                  height: 80.h,
                  width: double.infinity,
                  radius: 8.r,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  8.verticalSpace,
                  Text(
                    product.translation?.title ?? "",
                    style: AppStyle.interNoSemi(
                      size: 14,
                      color: AppStyle.black,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  4.verticalSpace,
                  Text(
                    product.translation?.description ?? "",
                    style: AppStyle.interRegular(
                      size: 12,
                      color: AppStyle.textGrey,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
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
                                  size: 14,
                                  color: AppStyle.black,
                                  decoration: (product.discounts?.isNotEmpty ?? false
                                      ? ((product.stock?.price ?? 0) +
                                      (product.stock?.tax ?? 0))
                                      : null) ==
                                      null
                                      ? TextDecoration.none
                                      : TextDecoration.lineThrough),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            (product.discounts?.isNotEmpty ?? false
                                ? ((product.stock?.price ?? 0) +
                                (product.stock?.tax ?? 0))
                                : null) ==
                                null
                                ? const SizedBox.shrink()
                                : Container(
                              margin: EdgeInsets.only(top: 4.r),
                              decoration: BoxDecoration(
                                  color: AppStyle.redBg,
                                  borderRadius: BorderRadius.circular(30.r)),
                              padding: EdgeInsets.symmetric(horizontal: 4.r, vertical: 2.r),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SvgPicture.asset("assets/svgs/discount.svg", width: 12.w),
                                  4.horizontalSpace,
                                  Flexible(
                                    child: Text(
                                      AppHelpers.numberFormat(
                                          number: (product.stock?.totalPrice ?? 0)),
                                      style: AppStyle.interNoSemi(
                                          size: 10, color: AppStyle.red),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
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
                            margin: EdgeInsets.only(left: 4.r),
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle, color: AppStyle.blueBonus),
                            child: Icon(
                              FlutterRemix.gift_2_fill,
                              size: 14.r,
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
          ],
        ),
      ),
    );
  }
}