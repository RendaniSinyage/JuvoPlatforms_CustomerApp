import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:riverpodtemp/infrastructure/services/app_constants.dart';
import 'package:riverpodtemp/infrastructure/services/app_helpers.dart';
import 'package:riverpodtemp/presentation/routes/app_router.dart';
import 'package:riverpodtemp/presentation/theme/app_style.dart';

class InfoItem extends StatelessWidget {
  final int index;

  final bool isLarge;

  const InfoItem({super.key, required this.index, this.isLarge = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.pushRoute(InfoRoute(index: index));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10.r),
        width: MediaQuery.sizeOf(context).width / 2 - 24.r,
        height: isLarge ? 230.r : 168.r,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            image: DecorationImage(
                image: AssetImage(AppConstants.infoImage[index]),
                fit: BoxFit.cover)),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 18.r, bottom: 12.r, right: 24.r),
            child: Text(
              AppHelpers.getTranslation(AppConstants.infoTitle[index]),
              style: AppStyle.interNoSemi(size: 16, color: AppStyle.white),
            ),
          ),
        ),
      ),
    );
  }
}
