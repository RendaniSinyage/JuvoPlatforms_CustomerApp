import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:riverpodtemp/infrastructure/models/models.dart';
import 'package:riverpodtemp/infrastructure/services/app_helpers.dart';
//import 'package:riverpodtemp/infrastructure/services/tr_keys.dart';
import 'package:riverpodtemp/presentation/components/custom_network_image.dart';
import 'package:riverpodtemp/presentation/components/badges.dart';
import 'package:riverpodtemp/presentation/pages/home/widgets/banner_screen.dart';
import 'package:riverpodtemp/presentation/theme/theme.dart';

class BannerItem extends StatelessWidget {
  final BannerData banner;
  final bool isAds;

  const BannerItem({
    Key? key,
    required this.banner,
    this.isAds = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppHelpers.showCustomModalBottomSheet(
          context: context,
          modal: BannerScreen(
            isAds: isAds,
            bannerId: banner.id ?? 0,
            image: banner.img ?? "",
            desc: banner.translation?.description ?? "",
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
