import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:riverpodtemp/application/home/home_notifier.dart';
import 'package:riverpodtemp/application/home/home_state.dart';

import 'shimmer/category_shimmer.dart';
import 'widgets/category_bar_item_three.dart';

class CategoryScreenThree extends StatelessWidget {
  final HomeState state;
  final HomeNotifier event;
  final RefreshController categoryController;
  final RefreshController restaurantController;

  const CategoryScreenThree(
      {super.key,
      required this.state,
      required this.event,
      required this.categoryController,
      required this.restaurantController,
     });

  @override
  Widget build(BuildContext context) {
    return state.isCategoryLoading
        ? const CategoryShimmerThree()
        : Container(
            height: state.categories.isNotEmpty ? 40.r : 0,
            margin:
                EdgeInsets.only(bottom: state.categories.isNotEmpty ? 16.h : 0),
            child: SmartRefresher(
              scrollDirection: Axis.horizontal,
              enablePullDown: false,
              enablePullUp: true,

              controller: categoryController,
              onLoading: () async {
                await event.fetchCategoriesPage(context, categoryController);
              },
              child: AnimationLimiter(
                child: ListView.builder(
                  padding: REdgeInsets.symmetric(horizontal: 12),
                  shrinkWrap: true,
                  
                  scrollDirection: Axis.horizontal,
                  itemCount:
                      state.isCategoryLoading ? 5 : state.categories.length,
                  itemBuilder: (context, index) {
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 375),
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                          child: CategoryBarItemThree(
                            image: state.categories[index].img ?? "",
                            title: state.categories[index].translation?.title ??
                                "",
                            isActive: state.selectIndexCategory == index,
                            onTap: () {
                              event.setSelectCategory(index, context);
                              restaurantController.resetNoData();
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
  }
}
