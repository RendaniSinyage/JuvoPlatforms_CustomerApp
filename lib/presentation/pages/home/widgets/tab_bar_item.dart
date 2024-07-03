import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:riverpodtemp/presentation/components/custom_network_image.dart';
import 'package:riverpodtemp/presentation/theme/theme.dart';

class CategoryBarItem extends StatelessWidget {
  final String image;
  final String title;
  final int index;
  final VoidCallback onTap;
  final bool isActive;

  const CategoryBarItem(
      {super.key,
      required this.image,
      required this.title,
      required this.index,
      this.isActive = false,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 100.r,
        height: 100.r,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? AppStyle.brandGreen : AppStyle.white),
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomNetworkImage(
                fit: BoxFit.contain,
                url: image,
                height: 48.r,
                width: 48.r,
                radius: 0,
              ),
              4.verticalSpace,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.r),
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
          ),
        ));
  }
}
