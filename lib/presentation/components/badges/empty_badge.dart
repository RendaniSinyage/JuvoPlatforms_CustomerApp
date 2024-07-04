import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:riverpodtemp/infrastructure/services/app_helpers.dart';
import 'package:riverpodtemp/infrastructure/services/tr_keys.dart';
import 'package:riverpodtemp/presentation/theme/theme.dart';
import 'package:lottie/lottie.dart';

class EmptyBadge extends StatelessWidget {

  const EmptyBadge({
    super.key, // Add key parameter
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        32.verticalSpace,
        Lottie.asset(
          'assets/lottie/notification_empty.json',
          //  width: 200,
          height: 250,
          // Optionally, you can set other properties such as width, height, etc.
        ),
        Text(
          AppHelpers.getTranslation(TrKeys.nothingFound),
          style: AppStyle.interSemi(size: 18.sp),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.w),
          child: Text(
            AppHelpers.getTranslation(TrKeys.trySearchingAgain),
            style: AppStyle.interRegular(size: 14.sp),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}