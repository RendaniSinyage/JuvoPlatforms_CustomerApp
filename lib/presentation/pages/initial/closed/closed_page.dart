import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:foodyman/infrastructure/services/tr_keys.dart'; //Changed
import 'package:foodyman/infrastructure/services/app_helpers.dart'; //changed
import 'package:foodyman/presentation/components/helper/shimmer.dart';
import 'package:foodyman/presentation/routes/app_router.dart';

import 'package:foodyman/application/closed/closed_provider.dart';
//import 'package:foodyman/presentation/component/components.dart';
import 'package:foodyman/presentation/theme/theme.dart';

import 'package:shared_preferences/shared_preferences.dart';

@RoutePage()
class ClosedPage extends ConsumerStatefulWidget {
  const ClosedPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ClosedPage> createState() => _ClosedPageState();
}

class _ClosedPageState extends ConsumerState<ClosedPage>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  final pageController = PageController(initialPage: 0);
  int currentIndex = 0;

  final List<String> image = [
    "https://d29qdaaunou30u.cloudfront.net/public/images/closed/customer/1.jpg",
  ];

  final List<Map<String, dynamic>> titles = [
    {
      'text1': 'Juvo is Closed Today',
      'style1': AppStyle.interBold(
        size: 50.sp,
        letterSpacing: -0.3,
        color: AppStyle.white,
      ),
      'text2': 'We operate between 8am and 10pm everyday.',
      'style2': AppStyle.interNormal(
        size: 14.sp,
        letterSpacing: -0.3,
        color: AppStyle.white,
      ),
    },
  ];

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..addListener(() {
        setState(() {});
        if (controller.value > 0.99) {
          if (ref.watch(closedProvider).currentIndex == 4) {
            context.pushRoute(MainRoute());
          } else {
            pageController.nextPage(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeIn,
            );
          }
        }
      });
    controller.repeat();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(closedProvider);
    final event = ref.read(closedProvider.notifier);
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            physics: const ClampingScrollPhysics(),
            controller: pageController,
            onPageChanged: (s) {
              event.changeIndex(s);
              controller.reset();
              controller.repeat();
            },
            children: image.map((e) {
              int index = image.indexOf(e);
              return Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    foregroundDecoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppStyle.primary.withOpacity(0.26),
                          AppStyle.primary.withOpacity(0),
                          AppStyle.primary.withOpacity(0),
                          AppStyle.primary.withOpacity(0.26)
                        ],
                      ),
                    ),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      foregroundDecoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppStyle.black.withOpacity(0.4),
                            AppStyle.black.withOpacity(0.4)
                          ],
                        ),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: e,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        fit: BoxFit.cover,
                        progressIndicatorBuilder: (context, url, progress) {
                          return const ImageShimmer(
                            isCircle: false,
                            size: 0,
                          );
                        },
                        errorWidget: (context, url, error) {
                          return Container(
                            decoration: BoxDecoration(
                              color: AppStyle.textGrey,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            alignment: Alignment.center,
                            child: const Icon(
                              FlutterRemix.image_line,
                              color: AppStyle.black,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  SafeArea(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const Spacer(),
                          Text(
                            titles[index]['text1'],
                            style: titles[index]['style1'],
                          ),
                          SizedBox(height: 8),
                          Text(
                            titles[index]['text2'],
                            style: titles[index]['style2'],
                          ),
                          SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          pageController.previousPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeIn,
                          );
                        },
                        child: Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width / 2,
                          color: Colors.transparent,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          pageController.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeIn,
                          );
                        },
                        child: Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width / 2,
                          color: Colors.transparent,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }).toList(),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              child: Container(
                height: 4,
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(left: 20, bottom: 10),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 1,
                  itemBuilder: (context, index) {
                    return AnimatedContainer(
                      margin: EdgeInsets.only(right: 8),
                      height: 4,
                      width: (MediaQuery.of(context).size.width - 60),
                      decoration: BoxDecoration(
                        color: state.currentIndex >= index
                            ? AppStyle.primary
                            : AppStyle.white,
                        borderRadius: BorderRadius.circular(122),
                      ),
                      duration: const Duration(milliseconds: 500),
                      child: state.currentIndex == index
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(122),
                              child: LinearProgressIndicator(
                                value: controller.value,
                                valueColor:
                                    const AlwaysStoppedAnimation<Color>(
                                        AppStyle.primary),
                                backgroundColor: AppStyle.white,
                              ),
                            )
                          : state.currentIndex > index
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(122),
                                  child: const LinearProgressIndicator(
                                    value: 1,
                                    valueColor:
                                        AlwaysStoppedAnimation<Color>(
                                            AppStyle.primary),
                                    backgroundColor: AppStyle.white,
                                  ),
                                )
                              : SizedBox.shrink(),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
