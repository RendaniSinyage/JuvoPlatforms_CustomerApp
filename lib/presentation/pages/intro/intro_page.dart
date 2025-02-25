import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
//import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodyman/infrastructure/services/tr_keys.dart'; //Changed
import 'package:foodyman/infrastructure/services/app_helpers.dart'; //changed
import 'package:foodyman/presentation/components/buttons/second_button.dart';
//import '../../components/helper/shimmer.dart';
import 'package:foodyman/presentation/routes/app_router.dart';

import '../../../application/intro/intro_provider.dart';
//import '../../component/components.dart';
import 'package:foodyman/presentation/theme/theme.dart';

//import 'package:shared_preferences/shared_preferences.dart';

@RoutePage()
class IntroPage extends ConsumerStatefulWidget {
  const IntroPage({super.key});

  @override
  ConsumerState<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends ConsumerState<IntroPage>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  final pageController = PageController(initialPage: 0);
  int currentIndex = 0;

  final List<String> images = [
    "assets/images/intro/1.jpg",
    "assets/images/intro/2.jpg",
    "assets/images/intro/3.jpg",
    "assets/images/intro/4.jpg",
    "assets/images/intro/5.jpg",
  ];

  final List<Map<String, dynamic>> titles = [
    {
      'text1': AppHelpers.getTranslation(TrKeys.introslide1),
      'style1': AppStyle.interBold(
        size: 40.sp,
        letterSpacing: -0.3,
        color: AppStyle.white,
      ),
      'text2': AppHelpers.getTranslation(TrKeys.introbriefslide1),
      'style2': AppStyle.interNormal(
        size: 14.sp,
        letterSpacing: -0.3,
        color: AppStyle.white,
      ),
    },
    {
      'text1': AppHelpers.getTranslation(TrKeys.introslide2),
      'style1': AppStyle.interBold(
        size: 40.sp,
        letterSpacing: -0.3,
        color: AppStyle.white,
      ),
      'text2': AppHelpers.getTranslation(TrKeys.introbriefslide2),
      'style2': AppStyle.interNormal(
        size: 14.sp,
        letterSpacing: -0.3,
        color: AppStyle.white,
      ),
    },
    {
      'text1': AppHelpers.getTranslation(TrKeys.introslide3),
      'style1': AppStyle.interBold(
        size: 40.sp,
        letterSpacing: -0.3,
        color: AppStyle.white,
      ),
      'text2': AppHelpers.getTranslation(TrKeys.introbriefslide3),
      'style2': AppStyle.interNormal(
        size: 14.sp,
        letterSpacing: -0.3,
        color: AppStyle.white,
      ),
    },
    {
      'text1': AppHelpers.getTranslation(TrKeys.introslide4),
      'style1': AppStyle.interBold(
        size: 40.sp,
        letterSpacing: -0.3,
        color: AppStyle.white,
      ),
      'text2': AppHelpers.getTranslation(TrKeys.introbriefslide4),
      'style2': AppStyle.interNormal(
        size: 14.sp,
        letterSpacing: -0.3,
        color: AppStyle.white,
      ),
    },
    {
      'text1': AppHelpers.getTranslation(TrKeys.introslide5),
      'style1': AppStyle.interBold(
        size: 40.sp,
        letterSpacing: -0.3,
        color: AppStyle.white,
      ),
      'text2': AppHelpers.getTranslation(TrKeys.introbriefslide5),
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
          if (ref.watch(introProvider).currentIndex == 4) {
            context.pushRoute(const MainRoute());
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
    final state = ref.watch(introProvider);
    final event = ref.read(introProvider.notifier);
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
            children: images.map((e) {
              int index = images.indexOf(e);
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
                      child: Image.asset(
                        e, // Load image from asset
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const Spacer(),
                          Text(
                            titles[index]['text1'],
                            style: titles[index]['style1'],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            titles[index]['text2'],
                            style: titles[index]['style2'],
                          ),
                          const SizedBox(height: 24),
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
                  Container(
  alignment: Alignment.topRight,
  margin: const EdgeInsets.only(right: 16, top: 48),
  child: SecondButton(
    onTap: () {
      context.pushRoute(const MainRoute());
    },
    title: AppHelpers.getTranslation(TrKeys.close),
    bgColor: AppStyle.primary,
    titleColor: AppStyle.white,
  //  icon: FlutterRemix.close,
  //  iconColor: AppStyle.white,
  //  iconSize: 30,
  ),
)

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
                margin: const EdgeInsets.only(left: 20, bottom: 10),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return AnimatedContainer(
                      margin: const EdgeInsets.only(right: 8),
                      height: 4,
                      width: (MediaQuery.of(context).size.width - 60) / 5,
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
                              : const SizedBox.shrink(),
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
