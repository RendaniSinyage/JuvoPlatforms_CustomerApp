import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:foodyman/presentation/theme/app_style.dart';

class ShimmerCategoryList extends StatelessWidget {
  const ShimmerCategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100.h,
      child: ListView.builder(
        padding: REdgeInsets.only(top: 46,bottom: 14,left: 12),
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemExtent: 120.r,
        itemCount: 8,
        itemBuilder: (context, index) {
          return Container(
            height: 48.h,
            width: 100.r,
            margin: REdgeInsets.only(right: 16,),
            decoration: BoxDecoration(
              color: AppStyle.shimmerBase,
              borderRadius: BorderRadius.circular(10.r),
            ),
          );
        },
      ),
    );
  }
}
