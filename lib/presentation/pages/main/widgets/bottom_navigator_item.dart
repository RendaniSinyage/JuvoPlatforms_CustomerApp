import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodyman/presentation/theme/theme.dart';
import 'package:foodyman/app_constants.dart'; // Import AppConstants

class BottomNavigatorItem extends StatelessWidget {
  final VoidCallback selectItem;
  final int index;
  final int currentIndex;
  final bool isScrolling;
  final IconData selectIcon;
  final IconData unSelectIcon;
  final String label;

  const BottomNavigatorItem(
      {super.key,
        required this.selectItem,
        required this.index,
        required this.selectIcon,
        required this.unSelectIcon,
        required this.currentIndex,
        required this.isScrolling,
        required this.label});

  @override
  Widget build(BuildContext context) {
    // Check if fixed navigation is enabled
    final bool isFixed = AppConstants.fixed;

    // If fixed is true, ignore the isScrolling value
    final bool shouldHide = isFixed ? false : isScrolling;

    return GestureDetector(
      onTap: selectItem,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        color: AppStyle.transparent,
        height: shouldHide ? 0.h : 45.h,
        width: shouldHide ? 0.w : 60.w,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    index == currentIndex
                        ? Icon(selectIcon,
                        size: shouldHide ? 0.r : 24.r,
                        color: AppStyle.white)
                        : Icon(unSelectIcon,
                        size: shouldHide ? 0.r : 24.r,
                        color: AppStyle.white),
                    if (index == currentIndex)
                      Text(
                        label,
                        style: TextStyle(
                          color: AppStyle.white,
                          fontSize: shouldHide ? 0.sp : 9.sp,
                        ),
                      ),
                  ],
                ),
              ),
              AnimatedContainer(
                height: shouldHide ? 0.h : 4.h,
                width: shouldHide ? 0.w : 24.w,
                decoration: BoxDecoration(
                  color: index == currentIndex
                      ? AppStyle.primary
                      : AppStyle.transparent,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(100.r),
                    topRight: Radius.circular(100.r),
                  ),
                ),
                duration: const Duration(milliseconds: 300),
              ),
            ],
          ),
        ),
      ),
    );
  }
}