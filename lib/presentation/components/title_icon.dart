import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodyman/infrastructure/services/local_storage.dart';

import '../theme/theme.dart';

// ignore: must_be_immutable
class TitleAndIcon extends StatelessWidget {
  final String? title;
  final dynamic secondTitle; // Changed to dynamic to support both String and IconData
  final double titleSize;
  final String? rightTitle;
  final bool isIcon;
  final Color titleColor;
  final Color secondTitleColor;
  final Color rightTitleColor;
  final double paddingHorizontalSize;
  final Color iconColor;
  final Color containerColor;
  final Color borderColor;
  VoidCallback? onRightTap;

  TitleAndIcon({
    super.key,
    this.isIcon = false,
    this.title,
    this.secondTitle,
    this.rightTitle,
    this.titleColor = AppStyle.black,
    this.secondTitleColor = AppStyle.black,
    this.rightTitleColor = AppStyle.black,
    this.onRightTap,
    this.titleSize = 20,
    this.paddingHorizontalSize = 16,
    this.iconColor = AppStyle.black,
    this.containerColor = AppStyle.transparent,
    this.borderColor = AppStyle.textGrey,
  });

  @override
  Widget build(BuildContext context) {
    final bool isLtr = LocalStorage.getLangLtr();
    return Directionality(
      textDirection: isLtr ? TextDirection.ltr : TextDirection.rtl,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: paddingHorizontalSize.r),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (title != null && title!.isNotEmpty)
              Expanded(
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: title,
                        style: AppStyle.interNoSemi(
                          size: titleSize.sp,
                          color: titleColor,
                        ),
                      ),
                      if (secondTitle != null)
                        WidgetSpan(
                          child: secondTitle is String
                              ? Text(
                            ' $secondTitle',
                            style: AppStyle.interBold(
                              size: titleSize.sp,
                              color: secondTitleColor,
                            ),
                          )
                              : secondTitle is IconData
                              ? Padding(
                            padding: EdgeInsets.only(left: 4.w),
                            child: Icon(
                              secondTitle,
                              color: secondTitleColor,
                              size: titleSize.sp,
                            ),
                          )
                              : const SizedBox.shrink(),
                        ),
                    ],
                  ),
                ),
              ),
            if (rightTitle != null || isIcon)
              GestureDetector(
                onTap: onRightTap ?? () {},
                child: Container(
                  padding: REdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: ShapeDecoration(
                    color: containerColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40.r),
                      side: BorderSide(color: borderColor, width: 1.w),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (rightTitle != null && rightTitle!.isNotEmpty)
                        Text(
                          rightTitle!,
                          style: AppStyle.interNormal(
                            size: 14,
                            color: rightTitleColor,
                          ),
                        ),
                      if (isIcon && rightTitle != null && rightTitle!.isNotEmpty)
                        SizedBox(width: 5.w),
                      if (isIcon)
                        Icon(
                          isLtr ? Icons.arrow_forward : Icons.arrow_back,
                          color: iconColor,
                          size: 20.r,
                        ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}