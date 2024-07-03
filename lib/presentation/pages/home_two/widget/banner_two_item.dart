import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:riverpodtemp/infrastructure/models/response/banners_paginate_response.dart';
import 'package:riverpodtemp/infrastructure/services/app_helpers.dart';
import 'package:riverpodtemp/presentation/components/custom_network_image.dart';
import 'package:riverpodtemp/presentation/pages/home/widgets/banner_screen.dart';

import '../../../theme/app_style.dart';

class BannerTwoItem extends StatelessWidget {
  final BannerData banner;

  const BannerTwoItem({super.key, required this.banner});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: REdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: () {
          AppHelpers.showCustomModalBottomSheet(
              context: context,
              modal: BannerScreen(
                bannerId: banner.id ?? 0,
                image: banner.img ?? "",
                desc: banner.translation?.description ?? "",
                list: banner.shops ?? [],
              ),
              isDarkMode: false);
        },
        child: Stack(
          children: [
            CustomNetworkImage(
              bgColor: AppStyle.white,
              url: banner.img ?? "",
              height: double.infinity,
              width: 148.r,
              radius: 20.r,
            ),
            Positioned(
                bottom: 0,
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  decoration: ShapeDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppStyle.black.withOpacity(0.2),
                        AppStyle.black.withOpacity(0.2),
                        AppStyle.black.withOpacity(0.2),
                        AppStyle.black.withOpacity(0.5),
                        AppStyle.black.withOpacity(0.7),
                      ],
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                  ),
                )),
            Positioned(
              bottom: 24,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  banner.translation?.title ?? "",
                  style: AppStyle.interNoSemi(
                    color: AppStyle.white,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
