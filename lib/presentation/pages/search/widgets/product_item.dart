import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:riverpodtemp/infrastructure/models/data/product_data.dart';
import 'package:riverpodtemp/infrastructure/services/app_helpers.dart';
import 'package:riverpodtemp/presentation/components/custom_network_image.dart';
import 'package:riverpodtemp/presentation/theme/theme.dart';

import '../../product/product_page.dart';

class ProductItem extends StatelessWidget {
  final ProductData product;

  const ProductItem({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: InkWell(
        onTap: () {
          AppHelpers.showCustomModalBottomDragSheet(
            context: context,
            modal: (c) => ProductScreen(
              controller: c,
              data: product,
            ),
            isDarkMode: false,
            isDrag: true,
            radius: 16,
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: AppStyle.white,
            borderRadius: BorderRadius.all(Radius.circular(10.r)),
            boxShadow: [
              BoxShadow(
                color: AppStyle.white.withOpacity(0.04),
                spreadRadius: 0,
                blurRadius: 2,
                offset: const Offset(0, 2), // changes position of shadow
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(12.r),
            child: Row(
              children: [
                CustomNetworkImage(
                    url: product.img ?? "",
                    height: 84.r,
                    width: 84.r,
                    radius: 10.r),
                14.horizontalSpace,
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 200.h,
                            child: Text(
                              product.translation?.title ?? "",
                              style: AppStyle.interSemi(
                                size: 15,
                                color: AppStyle.black,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            product.translation?.description ?? "",
                            style: AppStyle.interNormal(
                              size: 12,
                              color: AppStyle.black,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppHelpers.numberFormat(
                              number: product.stocks?.first.totalPrice,
                            ),
                            style: AppStyle.interSemi(
                              size: 13,
                              color: AppStyle.black,
                            ),
                          ),
                          product.stocks?.first.bonus != null
                              ? Container(
                                  width: 22.w,
                                  height: 22.h,
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppStyle.blueBonus),
                                  child: Icon(
                                    FlutterRemix.gift_2_fill,
                                    size: 16.r,
                                    color: AppStyle.white,
                                  ),
                                )
                              : const SizedBox.shrink()
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
