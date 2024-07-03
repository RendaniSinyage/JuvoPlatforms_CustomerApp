import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:riverpodtemp/application/home/home_notifier.dart';
import 'package:riverpodtemp/application/home/home_state.dart';

import 'shimmer/category_one_shimmer.dart';
import 'widget/category_one_item.dart';

class CategoryOne extends StatelessWidget {
  final HomeState state;
  final HomeNotifier event;
  final RefreshController categoryController;
  final RefreshController restaurantController;

  const CategoryOne(
      {super.key,
      required this.state,
      required this.event,
      required this.categoryController,
      required this.restaurantController,
 });

  @override
  Widget build(BuildContext context) {
    return state.isCategoryLoading
        ? const CategoryOneShimmer()
        : Container(
            height: state.categories.isNotEmpty ? 100.h : 0,
            margin:
                EdgeInsets.only(bottom: state.categories.isNotEmpty ? 26.h : 0),
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
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.only(left: 16.r),
                  itemCount:
                      state.isCategoryLoading ? 5 : state.categories.length,
                  itemBuilder: (context, index) {
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 375),
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                          child: CategoryOneItem(
                            index: index,
                            image: state.categories[index].img ?? "",
                            title: state.categories[index].translation?.title ?? "",
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
