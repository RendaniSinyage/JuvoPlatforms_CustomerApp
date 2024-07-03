import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:riverpodtemp/presentation/theme/theme.dart';

import '../../../../infrastructure/services/app_helpers.dart';
import '../../../../infrastructure/services/tr_keys.dart';
import 'market_shimmer_three.dart';

class ShopShimmerThree extends StatelessWidget {
  final String title;

  const ShopShimmerThree({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          AppHelpers.getTranslation(TrKeys.chooseBrand),
          style: AppStyle.interNoSemi(),
        ),
        SizedBox(
            child: AnimationLimiter(
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 8.r,
                  crossAxisSpacing: 8.r,
                  mainAxisExtent: 168.r,
                ),
                padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 16),
                
                shrinkWrap: true,
                itemCount: 6,
                itemBuilder: (context, index) =>
                    AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 375),
                  child: const SlideAnimation(
                    verticalOffset: 50.0,
                    child: FadeInAnimation(
                      child: MarketShimmerThree(
                        isShop: true,
                      ),
                    ),
                  ),
                ),
              ),
            )),
      ],
    );
  }
}
