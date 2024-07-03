import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:riverpodtemp/presentation/components/custom_network_image.dart';

import '../../../theme/app_style.dart';

class CategoryTwoItem extends StatelessWidget {
  final String image;
  final String title;
  final int index;
  final VoidCallback onTap;
  final bool isActive;

  const CategoryTwoItem(
      {super.key,
      required this.image,
      required this.title,
      required this.index,
      this.isActive = false,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            margin: EdgeInsets.only(left: index == 1 ? 4.r : 0, right: 8.r),
            width: 64.r,
            height: 100.r,
            padding: REdgeInsets.all(6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(70.r)),
              color: isActive ? AppStyle.brandGreen : AppStyle.white,
              boxShadow: const [
                BoxShadow(
                  color: AppStyle.shadow,
                  blurRadius: 15,
                  offset: Offset(0, 4),
                  spreadRadius: 0,
                )
              ],
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(24.r),
              onTap: onTap,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: AppStyle.bgGrey,
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                    child: CustomNetworkImage(
                      fit: BoxFit.contain,
                      url: image,
                      height: 48.r,
                      width: 48.r,
                      radius: 24.r,
                    ),
                  ),
                  8.verticalSpace,
                  SizedBox(
                    width: 62.w,
                    child: Text(
                      title,
                      style: AppStyle.interNormal(
                        size: 12,
                        color: AppStyle.black,
                      ),
                      maxLines: 1,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }
}
