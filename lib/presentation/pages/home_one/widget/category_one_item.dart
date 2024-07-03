import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:riverpodtemp/presentation/components/custom_network_image.dart';

import '../../../theme/app_style.dart';

class CategoryOneItem extends StatelessWidget {
  final String image;
  final String title;
  final int index;
  final VoidCallback onTap;
  final bool isActive;

  const CategoryOneItem(
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
            width: 72.r,
            height: 72.r,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10.r)),
                color: isActive ? AppStyle.brandGreen : AppStyle.white),
            child: InkWell(
              onTap: onTap,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomNetworkImage(
                    fit: BoxFit.contain,
                    url: image,
                    height: 48.r,
                    width: 48.r,
                    radius: 0,
                  ),
                ],
              ),
            )),
        6.verticalSpace,
        SizedBox(
          width: 64.w,
          child: Text(
            title,
            style: AppStyle.interNormal(
              size: 12,
              color: AppStyle.black,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
