import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:riverpodtemp/presentation/theme/app_style.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CategoryShimmer extends StatelessWidget {
  const CategoryShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.h,
      margin: EdgeInsets.only(bottom: 26.h),
      child: AnimationLimiter(
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: 5,
          itemBuilder: (context, index) {
            return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 375),
              child: SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(
                  child: Container(
                    width: 84.w,
                    height: 84.h,
                    margin: EdgeInsets.only(left: 8.w),
                    decoration: BoxDecoration(
                      color: AppStyle.shimmerBase,
                      borderRadius: BorderRadius.all(Radius.circular(100.r)),
                    ),
                  /*  child: SvgPicture.asset(
                      'assets/svgs/brand_logo_rounded.svg',
                      height: 24.h,
                      width: 24.w,
                      colorFilter: const ColorFilter.mode(AppStyle.brandGreen, BlendMode.colorDodge,
                    ),
                  ), */
                ),
              ),
            ));
          },
        ),
      ),
    );
  }
}