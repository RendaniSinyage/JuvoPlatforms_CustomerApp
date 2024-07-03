import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:riverpodtemp/presentation/theme/app_style.dart';

class CategoryTwoShimmer extends StatelessWidget {
  const CategoryTwoShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120.h,
      child: AnimationLimiter(
        child: ListView.builder(
          padding: EdgeInsets.only(left: 16.r, bottom: 16.r, top: 8.r),
          shrinkWrap: true,
          
          scrollDirection: Axis.horizontal,
          itemCount: 6,
          itemBuilder: (context, index) {
            return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 375),
              child: SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(
                  child: Container(
                    width: 60.w,
                    height: 100.h,
                    margin: REdgeInsets.only(
                      left: 6,
                      right: 4,
                    ),
                    decoration: BoxDecoration(
                        color: AppStyle.shimmerBase,
                        borderRadius: BorderRadius.all(Radius.circular(36.r)),
                        boxShadow: const [
                          BoxShadow(
                            color: AppStyle.shadow,
                            blurRadius: 15,
                            offset: Offset(0, 4),
                            spreadRadius: 0,
                          )
                        ]),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
