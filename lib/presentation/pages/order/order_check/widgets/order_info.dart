import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:riverpodtemp/application/order/order_provider.dart';
import 'package:riverpodtemp/infrastructure/services/app_helpers.dart';
import 'package:riverpodtemp/infrastructure/services/tr_keys.dart';
import 'package:riverpodtemp/presentation/theme/theme.dart';

class OrderInfo extends StatelessWidget {
  const OrderInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context,ref,child) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppHelpers.getTranslation(TrKeys.order),
                style: AppStyle.interNoSemi(
                  size: 16,
                  color: AppStyle.black,
                ),
              ),
              8.verticalSpace,
              Row(
                children: [
                  Text(
                    "#${AppHelpers.getTranslation(TrKeys.id)}${ref.read(orderProvider).orderData?.id ?? 0}",
                    style: AppStyle.interNormal(
                      size: 14,
                      color: AppStyle.textGrey,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 12.w),
                    width: 6.w,
                    height: 6.h,
                    decoration: const BoxDecoration(
                        color: AppStyle.textGrey, shape: BoxShape.circle),
                  ),
                  Text(
                    DateFormat("MMM dd, HH:mm").format(ref.read(orderProvider).orderData?.createdAt ?? DateTime.now()),
                    style: AppStyle.interNormal(
                      size: 14,
                      color: AppStyle.textGrey,
                    ),
                  ),
                ],
              ),
              16.verticalSpace,
              const Divider(
                color: AppStyle.textGrey,
              ),
              16.verticalSpace,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppHelpers.getTranslation(TrKeys.deliveryAddress),
                    style: AppStyle.interRegular(
                      size: 14,
                      color: AppStyle.textGrey,
                    ),
                  ),
                  Text(
                    ref.watch(orderProvider).orderData?.address?.address ?? "",
                    style: AppStyle.interNoSemi(
                      size: 16,
                      color: AppStyle.black,
                    ),
                  ),
                ],
              ),
              16.verticalSpace,
              const Divider(
                color: AppStyle.textGrey,
              ),
            ],
          ),
        );
      }
    );
  }
}
