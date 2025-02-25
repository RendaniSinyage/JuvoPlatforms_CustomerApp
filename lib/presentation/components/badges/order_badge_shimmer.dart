import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodyman/infrastructure/services/app_helpers.dart';
import 'package:foodyman/infrastructure/services/tr_keys.dart';
import 'package:foodyman/presentation/theme/theme.dart';

class OrderBadge extends StatelessWidget {
  final Color? imageColor;
  final Color? containerColor;
  final Color? textColor;

  const OrderBadge({
    super.key,
    this.imageColor,
    this.containerColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          //'assets/svgs/foodyman.svg', // Path to your updated SVG asset
          'assets/svgs/brand_logo_rounded.svg',
          height: 24.h, // Adjust height as needed using ScreenUtil
          width: 24.w, // Adjust width as needed using ScreenUtil
          colorFilter: imageColor != null   ? ColorFilter.mode(imageColor!, BlendMode.colorDodge)
              : const ColorFilter.mode(AppStyle.primary, BlendMode.colorDodge), // Use colorFilter to apply color to the SVG
        ),
        SizedBox(width: 5.w), // Adjust spacing as needed using ScreenUtil
        Container(
          height: 22.h, // Adjust height as needed using ScreenUtil
          decoration: BoxDecoration(
            color: containerColor ?? AppStyle.primary, // Use customizable color with default
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(10.0), // Adjust top-right radius as needed
              bottomRight: Radius.circular(10.0), // Adjust bottom-right radius as needed
            ), // Adjust the radius as needed
          ),
          padding: EdgeInsets.symmetric(horizontal: 5.w), // Adjust padding as needed using ScreenUtil
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppHelpers.getTranslation(TrKeys.orderNow), // Make sure AppHelpers is imported and accessible
                style: AppStyle.interNoSemi(
                  size: 12,
                  color: textColor ?? AppStyle.white, // Use customizable color with default
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
