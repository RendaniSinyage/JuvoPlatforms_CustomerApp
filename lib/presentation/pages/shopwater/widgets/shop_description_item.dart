import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:riverpodtemp/presentation/theme/theme.dart';

class ShopDescriptionItem extends StatelessWidget {
  final String title;
  final String description;
  final Widget icon;
  const ShopDescriptionItem({super.key, required this.title, required this.description, required this.icon});

  @override
  Widget build(BuildContext context) {
    return  Container(
      height: 54+48.r,
      decoration: BoxDecoration(
          color: AppStyle.bgGrey,
          borderRadius: BorderRadius.all(Radius.circular(10.r))),
      padding: EdgeInsets.all(12.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          icon,
          4.verticalSpace,
          Text(
            title,
            style: AppStyle.interRegular(
              size: 12,
              color: AppStyle.black,
            ),
          ),
          SizedBox(
            width: (MediaQuery.sizeOf(context).width-132.h)/3,
            child: Text(
              description,
              style: AppStyle.interSemi(
                size: 12,
                color: AppStyle.black,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

          ),
        ],
      ),
    );
  }
}
