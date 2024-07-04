import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/app_style.dart';

class ImageShimmer extends StatelessWidget {
  final double size;
  final bool isCircle;


  const ImageShimmer(
      {super.key, required this.size, required this.isCircle,});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppStyle.shimmerBase,
      highlightColor: AppStyle.shimmerHighlight,
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
          color: AppStyle.white,
        ),
      ),
    );
  }
}
