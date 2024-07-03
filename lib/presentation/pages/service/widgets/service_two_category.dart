import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:riverpodtemp/application/home/home_notifier.dart';
import 'package:riverpodtemp/application/home/home_state.dart';
import 'package:riverpodtemp/infrastructure/services/app_helpers.dart';
import 'package:riverpodtemp/presentation/components/buttons/animation_button_effect.dart';
import 'package:riverpodtemp/presentation/pages/home/filter/filter_page.dart';
import 'package:riverpodtemp/presentation/pages/home_two/widget/category_two_item.dart';
import 'package:riverpodtemp/presentation/theme/app_style.dart';

class ServiceTwoCategory extends StatelessWidget {
  final HomeState state;
  final HomeNotifier event;
  final int categoryIndex;

  const ServiceTwoCategory(
      {super.key,
      required this.state,
      required this.event,
      required this.categoryIndex});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: state.categories.isNotEmpty ? 132.h : 0,
      child: AnimationLimiter(
        child: ListView.builder(
          padding: EdgeInsets.only(left: 16.r, bottom: 16.r, top: 8.r),
          shrinkWrap: true,
          
          scrollDirection: Axis.horizontal,
          itemCount:
              (state.categories[categoryIndex].children?.length ?? 0) + 1,
          itemBuilder: (context, index) {
            final category = state.categories[categoryIndex];
            return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 375),
              child: SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(
                  child: index == 0
                      ? AnimationButtonEffect(
                          child: Padding(
                            padding:
                                REdgeInsets.only(right: 8, bottom: 8, top: 4),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(24.r),
                              onTap: () {
                                AppHelpers.showCustomModalBottomDragSheet(
                                  context: context,
                                  modal: (c) => FilterPage(
                                    controller: c,
                                    categoryId: (state.selectIndexSubCategory !=
                                                -1
                                            ? (state
                                                .categories[
                                                    state.selectIndexCategory]
                                                .children?[state
                                                    .selectIndexSubCategory]
                                                .id)
                                            : state
                                                .categories[
                                                    state.selectIndexCategory]
                                                .id) ??
                                        0,
                                  ),
                                  isDarkMode: false,
                                  isDrag: false,
                                  radius: 12,
                                );
                              },
                              child: Container(
                                width: 44.w,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 6.r, vertical: 4.r),
                                decoration: BoxDecoration(
                                  color: AppStyle.black,
                                  boxShadow: const [
                                    BoxShadow(
                                      color: AppStyle.shadow,
                                      blurRadius: 15,
                                      offset: Offset(0, 4),
                                      spreadRadius: 0,
                                    )
                                  ],
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                                child: Center(
                                  child: SvgPicture.asset(
                                    "assets/svgs/menu.svg",
                                    height: 20.r,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      : CategoryTwoItem(
                          index: index - 1,
                          image: category.children?[index - 1].img ?? "",
                          title: category
                                  .children?[index - 1].translation?.title ??
                              "",
                          isActive: index - 1 == state.selectIndexSubCategory,
                          onTap: () {
                            event.setSelectSubCategory(index - 1, context);
                          },
                        ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
