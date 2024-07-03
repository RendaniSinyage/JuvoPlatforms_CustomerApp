import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:riverpodtemp/infrastructure/models/data/address_new_data.dart';
import 'package:riverpodtemp/presentation/theme/theme.dart';

class SelectAddressItem extends StatelessWidget {
  final VoidCallback onTap;
  final VoidCallback update;
  final bool isActive;
  final AddressNewModel? address;

  const SelectAddressItem({
    super.key,
    required this.onTap,
    required this.isActive,
    required this.address,
    required this.update,
  });

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
              borderRadius: BorderRadius.all(Radius.circular(10.r))),
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
                      color: isActive ? AppStyle.brandGreen : AppStyle.transparent,
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: isActive ? AppStyle.black : AppStyle.textGrey,
                          width: isActive ? 4.r : 2.r)),
                ),
                16.horizontalSpace,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width - 150.r,
                        child: Text(
                          address?.title ?? address?.address?.address ?? "",
                          style: AppStyle.interNormal(
                            size: 16,
                            color: AppStyle.black,
                          ),
                        ),
                      ),
                      if(address?.title != null)
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width - 150.r,
                        child: Text(
                          address?.address?.address ?? "",
                          style: AppStyle.interNormal(
                            size: 12,
                            color: AppStyle.textGrey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                    onPressed: () {
                      update.call();
                    },
                    icon: const Icon(FlutterRemix.equalizer_line)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
