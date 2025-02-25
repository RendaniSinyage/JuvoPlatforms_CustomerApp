import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodyman/infrastructure/services/tr_keys.dart';
import 'package:foodyman/presentation/theme/theme.dart';

import '../../../infrastructure/services/app_helpers.dart';

class AdBadge extends StatelessWidget {
  const AdBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 4.h,
        horizontal: 12.w,
      ),
      decoration: BoxDecoration(
        color: AppStyle.bottomNavigationBarColor.withOpacity(0.6),
        borderRadius: BorderRadius.all(Radius.circular(100.r)),
      ),
      child: Text(
        AppHelpers.getTranslation(TrKeys.isAd),
        style: AppStyle.interNormal(
          size: 12,
          letterSpacing: -0.3,
          color: AppStyle.white,
        ),
      ),
    );
  }
}