import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodyman/presentation/components/buttons/animation_button_effect2.dart';
import 'package:foodyman/presentation/components/custom_toggle2.dart';
import 'package:foodyman/presentation/theme/theme.dart'; // Import the AppStyle class

class ButtonItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? selectValue;
  final String? onTitle;
  final String? offTitle;
  final VoidCallback onTap;
  final bool isLtr;
  final bool? value;

  const ButtonItem({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.selectValue,
    this.value,
    this.onTitle,
    this.offTitle,
    required this.isLtr
  });

  @override
  Widget build(BuildContext context) {
    return ButtonEffectAnimation(
      disabled: value == null,
      onTap: value == null ? onTap : null,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.r, vertical: 4.r),
        decoration: BoxDecoration(
          color: AppStyle.white, // Use the imported AppStyle class
          borderRadius: BorderRadius.circular(16.r),
        ),
        padding: EdgeInsets.all(20.r),
        child: Row(
          children: [
            Icon(
              icon,
              color: AppStyle.black, // Use the imported AppStyle class
            ),
            SizedBox(width: 12.r), // Replace 12.horizontalSpace with SizedBox
            Text(
              title,
              style: AppStyle.interNormal(color: AppStyle.black, size: 16), // Use the imported AppStyle class
            ),
            const Spacer(),
            Text(
              selectValue ?? "",
              style: AppStyle.interNormal(color: AppStyle.black, size: 12), // Use the imported AppStyle class
            ),
            if (value == null)
              Icon( isLtr  ?  FlutterRemix.arrow_right_line : FlutterRemix.arrow_left_line, // Use the correct IconData from flutter_remix
                color: AppStyle.black, // Use the imported AppStyle class
              ),
            if (value != null)
              CustomToggle(
                offTitle: offTitle,
                onTitle: onTitle,
                isOnline: value ?? false,
                onChange: (s) {
                  onTap();
                },
                backgroundColor: AppStyle.red, // Provide a color for backgroundColor
                newBoxColor: AppStyle.white, // Provide a color for newBoxColor
                socialButtonColor: AppStyle.blue, // Provide a color for socialButtonColor
                textColor: AppStyle.black, // Provide a color for textColor
              )
          ],
        ),
      ),
    );
  }
}