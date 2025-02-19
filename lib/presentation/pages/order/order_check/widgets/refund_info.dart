import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodyman/infrastructure/models/data/refund_data.dart';
import 'package:foodyman/infrastructure/services/app_helpers.dart';
import 'package:foodyman/infrastructure/services/time_service.dart';
import 'package:foodyman/infrastructure/services/tr_keys.dart';
import 'package:foodyman/presentation/theme/app_style.dart';


class RefundInfoScreen extends StatelessWidget {
  final RefundModel? refundModel;

  const RefundInfoScreen({super.key, required this.refundModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppStyle.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.r),
              topRight: Radius.circular(10.r),
            ),
          ),
          padding: EdgeInsets.all(24.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    height: 36.h,
                    width: 36.w,
                    decoration: BoxDecoration(
                      color: (refundModel?.status == "pending"
                          ? AppStyle.primary
                          : AppStyle.bgGrey),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(8),
                      ),
                    ),
                    child: Center(
                      child: refundModel?.status == "pending"
                          ? Stack(
                              children: [
                                Center(
                                    child: SvgPicture.asset(
                                        "assets/svgs/orderTime.svg")),
                                Center(
                                  child: Text(
                                    "15",
                                    style: AppStyle.interNoSemi(
                                      size: 10,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Icon(
                        refundModel?.status == "accepted"
                                  ? Icons.done_all
                                  : Icons.cancel_outlined,
                              size: 16.r,
                            ),
                    ),
                  ),
                  8.horizontalSpace,
                  Text(
                    AppHelpers.getTranslation(TrKeys.reFound),
                    style: AppStyle.interNoSemi(
                      size: 16,
                      color: AppStyle.black,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    refundModel?.status ?? "",
                    style: AppStyle.interNormal(
                      size: 14,
                      color: AppStyle.black,
                    ),
                  ),
                ],
              ),
              8.verticalSpace,
              Row(
                children: [
                  Text(
                    "#${AppHelpers.getTranslation(TrKeys.id)}${refundModel?.id ?? ""}",
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
                    TimeService.dateFormatMDHm(refundModel?.createdAt),
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
                    AppHelpers.getTranslation(TrKeys.cause),
                    style: AppStyle.interRegular(
                      size: 14,
                      color: AppStyle.textGrey,
                    ),
                  ),
                  Text(
                    refundModel?.cause ?? "",
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
              16.verticalSpace,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppHelpers.getTranslation(TrKeys.answer),
                    style: AppStyle.interRegular(
                      size: 14,
                      color: AppStyle.textGrey,
                    ),
                  ),
                  Text(
                    refundModel?.answer ?? "",
                    style: AppStyle.interNoSemi(
                      size: 16,
                      color: AppStyle.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        16.verticalSpace,
      ],
    );
  }
}
