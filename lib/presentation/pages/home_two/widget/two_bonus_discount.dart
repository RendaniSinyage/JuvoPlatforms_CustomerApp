import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:riverpodtemp/infrastructure/models/data/bonus_data.dart';
import 'package:riverpodtemp/presentation/theme/app_style.dart';

class TwoBonusDiscountPopular extends StatelessWidget {
  final bool isPopular;
  final BonusModel? bonus;
  final bool isDiscount;
  final bool isSingleShop;

  const TwoBonusDiscountPopular(
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
                                shape: BoxShape.circle, color: AppStyle.blueBonus),
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
                                          margin: EdgeInsets.only(left: 8.r),
                                          width: 22.w,
                                          height: 22.h,
                                          decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: AppStyle.red),
                                          child: Icon(
                                            FlutterRemix.percent_fill,
                                            size: 16.r,
                                            color: AppStyle.white,
                                          ),
                                        )
                                      : bonus != null
                                          ? Container(
                                    margin: EdgeInsets.only(left: 8.r),
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
                                            )
                                          : isPopular
                                              ? Container(
                                    margin: EdgeInsets.only(left: 8.r),
                                                  width: 22.w,
                                                  height: 22.h,
                                                  decoration:
                                                      const BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color:
                                                              AppStyle.blueBonus),
                                                  child: Icon(
                                                    FlutterRemix
                                                        .flashlight_fill,
                                                    size: 16.r,
                                                    color: AppStyle.white,
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
