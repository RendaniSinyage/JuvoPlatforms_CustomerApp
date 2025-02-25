import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:foodyman/presentation/components/title_icon.dart';
import 'package:foodyman/presentation/theme/app_style.dart';
//import '../../../../infrastructure/services/app_helpers.dart';
//import '../../../../infrastructure/services/tr_keys.dart';
import '../../../../infrastructure/services/app_helpers.dart';
import '../../../../infrastructure/services/tr_keys.dart';
import 'market_shimmer.dart';

class NewsShopShimmer extends StatelessWidget {
  final String title;

  const NewsShopShimmer({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TitleAndIcon(
          rightTitle: AppHelpers.getTranslation(TrKeys.seeAll),
          isIcon: true,
          title: title,
          titleColor: AppStyle.shimmerBase,
          rightTitleColor: AppStyle.white,
          containerColor: AppStyle.shimmerBase,
          borderColor: AppStyle.shimmerBase,
          iconColor: AppStyle.white,
          onRightTap: () {},
        ),
        12.verticalSpace,
        SizedBox(
            height: 120.h,
            child: AnimationLimiter( 
              child: ListView.builder(
                shrinkWrap: false,
                scrollDirection: Axis.horizontal,
                itemCount: 4,
                itemBuilder: (context, index) =>
                    AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 375),
                  child: SlideAnimation(
                    verticalOffset: 50.0,
                    child: FadeInAnimation(
                      child: MarketShimmer(index: index),
                    ),
                  ),
                ),
              ),
            )),
      ],
    );
  }
}
