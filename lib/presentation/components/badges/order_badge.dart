import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:riverpodtemp/infrastructure/services/app_helpers.dart';
import 'package:riverpodtemp/infrastructure/services/tr_keys.dart';
import 'package:riverpodtemp/presentation/theme/theme.dart';

class OrderBadge extends StatelessWidget {
  // final Color? imageColor;
  final Color? containerColor;
  final Color? textColor;

  const OrderBadge({
    Key? key, // Add key parameter
    // this.imageColor,
    this.containerColor,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppStyle.white,//.withOpacity(0.9), // Shadow color
            spreadRadius: 2, // Spread radius
            blurRadius: 7, // Blur radius
            offset: Offset(0, 3), // Offset in x and y directions
          ),
        ],
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            //'assets/svgs/foodyman.svg', // Path to your updated SVG asset
            'assets/svgs/brand_logo_rounded.svg',
            height: 22.h, // Adjust height as needed using ScreenUtil
            width: 22.w, // Adjust width as needed using ScreenUtil
            //colorFilter: imageColor != null   ? ColorFilter.mode(imageColor!, BlendMode.color)
            //      : const ColorFilter.mode(AppStyle.brandGreen, BlendMode.color), // Use colorFilter to apply color to the SVG
          ),
          SizedBox(width: 5.w), // Adjust spacing as needed using ScreenUtil
          Container(
            height: 22.h, // Adjust height as needed using ScreenUtil
            decoration: BoxDecoration(
              color: containerColor ?? AppStyle.brandGreen, // Use customizable color with default
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
      ),
    );
  }
}
