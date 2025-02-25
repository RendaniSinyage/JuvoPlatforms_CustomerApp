import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodyman/infrastructure/models/models.dart';
import 'package:foodyman/infrastructure/services/app_helpers.dart';
//import 'package:foodyman/infrastructure/services/tr_keys.dart';
import 'package:foodyman/presentation/components/custom_network_image.dart';
import 'package:foodyman/presentation/components/badges.dart';
import 'package:foodyman/presentation/pages/home/home_four/banner_screen.dart';
import 'package:foodyman/presentation/theme/theme.dart';

class BannerItem extends StatelessWidget {
  final BannerData banner;
  final bool isAds;

  const BannerItem({
    super.key,
    required this.banner,
    this.isAds = false,
  });

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print("BUTTON TEXT DEBUG: BannerItem build for banner ID: ${banner.id}");
    }
    if (kDebugMode) {
      print("BUTTON TEXT DEBUG: Button text in BannerItem build: '${banner.buttonText}'");
    }
    
    return GestureDetector(
      onTap: () {
        if (kDebugMode) {
          print("MODAL DEBUG: About to create BannerScreen with buttonText: '${this.banner.buttonText}'");
        }
        AppHelpers.showCustomModalBottomSheet(
          context: context,
          modal: BannerScreen(
            isAds: isAds,
            bannerId: banner.id ?? 0,
            image: banner.img ?? "",
            desc: banner.translation?.description ?? "",
            buttonText: banner.buttonText,
            list: banner.shops ?? [],
          ),
          isDarkMode: false,
        );
      },
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(right: 6.r),
            width: MediaQuery.of(context).size.width - 46,
            decoration: BoxDecoration(
              color: AppStyle.white,
              borderRadius: BorderRadius.all(
                Radius.circular(15.r),
              ),
            ),
            child: CustomNetworkImage(
              bgColor: AppStyle.white,
              url: banner.img ?? "",
              height: double.infinity,
              width: double.infinity,
              radius: 15.r,
            ),
          ),
          if (isAds)
            Positioned(
              right: 13.w,
              top: 10.h,
              child: const AdBadge(),
            ),
        ],
      ),
    );
  }
}
