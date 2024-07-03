import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:riverpodtemp/infrastructure/services/app_constants.dart';
import 'package:riverpodtemp/infrastructure/services/app_helpers.dart';
import 'package:riverpodtemp/presentation/theme/theme.dart';

import 'order_status_item.dart';

class OrderStatusScreen extends StatelessWidget {
  final OrderStatus status;
  final bool parcel;

  const OrderStatusScreen({super.key, required this.status, this.parcel = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 16.h),
      decoration: BoxDecoration(
          color: AppStyle.bgGrey,
          borderRadius: BorderRadius.all(Radius.circular(10.r))),
      padding: EdgeInsets.all(14.r),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Text(
                AppHelpers.getTranslation(
                    AppHelpers.getOrderStatusText(status)),
                style: AppStyle.interNormal(
                  size: 13,
                  color: AppStyle.black,
                ),
              ),
            ],
          ),
          status == OrderStatus.canceled
              ? Row(
                  children: [
                    OrderStatusItem(
                      icon: Icon(
                        parcel ? FlutterRemix.survey_fill : Icons.done_all,
                        size: 16.r,
                      ),
                      bgColor: AppStyle.red,
                      isActive: true,
                      isProgress: false,
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      height: 6.h,
                      width: 12.w,
                      decoration: const BoxDecoration(
                        color: AppStyle.red,
                      ),
                    ),
                    OrderStatusItem(
                      icon: Icon(
                        parcel ? Icons.done_all : Icons.restaurant_rounded,
                        size: 16.r,
                        color: AppStyle.black,
                      ),
                      bgColor: AppStyle.red,
                      isActive: true,
                      isProgress: false,
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      height: 6.h,
                      width: 12.w,
                      decoration: const BoxDecoration(
                        color: AppStyle.red,
                      ),
                    ),
                    OrderStatusItem(
                      icon: parcel
                          ? const Icon(FlutterRemix.truck_fill)
                          : SvgPicture.asset(
                              "assets/svgs/delivery2.svg",
                              width: 20.w,
                            ),
                      bgColor: AppStyle.red,
                      isActive: true,
                      isProgress: false,
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      height: 6.h,
                      width: 12.w,
                      decoration: const BoxDecoration(
                        color: AppStyle.red,
                      ),
                    ),
                    OrderStatusItem(
                      icon: Icon(
                        Icons.flag,
                        size: 16.r,
                      ),
                      bgColor: AppStyle.red,
                      isActive: true,
                      isProgress: false,
                    ),
                  ],
                )
              : status == OrderStatus.delivered
                  ? Row(
                      children: [
                        OrderStatusItem(
                          icon: Icon(
                            parcel
                                ? FlutterRemix.survey_fill
                                : Icons.done_all,
                            size: 16.r,
                          ),
                          bgColor: AppStyle.brandGreen,
                          isActive: true,
                          isProgress: false,
                        ),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          height: 6.h,
                          width: 12.w,
                          decoration: const BoxDecoration(
                            color: AppStyle.brandGreen,
                          ),
                        ),
                        OrderStatusItem(
                          icon: Icon(
                            parcel
                                ? Icons.done_all
                                : Icons.restaurant_rounded,
                            size: 16.r,
                            color: AppStyle.black,
                          ),
                          bgColor: AppStyle.brandGreen,
                          isActive: true,
                          isProgress: false,
                        ),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          height: 6.h,
                          width: 12.w,
                          decoration: const BoxDecoration(
                            color: AppStyle.brandGreen,
                          ),
                        ),
                        OrderStatusItem(
                          icon: parcel
                              ? const Icon(FlutterRemix.truck_fill)
                              : SvgPicture.asset(
                                  "assets/svgs/delivery2.svg",
                                  width: 20.w,
                                ),
                          bgColor: AppStyle.brandGreen,
                          isActive: true,
                          isProgress: false,
                        ),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          height: 6.h,
                          width: 12.w,
                          decoration: const BoxDecoration(
                            color: AppStyle.brandGreen,
                          ),
                        ),
                        OrderStatusItem(
                          icon: Icon(
                            Icons.flag,
                            size: 16.r,
                          ),
                          bgColor: AppStyle.brandGreen,
                          isActive: true,
                          isProgress: false,
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        OrderStatusItem(
                          icon: Icon(
                            parcel
                                ? FlutterRemix.survey_fill
                                : Icons.done_all,
                            size: 16.r,
                          ),
                          isActive: status != OrderStatus.open,
                          isProgress: status == OrderStatus.open,
                        ),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          height: 6.h,
                          width: 12.w,
                          decoration: BoxDecoration(
                            color: status != OrderStatus.open
                                ? AppStyle.brandGreen
                                : AppStyle.white,
                          ),
                        ),
                        OrderStatusItem(
                          icon: Icon(
                            parcel
                                ? Icons.done_all
                                : Icons.restaurant_rounded,
                            size: 16.r,
                            color: AppStyle.black,
                          ),
                          isActive: status == OrderStatus.ready ||
                              status == OrderStatus.onWay,
                          isProgress: status == OrderStatus.accepted,
                        ),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          height: 6.h,
                          width: 12.w,
                          decoration: BoxDecoration(
                            color: status == OrderStatus.ready ||
                                    status == OrderStatus.onWay
                                ? AppStyle.brandGreen
                                : AppStyle.white,
                          ),
                        ),
                        OrderStatusItem(
                          icon: parcel
                              ? const Icon(FlutterRemix.truck_fill)
                              : SvgPicture.asset(
                                  status == OrderStatus.onWay
                                      ? "assets/svgs/delivery2.svg"
                                      : "assets/svgs/delivery.svg",
                                  width: 20.w,
                                ),
                          isActive: status == OrderStatus.onWay,
                          isProgress: status == OrderStatus.ready ||
                              status == OrderStatus.delivered,
                        ),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          height: 6.h,
                          width: 12.w,
                          decoration: const BoxDecoration(
                            color: AppStyle.white,
                          ),
                        ),
                        OrderStatusItem(
                          icon: Icon(
                            Icons.flag,
                            size: 16.r,
                          ),
                          isActive: false,
                          isProgress: false,
                        ),
                      ],
                    )
        ],
      ),
    );
  }
}
