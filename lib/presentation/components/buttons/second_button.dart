import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'animation_button_effect2.dart';
import '../../theme/theme.dart';

class SecondButton extends StatelessWidget {
  final String title;
  final double radius;
  final Color bgColor;
  final Color titleColor;
  final double titleSize;
  final VoidCallback onTap;

  const SecondButton(
      {Key? key,
      required this.title,
      this.radius = 36,
      required this.bgColor,
      required this.titleColor,
      required this.onTap,
      this.titleSize = 14})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonEffectAnimation(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius.r),
          color: bgColor,
        ),
        padding: EdgeInsets.symmetric(vertical: 10.r, horizontal: 18.r),
        child: Text(
          title,
          style: AppStyle.interNoSemi(color: titleColor, size: titleSize),
        ),
      ),
    );
  }
}
