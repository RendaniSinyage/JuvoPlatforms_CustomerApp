import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:riverpodtemp/presentation/theme/theme.dart';

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
    return GestureDetector(
      onTap: selectItem,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        color: AppStyle.transparent,
        height: isScrolling ? 0.h : 45.h,
        width: isScrolling ? 0.w : 60.w,
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
                        size: isScrolling ? 0.r : 24.r,
                        color: AppStyle.white)
                        : Icon(unSelectIcon,
                        size: isScrolling ? 0.r : 24.r,
                        color: AppStyle.white),
                    if (index == currentIndex)
                      Text(
                        label,
                        style: TextStyle(
                          color: AppStyle.white,
                          fontSize: isScrolling ? 0.sp : 9.sp,
                        ),
                      ),
                  ],
                ),
              ),
              AnimatedContainer(
                height: isScrolling ? 0.h : 4.h,
                width: isScrolling ? 0.w : 24.w,
                decoration: BoxDecoration(
                  color: index == currentIndex
                      ? AppStyle.brandGreen
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