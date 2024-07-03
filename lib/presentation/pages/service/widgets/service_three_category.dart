import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:riverpodtemp/application/home/home_notifier.dart';
import 'package:riverpodtemp/application/home/home_state.dart';
import 'package:riverpodtemp/infrastructure/services/app_helpers.dart';
import 'package:riverpodtemp/presentation/components/buttons/animation_button_effect.dart';
import 'package:riverpodtemp/presentation/pages/home/filter/filter_page.dart';
import 'package:riverpodtemp/presentation/pages/home_three/shimmer/category_shimmer.dart';
import 'package:riverpodtemp/presentation/pages/home_three/widgets/category_bar_item_three.dart';
import 'package:riverpodtemp/presentation/theme/app_style.dart';

class ServiceThreeCategory extends StatelessWidget {
  final HomeState state;
  final HomeNotifier event;
  final int categoryIndex;

  const ServiceThreeCategory(
      {super.key,
      required this.state,
      required this.event,
      required this.categoryIndex});

  @override
  Widget build(BuildContext context) {
    return state.isCategoryLoading
        ? const CategoryShimmerThree()
        : Container(
            height: state.categories.isNotEmpty ? 40.h : 0,
            margin:
                EdgeInsets.only(bottom: state.categories.isNotEmpty ? 26.h : 0),
            child: AnimationLimiter(
              child: ListView.builder(
                padding: REdgeInsets.symmetric(horizontal: 12),
                shrinkWrap: true,
                
                scrollDirection: Axis.horizontal,
                itemCount:
                    (state.categories[categoryIndex].children?.length ?? 0) + 1,
                itemBuilder: (context, index) {
                  final category = state.categories[categoryIndex];

                  return index == 0
                      ? Padding(
                        padding: REdgeInsets.only(right: 12),
                        child: AnimationButtonEffect(
                    child: InkWell(
                        borderRadius: BorderRadius.circular(14.r),
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
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              "assets/svgs/menu.svg",
                              height: 18.r,
                            ),
                          ),
                        ),
                    ),
                  ),
                      )
                      :  AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 375),
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: CategoryBarItemThree(
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
