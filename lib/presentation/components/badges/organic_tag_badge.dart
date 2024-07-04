import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:remixicon/remixicon.dart';
import '../../../infrastructure/models/data/shop_data.dart';
import '../../../infrastructure/services/app_helpers.dart';
import '../../../infrastructure/services/tr_keys.dart';
import '../../theme/app_style.dart';
import '../../../../infrastructure/models/response/all_products_response.dart';

class OrganicTagBadge extends StatelessWidget {
  final Product product;
  final double? bottom;
  final String? workTime;
  final double? left;
  final double? right;
  final double? top;

  const OrganicTagBadge({
    super.key,
    required this.product,
    this.bottom,
    this.left,
    this.workTime,
    this.right,
    this.top,
  });

  @override
  Widget build(BuildContext context) {
    return product.vegetarian == true
        ? Positioned(
      bottom: bottom,
      left: left ?? 98.w,
      right: right,
      top: top ?? 20.h,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.green,
            width: 1,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: const Icon(
            Remix.leaf_fill,
            color: Colors.green,
            size: 15,
          ),
        ),
      ),
    )
        : const SizedBox.shrink();
  }
}