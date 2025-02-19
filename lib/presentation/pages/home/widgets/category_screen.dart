import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:foodyman/application/home/home_notifier.dart';
import 'package:foodyman/application/home/home_state.dart';
import '../shimmer/category_shimmer.dart';
import 'tab_bar_item.dart';

class CategoryScreen extends StatelessWidget {
  final HomeState state;
  final HomeNotifier event;
  final RefreshController categoryController;
  final RefreshController restaurantController;

  const CategoryScreen(
      {super.key,
      required this.state,
      required this.event,
      required this.categoryController,
      required this.restaurantController,
  });

  @override
  Widget build(BuildContext context) {
    return state.isCategoryLoading
        ? const CategoryShimmer()
        : Container(
            height: state.categories.isNotEmpty ? 90.h : 0,
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
                  padding: EdgeInsets.only(left: 16.r),
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
                          child:  CategoryBarItem(
                            index: index,
                            image: state.categories[index].img ?? "",
                            title: state.categories[index].translation?.title ?? "",
                            isActive: state.selectIndexCategory == index,
                            onTap: () {
                              event.setSelectCategory(index, context);
                              restaurantController.resetNoData();
                            },
                          )),
                        ),
                    );
                  },
                ),
              ),
            ),
          );
  }
}
