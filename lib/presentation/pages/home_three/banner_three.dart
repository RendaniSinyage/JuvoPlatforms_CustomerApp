import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:riverpodtemp/application/home/home_notifier.dart';
import 'package:riverpodtemp/infrastructure/models/models.dart';
import 'package:riverpodtemp/presentation/pages/home_three/widgets/banner_item_three.dart';
import 'package:riverpodtemp/presentation/theme/app_style.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class BannerThree extends StatefulWidget {
  final RefreshController bannerController;
  final PageController pageController;
  final List<BannerData> banners;
  final HomeNotifier notifier;

  const BannerThree({
    Key? key,
    required this.bannerController,
    required this.pageController,
    required this.banners,
    required this.notifier,
  }) : super(key: key);

  @override
  _BannerThreeState createState() => _BannerThreeState();
}

class _BannerThreeState extends State<BannerThree> {
  late Timer _timer;
  int _currentPage = 0;
  bool _showedQuarterAnimation = false;

  @override
  void initState() {
    super.initState();
    _startAutoPlay();
  }

  @override
  void dispose() {
    _stopAutoPlay();
    super.dispose();
  }

  void _startAutoPlay() {
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (!_showedQuarterAnimation) {
        // Move to the right by a small portion (30% of the page width)
        widget.pageController
            .animateTo(
              widget.pageController.position.viewportDimension * 0.3,
              duration: Duration(milliseconds: 800),
              curve: Curves.ease,
            )
            .then((_) {
          setState(() {
            _showedQuarterAnimation = true;
          });
          Future.delayed(Duration(milliseconds: 1000), () {
            widget.pageController
                .animateToPage(0, duration: Duration(milliseconds: 500), curve: Curves.ease);
          });
        });
      } else {
        // Stop auto-scrolling after showing a portion of the second item
        _stopAutoPlay();
      }
    });
  }

  void _stopAutoPlay() {
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: widget.banners.isNotEmpty ? 120.h : 0,
          margin: EdgeInsets.only(bottom: widget.banners.isNotEmpty ? 8.h : 0),
          child: SmartRefresher(
            scrollDirection: Axis.horizontal,
            enablePullDown: false,
            enablePullUp: true,
            controller: widget.bannerController,
            onLoading: () async {
              await widget.notifier.fetchBannerPage(
                  context, widget.bannerController);
            },
            child: AnimationLimiter(
              child: PageView.builder(
                controller: widget.pageController,
                scrollDirection: Axis.horizontal,
                itemCount: widget.banners.length,
                itemBuilder: (context, index) {
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 375),
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: BannerItemThree(
                          banner: widget.banners[index],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        if (widget.banners.length > 2)
          SizedBox(
            height: 8.r,
            child: SmoothPageIndicator(
              controller: widget.pageController,
              count: widget.banners.length,
              effect: ExpandingDotsEffect(
                expansionFactor: 2.2,
                dotWidth: 8.r,
                strokeWidth: 10.r,
                dotHeight: 4.r,
                activeDotColor: AppStyle.black,
                dotColor: AppStyle.dotColor,
                paintStyle: PaintingStyle.fill,
              ),
              onDotClicked: (index) {},
            ),
          ),
        12.verticalSpace,
      ],
    );
  }
}
