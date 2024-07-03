import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:riverpodtemp/presentation/components/title_icon.dart';

import '../../../../infrastructure/services/app_helpers.dart';
import '../../../../infrastructure/services/tr_keys.dart';
import 'market_two_shimmer.dart';

class AllShopTwoShimmer extends StatelessWidget {
  final bool isTitle;

  const AllShopTwoShimmer({super.key, this.isTitle = true});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        isTitle
            ? TitleAndIcon(
                title: AppHelpers.getTranslation(TrKeys.allRestaurants),
              )
            : const SizedBox.shrink(),
        AnimationLimiter(
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16.r,
              crossAxisSpacing: 16.r,
              mainAxisExtent: 230.r,
            ),
            padding: EdgeInsets.only(
              top: 6.h,
              left: 16,
              right: 16,
            ),
            shrinkWrap: true,
            
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: 6,
            itemBuilder: (context, index) =>
                AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 375),
              child: SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(
                  child: MarketTwoShimmer(
                    isSimpleShop: true,
                    index: index,
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
