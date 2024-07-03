import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:riverpodtemp/infrastructure/models/data/bonus_data.dart';
import 'package:riverpodtemp/infrastructure/services/app_helpers.dart';

import '../../infrastructure/services/tr_keys.dart';
import '../theme/app_style.dart';

class BonusDiscountPopular extends StatelessWidget {
  final bool isPopular;
  final BonusModel? bonus;
  final bool isDiscount;
  final bool isSingleShop;

  const BonusDiscountPopular(
      {super.key,
      required this.isPopular,
      required this.bonus,
      required this.isDiscount,
      this.isSingleShop = false});

  @override
  Widget build(BuildContext context) {

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        isDiscount && bonus != null && !isPopular
            ? Row(
                children: [
                  Container(
                    width: 22.w,
                    height: 22.h,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: AppStyle.red),
                    child: Icon(
                      FlutterRemix.percent_fill,
                      size: 16.r,
                      color: AppStyle.white,
                    ),
                  ),
                  8.horizontalSpace,
                  Container(
                    width: 22.w,
                    height: 22.h,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: AppStyle.brandGreen),
                    child: Icon(
                      FlutterRemix.gift_2_fill,
                      size: 16.r,
                      color: AppStyle.black,
                    ),
                  ),
                ],
              )
            : isDiscount && isPopular && bonus == null
            ? Row(
                    children: [
                      Container(
                        width: 22.w,
                        height: 22.h,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: AppStyle.red),
                        child: Icon(
                          FlutterRemix.percent_fill,
                          size: 16.r,
                          color: AppStyle.white,
                        ),
                      ),
                      8.horizontalSpace,
                      Container(
                        width: 22.w,
                        height: 22.h,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: AppStyle.blueBonus),
                        child: Icon(
                          FlutterRemix.flashlight_fill,
                          size: 16.r,
                          color: AppStyle.white,
                        ),
                      ),
                    ],
                  )
                : isDiscount && isPopular && bonus != null
                    ? Row(
                        children: [
                          Container(
                            width: 22.w,
                            height: 22.h,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle, color: AppStyle.red),
                            child: Icon(
                              FlutterRemix.percent_fill,
                              size: 16.r,
                              color: AppStyle.white,
                            ),
                          ),
                          8.horizontalSpace,
                          Container(
                            width: 22.w,
                            height: 22.h,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppStyle.blueBonus),
                            child: Icon(
                              FlutterRemix.flashlight_fill,
                              size: 16.r,
                              color: AppStyle.white,
                            ),
                          ),
                          8.horizontalSpace,
                          Container(
                            width: 22.w,
                            height: 22.h,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle, color: AppStyle.brandGreen),
                            child: Icon(
                              FlutterRemix.gift_2_fill,
                              size: 16.r,
                              color: AppStyle.black,
                            ),
                          ),
                        ],
                      )
                    : isPopular && bonus != null && !isDiscount
                        ? Row(
                            children: [
                              Container(
                                width: 22.w,
                                height: 22.h,
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppStyle.brandGreen),
                                child: Icon(
                                  FlutterRemix.gift_2_fill,
                                  size: 16.r,
                                  color: AppStyle.black,
                                ),
                              ),
                              8.horizontalSpace,
                              Container(
                                width: 22.w,
                                height: 22.h,
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppStyle.blueBonus),
                                child: Icon(
                                  FlutterRemix.flashlight_fill,
                                  size: 16.r,
                                  color: AppStyle.white,
                                ),
                              ),
                            ],
                          )
                        : isSingleShop
                            ? singleShop()
                            : Row(
                                children: [
                                  isDiscount
                                      ? Container(
                                          decoration: BoxDecoration(
                                              color: AppStyle.red,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(100.r))),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 12.w,
                                                vertical: 6.h),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  FlutterRemix.percent_fill,
                                                  size: 14.r,
                                                  color: AppStyle.white,
                                                ),
                                                4.horizontalSpace,
                                                Text(
                                                  AppHelpers.getTranslation(
                                                          TrKeys.discount)
                                                      .toUpperCase(),
                                                  style: AppStyle.interNoSemi(
                                                    size: 10.sp,
                                                    color: AppStyle.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      : bonus != null
                                          ? Container(
                                              decoration: BoxDecoration(
                                                  color: AppStyle.brandGreen,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              100.r))),
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 12.w,
                                                    vertical: 6.h),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      FlutterRemix.gift_2_fill,
                                                      size: 14.r,
                                                      color: AppStyle.black,
                                                    ),
                                                    4.horizontalSpace,
                                                    Text(
                                                      AppHelpers.getTranslation(
                                                              TrKeys.bonus)
                                                          .toUpperCase(),
                                                      style: AppStyle.interNoSemi(
                                                        size: 10.sp,
                                                        color: AppStyle.black,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          : isPopular
                                              ? Container(
                                                  decoration: BoxDecoration(
                                                      color: AppStyle.blueBonus,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  100.r))),
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 12.w,
                                                            vertical: 6.h),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                          FlutterRemix
                                                              .flashlight_fill,
                                                          size: 14.r,
                                                          color: AppStyle.white,
                                                        ),
                                                        4.horizontalSpace,
                                                        Text(
                                                          AppHelpers.getTranslation(
                                                                  TrKeys
                                                                      .popular)
                                                              .toUpperCase(),
                                                          style:
                                                              AppStyle.interNoSemi(
                                                            size: 10,
                                                            color: AppStyle.white,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              : const SizedBox.shrink(),
                                ],
                              )
      ],
    );
  }

  Widget singleShop() {
    return Row(
      children: [
        isDiscount
            ? Container(
                width: 22.w,
                height: 22.h,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: AppStyle.red),
                child: Icon(
                  FlutterRemix.percent_fill,
                  size: 16.r,
                  color: AppStyle.white,
                ),
              )
            : bonus != null
                ? Container(
                    width: 22.w,
                    height: 22.h,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: AppStyle.brandGreen),
                    child: Icon(
                      FlutterRemix.gift_2_fill,
                      size: 16.r,
                      color: AppStyle.black,
                    ),
                  )
                : isPopular
                    ? Container(
                        width: 22.w,
                        height: 22.h,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: AppStyle.blueBonus),
                        child: Icon(
                          FlutterRemix.flashlight_fill,
                          size: 16.r,
                          color: AppStyle.white,
                        ),
                      )
                    : isDiscount && isPopular && bonus != null
                        ? Row(
                            children: [
                              Container(
                                width: 22.w,
                                height: 22.h,
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle, color: AppStyle.red),
                                child: Icon(
                                  FlutterRemix.percent_fill,
                                  size: 16.r,
                                  color: AppStyle.white,
                                ),
                              ),
                              8.horizontalSpace,
                              Container(
                                width: 22.w,
                                height: 22.h,
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppStyle.blueBonus),
                                child: Icon(
                                  FlutterRemix.flashlight_fill,
                                  size: 16.r,
                                  color: AppStyle.white,
                                ),
                              ),
                              8.horizontalSpace,
                              Container(
                                width: 22.w,
                                height: 22.h,
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppStyle.brandGreen),
                                child: Icon(
                                  FlutterRemix.gift_2_fill,
                                  size: 16.r,
                                  color: AppStyle.black,
                                ),
                              ),
                            ],
                          )
                        : const SizedBox.shrink(),
      ],
    );
  }
}
