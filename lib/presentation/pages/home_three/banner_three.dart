import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:riverpodtemp/application/home/home_notifier.dart';
import 'package:riverpodtemp/infrastructure/models/models.dart';
import 'package:riverpodtemp/presentation/pages/home_three/widgets/banner_item_three.dart';
import 'package:riverpodtemp/presentation/theme/app_style.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class BannerThree extends StatelessWidget {
  final RefreshController bannerController;
  final PageController pageController;
  final List<BannerData> banners;
  final HomeNotifier notifier;

  const BannerThree({
    super.key,
    required this.bannerController,
    required this.pageController,
    required this.banners,
    required this.notifier,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: banners.isNotEmpty ? 160.h : 0,
          margin: EdgeInsets.only(bottom: banners.isNotEmpty ? 8.h : 0),
          child: SmartRefresher(
            scrollDirection: Axis.horizontal,
            enablePullDown: false,
            enablePullUp: true,

            controller: bannerController,
            onLoading: () async {
              await notifier.fetchBannerPage(context, bannerController);
            },
            child: AnimationLimiter(
              child: PageView.builder(
                controller: pageController,
                scrollDirection: Axis.horizontal,
                itemCount: banners.length,
                itemBuilder: (context, index) {
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 375),
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: BannerItemThree(
                          banner: banners[index],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        if (banners.length > 2)
          SizedBox(
              height: 8.r,
              child: SmoothPageIndicator(
                  controller: pageController,
                  count: banners.length,
                  effect: ExpandingDotsEffect(
                    expansionFactor: 2.2,
                    dotWidth: 8.r,
                    strokeWidth: 10.r,
                    dotHeight: 4.r,
                    activeDotColor: AppStyle.black,
                    dotColor: AppStyle.dotColor,
                    paintStyle: PaintingStyle.fill,
                  ),
                  onDotClicked: (index) {})),
        12.verticalSpace,
      ],
    );
  }
}
