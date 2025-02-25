import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:foodyman/application/home/home_notifier.dart';
import 'package:foodyman/infrastructure/models/models.dart';
import 'package:foodyman/presentation/theme/app_style.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../home_three/widgets/banner_item_three.dart';

class BannerThree extends StatefulWidget {
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
  _BannerThreeState createState() => _BannerThreeState();
}

class _BannerThreeState extends State<BannerThree> {
  late Timer _timer;
  int _currentPage = 0;
  bool _userInteracted = false;

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
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!_userInteracted && widget.banners.length > 1) {
        _currentPage = (_currentPage + 1) % widget.banners.length;
        widget.pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.ease,
        );
      }
    });
  }

  void _stopAutoPlay() {
    _timer.cancel();
  }

  void _handleUserInteraction() {
    setState(() {
      _userInteracted = true;
    });
    _stopAutoPlay();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: widget.banners.isNotEmpty ? 120.h : 0,
          margin: EdgeInsets.only(bottom: widget.banners.isNotEmpty ? 8.h : 0),
          child: GestureDetector(
            onPanDown: (_) => _handleUserInteraction(),
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
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
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
        ),
        if (widget.banners.length > 1)
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
              onDotClicked: (index) {
                _handleUserInteraction();
                widget.pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.ease,
                );
              },
            ),
          ),
        12.verticalSpace,
      ],
    );
  }
}