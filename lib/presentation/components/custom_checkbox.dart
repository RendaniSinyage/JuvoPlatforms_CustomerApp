import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:riverpodtemp/presentation/theme/app_style.dart';

class CustomCheckbox extends StatelessWidget {
  final bool isActive;
  final VoidCallback onTap;
  const CustomCheckbox({super.key, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        width: 24.r,
        height: 24.r,
        decoration: BoxDecoration(
          color: isActive ? AppStyle.brandGreen : AppStyle.outlineButtonBorder,
          borderRadius: BorderRadius.circular(8.r)
        ),
        duration: const Duration(milliseconds: 500),
        child: isActive ?  Icon(FlutterRemix.check_fill,color: AppStyle.black,size: 18.r,) : const SizedBox.shrink(),
      ),
    );
  }
}
