import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:riverpodtemp/infrastructure/services/app_helpers.dart';
import 'package:riverpodtemp/presentation/components/buttons/animation_button_effect.dart';
import 'package:riverpodtemp/presentation/components/custom_network_image.dart';
import 'package:riverpodtemp/presentation/theme/theme.dart';

import '../../../../infrastructure/models/response/all_products_response.dart';
import 'bonus_screen.dart';

class ShopProductItem extends StatelessWidget {
  final Product product;

  const ShopProductItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    // return Container(
    //   margin: const EdgeInsets.symmetric(vertical: 5),
    //   width: double.infinity,
    //   decoration: BoxDecoration(
    //       borderRadius: BorderRadius.circular(10),
    //       border: Border.all(color: Colors.grey, width: 0.5)),
    //   padding: const EdgeInsets.all(10),
    //   child: Stack(
    //     children: [
    //       Row(
    //         crossAxisAlignment: CrossAxisAlignment.center,
    //         children: [
    //           Expanded(
    //             flex: 2,
    //             child: Column(
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: [
    //                 Text(
    //                   product.translation?.title ?? "",
    //                   style: AppStyle.interSemi(size: 16),
    //                 ),
    //                 10.verticalSpace,
    //                 Text(
    //                   product.translation?.description ?? "",
    //                   style:
    //                       AppStyle.interRegular(color: Colors.black, size: 14),
    //                 ),
    //                 10.verticalSpace,
    //                 Row(
    //                   children: [
    //                     Padding(
    //                       padding: const EdgeInsets.only(top: 10),
    //                       child: Text(
    //                         AppHelpers.numberFormat(
    //                             number: (product.stocks?.first.discount != null
    //                                     ? ((product.stocks?.first.price ?? 0) +
    //                                         (product.stocks?.first.tax ?? 0))
    //                                     : null) ??
    //                                 (product.stocks?.first.totalPrice ?? 0)),
    //                         style: AppStyle.interSemi(size: 15),
    //                       ),
    //                     ),
    //                     10.horizontalSpace,
    //                     (product.stocks?.first.discount != null
    //                                 ? ((product.stocks?.first.price ?? 0) +
    //                                     (product.stocks?.first.tax ?? 0))
    //                                 : null) ==
    //                             null
    //                         ? const SizedBox.shrink()
    //                         : Container(
    //                             margin: EdgeInsets.only(top: 8.r),
    //                             decoration: BoxDecoration(
    //                                 color: AppStyle.redBg,
    //                                 borderRadius: BorderRadius.circular(30.r)),
    //                             padding: EdgeInsets.all(4.r),
    //                             child: Row(
    //                               children: [
    //                                 SvgPicture.asset(
    //                                     "assets/svgs/discount.svg"),
    //                                 8.horizontalSpace,
    //                                 Text(
    //                                   AppHelpers.numberFormat(
    //                                       number: (product
    //                                               .stocks?.first.totalPrice ??
    //                                           0)),
    //                                   style: AppStyle.interNoSemi(
    //                                       size: 12, color: AppStyle.red),
    //                                 )
    //                               ],
    //                             ),
    //                           ),
    //                     product.stocks?.first.bonus != null
    //                         ? Padding(
    //                             padding: const EdgeInsets.only(top: 5),
    //                             child: AnimationButtonEffect(
    //                               child: InkWell(
    //                                 onTap: () {
    //                                   AppHelpers.showCustomModalBottomSheet(
    //                                     paddingTop:
    //                                         MediaQuery.of(context).padding.top,
    //                                     context: context,
    //                                     modal: BonusScreen(
    //                                       bonus: product.stocks?.first.bonus,
    //                                     ),
    //                                     isDarkMode: false,
    //                                     isDrag: true,
    //                                     radius: 12,
    //                                   );
    //                                 },
    //                                 child: Container(
    //                                   width: 22.w,
    //                                   height: 22.h,
    //                                   margin: EdgeInsets.only(
    //                                       top: 8.r,
    //                                       left: 8.r,
    //                                       right: 4.r,
    //                                       bottom: 4.r),
    //                                   decoration: const BoxDecoration(
    //                                       shape: BoxShape.circle,
    //                                       color: AppStyle.blueBonus),
    //                                   child: Icon(
    //                                     FlutterRemix.gift_2_fill,
    //                                     size: 16.r,
    //                                     color: AppStyle.white,
    //                                   ),
    //                                 ),
    //                               ),
    //                             ),
    //                           )
    //                         : const SizedBox.shrink()
    //                   ],
    //                 ),
    //               ],
    //             ),
    //           ),
    //           const SizedBox(
    //             width: 5,
    //           ),
    //           Expanded(
    //             child: CustomNetworkImage(
    //                 url: product.img ?? "",
    //                 height: 100.h,
    //                 width: double.infinity,
    //                 radius: 0),
    //           ),
    //           const SizedBox(
    //             width: 35,
    //           )
    //         ],
    //       ),
    //       Positioned(
    //         top: 0,
    //         right: 0,
    //         child: GestureDetector(
    //           onTap: () {
    //             AppHelpers.showCustomModalBottomDragSheet(
    //               context: context,
    //               modal: (c) => ProductScreen(
    //                 cartId: '12',
    //                 data: product,
    //                 controller: c,
    //               ),
    //               isDarkMode: false,
    //               isDrag: true,
    //               radius: 16,
    //             );
    //           },
    //           child: Container(
    //             decoration: BoxDecoration(
    //                 shape: BoxShape.circle,
    //                 border:
    //                     Border.all(color: Colors.grey.shade400, width: .5)),
    //             padding: const EdgeInsets.all(2),
    //             child: const Icon(
    //               Icons.add,
    //               size: 25,
    //               color: AppStyle.brandGreen,
    //             ),
    //           ),
    //         ),
    //       )
    //     ],
    //   ),
    // );
    return Container(
      margin: EdgeInsets.all(4.r),
      decoration: BoxDecoration(
          color: AppStyle.white,
          borderRadius: BorderRadius.all(Radius.circular(10.r))),
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
                              paddingTop: MediaQuery.of(context).padding.top,
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
                                shape: BoxShape.circle,
                                color: AppStyle.blueBonus),
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
