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
        width: isActive ? 100.r : 85.r,
        height: isActive ? 100.r : 85.r,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
     //  color: isActive ? AppStyle.brandGreen : AppStyle.white),
	  //color: isActive ? AppStyle.brandGreen : AppStyle.brandGreen.withOpacity(0.06),
          color: isActive ? AppStyle.brandGreen : AppStyle.transparent,
         // border: Border.all(color: isActive ? AppStyle.transparent : AppStyle.brandGreen, ), // added border
           ), //changed
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomNetworkImage(
                fit: BoxFit.contain,
                url: image,
                height: isActive ? 48 : 35.r,
                width: isActive ? 48 : 35.r,
                radius: 0,
			 color: isActive ? AppStyle.white : AppStyle.brandGreen, // Changed added
              ),
              4.verticalSpace,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.r),
                child: Text(
                  title,
                  style: AppStyle.interNormal(
                   // size: isActive ? 12 : 10,
                    size:  12,
                    // color: AppStyle.black,
color: isActive ? AppStyle.white : AppStyle.brandGreen, //changed
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
