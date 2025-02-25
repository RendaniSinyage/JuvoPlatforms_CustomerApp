import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:foodyman/presentation/components/badges/order_badge_shimmer.dart';
import '../../../../theme/theme.dart';

class BannerShimmer extends StatelessWidget {
  const BannerShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120.h,
      margin: EdgeInsets.only(bottom: 30.h),
      child: AnimationLimiter(
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: 3,
          padding: EdgeInsets.only(left: 16.w),
          itemBuilder: (context, index) => AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 375),
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 6.r),
                      height: 180.h,
                      width: MediaQuery.of(context).size.width - 46,
                      decoration: BoxDecoration(
                        color: AppStyle.shimmerBase,
                        borderRadius: BorderRadius.all(
                          Radius.circular(8.r),
                        ),
                      ),
                    ),
                  /*  Positioned(
                      bottom: 12.0,
                      left: 20.0,
                      child: OrderBadge(
                        imageColor: AppStyle.white,
                        containerColor: AppStyle.bgGrey,
                        textColor: AppStyle.shimmerBase,
                      ) // Assuming OrderBadge is the widget you want to display
                    ), */
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
