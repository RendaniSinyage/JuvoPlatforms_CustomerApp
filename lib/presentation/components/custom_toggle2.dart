import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodyman/infrastructure/services/app_helpers.dart';
import 'package:foodyman/infrastructure/services/tr_keys.dart';
import 'package:foodyman/presentation/theme/app_style.dart';

class CustomToggle extends StatefulWidget {
  final bool isOnline;
  final String? onTitle;
  final String? offTitle;
  final ValueChanged<bool> onChange;
  final Color backgroundColor;
  final Color newBoxColor;
  final Color socialButtonColor;
  final Color textColor;

  const CustomToggle({
    super.key,
    required this.isOnline,
    required this.onChange,
    required this.backgroundColor,
    required this.newBoxColor,
    required this.socialButtonColor,
    required this.textColor,
    this.onTitle,
    this.offTitle,
  });

  @override
  State<CustomToggle> createState() => _CustomToggleState();
}

class _CustomToggleState extends State<CustomToggle> {
  late ValueNotifier<bool> controller;

  @override
  void initState() {
    controller = ValueNotifier<bool>(widget.isOnline);
    controller.addListener(() {
      widget.onChange(controller.value);
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AdvancedSwitch(
      controller: controller,
      activeColor: widget.backgroundColor,
      inactiveColor: widget.backgroundColor,
      borderRadius: BorderRadius.circular(100.r),
      width: 76.r,
      height: 34.r,
      enabled: true,
      disabledOpacity: 0.5,
      thumb: Container(
        margin: EdgeInsets.all(4.r),
        padding: EdgeInsets.symmetric(
          vertical: 6.h,
        ),
        decoration: BoxDecoration(
          color: widget.newBoxColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: widget.socialButtonColor.withOpacity(0.4),
              spreadRadius: 0,
              blurRadius: 2,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: double.infinity,
              width: 3.r,
              color: widget.backgroundColor,
            ),
            2.horizontalSpace,
            Container(
              height: double.infinity,
              width: 3.r,
              color: widget.backgroundColor,
            )
          ],
        ),
      ),
      activeChild: Padding(
        padding: EdgeInsets.only(left: 4.r),
        child: Text(
          widget.onTitle ?? AppHelpers.getTranslation(TrKeys.light),
          style: AppStyle.interNormal(
            size: 14,
            letterSpacing: -0.3,
            color: widget.textColor,
          ),
        ),
      ),
      inactiveChild: Padding(
        padding: EdgeInsets.only(right: 4.r),
        child: Text(
          widget.offTitle ?? AppHelpers.getTranslation(TrKeys.dark),
          style: AppStyle.interNormal(
            size: 14,
            letterSpacing: -0.3,
            color: widget.textColor,
          ),
        ),
      ),
    );
  }
}