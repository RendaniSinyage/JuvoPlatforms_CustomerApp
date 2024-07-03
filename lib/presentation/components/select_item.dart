import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:riverpodtemp/presentation/theme/theme.dart';

class SelectItem extends StatelessWidget {
  final VoidCallback onTap;
  final bool isActive;
  final String title;
  final String? desc;
  const SelectItem({super.key, required this.onTap, required this.isActive, required this.title, this.desc, });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              color: AppStyle.white,
              borderRadius:
              BorderRadius.all(Radius.circular(10.r))),
          child: Padding(
            padding: EdgeInsets.all(18.r),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  width: 18.w,
                  height: 18.h,
                  decoration: BoxDecoration(
                      color: isActive
                          ? AppStyle.brandGreen
                          : AppStyle.transparent,
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: isActive
                              ? AppStyle.black
                              : AppStyle.textGrey,
                          width:
                          isActive ? 4.r : 2.r)),
                ),
                16.horizontalSpace,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppStyle.interNormal(
                        size: 16,
                        color: AppStyle.black,
                      ),
                    ),
                    desc != null  ? SizedBox(
                      width: MediaQuery.sizeOf(context).width/1.5,
                      child: Text(
                        desc ?? "",
                        style: AppStyle.interNormal(
                          size: 14,
                          color: AppStyle.textGrey,
                        ),
                      ),
                    ) : const SizedBox.shrink(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
