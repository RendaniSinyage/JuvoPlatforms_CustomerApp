import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../infrastructure/services/app_helpers.dart';
import '../../infrastructure/services/tr_keys.dart';
import '../theme/app_style.dart';
import 'buttons/animation_button_effect2.dart';

class TitleWidget extends StatelessWidget {
  final String title;
  final String? subTitle;
  final VoidCallback? onTap;
  final Color titleColor;
  final bool isSale;

  const TitleWidget(
      {Key? key,
        required this.title,
        this.subTitle,
        this.onTap,
        required this.titleColor,
        this.isSale = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 16.r),
          child: Text(
            title,
            style: AppStyle.interNoSemi(
                color: titleColor, size: 22),
          ),
        ),
        if (isSale && AppHelpers.getType() != 3)
          Container(
            margin: EdgeInsets.only(left: 8.r),
            padding: EdgeInsets.symmetric(vertical: 4.r, horizontal: 8.r),
            decoration: BoxDecoration(
                color: AppStyle.red,
                borderRadius: BorderRadius.circular(100.r)),
            child: Row(
              children: [
                Icon(
                  FlutterRemix.percent_fill,
                  color: AppStyle.white,
                  size: 14.r,
                ),
                4.horizontalSpace,
                Text(
                  AppHelpers.getTranslation(TrKeys.sale.toUpperCase()),
                  style: AppStyle.interNoSemi(
                      color: AppStyle.white, size: 10),
                )
              ],
            ),
          ),
        const Spacer(),
        if (subTitle != null)
          ButtonEffectAnimation(
            onTap: () {
              onTap?.call();
            },
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 4.r, horizontal: 16.r),
              child: Text(
                subTitle ?? "",
                style: AppStyle.interNormal(
                    color: AppStyle.red, size: 14),
              ),
            ),
          ),
      ],
    );
  }
}
