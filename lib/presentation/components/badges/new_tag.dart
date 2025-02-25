import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:foodyman/infrastructure/services/app_helpers.dart';
import 'package:foodyman/infrastructure/services/tr_keys.dart';
import 'package:foodyman/presentation/theme/theme.dart';

class NewTag extends StatelessWidget {
  final double? top, left, right;
  const NewTag({super.key, this.top = 5, this.left = 3, this.right});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top, left: left, right: right,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 7),
        decoration: BoxDecoration(
         // borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
          color: AppStyle.starColor,
        ),
        child:  Text(
                AppHelpers.getTranslation(TrKeys.isAd), // Make sure AppHelpers is imported and accessible
                style: AppStyle.interNoSemi(
                  size: 12,
                  color: AppStyle.white,
                ),
              ), ),
    );
  }
}
