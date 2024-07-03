import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:riverpodtemp/presentation/theme/theme.dart';

class TabBarItemThree extends StatelessWidget {
  final bool isShopTabBar;
  final String title;
  final int index;
  final int? currentIndex;
  final VoidCallback onTap;

  const TabBarItemThree(
      {super.key,
      required this.title,
      required this.index,
      this.isShopTabBar = false,
      this.currentIndex,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        decoration: BoxDecoration(
          color: isShopTabBar
              ? (currentIndex == index ? AppStyle.brandGreen : AppStyle.bgGrey)
              : AppStyle.bgGrey,
          borderRadius: BorderRadius.all(Radius.circular(10.r)),
          boxShadow: [
            BoxShadow(
              color: AppStyle.bgGrey.withOpacity(0.07),
              spreadRadius: 0,
              blurRadius: 2,
              offset: const Offset(0, 1), // changes position of shadow
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(horizontal: 18.w),
        margin: EdgeInsets.only(right: 9.w),
        child: Center(
          child: Text(
            title,
            style: AppStyle.interNormal(
              size: 13,
              color: AppStyle.black,
            ),
          ),
        ),
      ),
    );
  }
}
