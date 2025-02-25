import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:foodyman/infrastructure/services/app_helpers.dart';
import 'package:foodyman/infrastructure/services/tr_keys.dart';
import 'package:foodyman/presentation/theme/theme.dart';


class AdBadge extends StatelessWidget {
  const AdBadge({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 22.h, // Adjust height as needed using ScreenUtil
          color: AppStyle.red, // Adjust color as needed
          padding: EdgeInsets.symmetric(horizontal: 5.w), // Adjust padding as needed using ScreenUtil
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppHelpers.getTranslation(TrKeys.isAd), // Make sure AppHelpers is imported and accessible
                style: AppStyle.interNoSemi(
                  size: 12,
                  color: AppStyle.white,
                ),
              ),
             /* SizedBox(width: 2.w), // Adjust the width as needed using ScreenUtil
              Icon(
                FlutterRemix.advertisement_fill,
                color: AppStyle.white,
                size: 16.sp, // Adjust the icon size as needed using ScreenUtil
              ),*/
            ],
          ),
        ),
      ],
    );
  }
}
