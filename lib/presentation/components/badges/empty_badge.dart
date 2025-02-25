import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodyman/infrastructure/services/app_helpers.dart';
import 'package:foodyman/infrastructure/services/tr_keys.dart';
import 'package:foodyman/presentation/theme/theme.dart';
import 'package:lottie/lottie.dart';

class EmptyBadge extends StatelessWidget {
  final String imagePath;
  final String titleText;
  final String subtitleText;
  final String? linkText;
  final GestureTapCallback? onLinkTap;

  EmptyBadge({
    Key? key,
    this.imagePath = 'assets/lottie/notification_empty.json',
    String? titleText,
    String? subtitleText,
    this.linkText,
    this.onLinkTap,
  }) :
        titleText = titleText ?? AppHelpers.getTranslation(TrKeys.nothingFound),
        subtitleText = subtitleText ?? AppHelpers.getTranslation(TrKeys.trySearchingAgain),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //32.verticalSpace,
        Lottie.asset(
          imagePath,
          height: 200,
        ),
        Text(
          titleText,
          style: AppStyle.interSemi(size: 18.sp),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.w),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: subtitleText,
              style: AppStyle.interRegular(size: 14.sp),
              children: linkText != null && onLinkTap != null
                  ? [
                TextSpan(
                  text: ' $linkText',
                  style: const TextStyle(
                    color: AppStyle.primary,
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()..onTap = onLinkTap,
                ),
              ]
                  : [],
            ),
          ),
        ),
      ],
    );
  }
}
