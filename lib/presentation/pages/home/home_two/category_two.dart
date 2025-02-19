import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:foodyman/application/home/home_notifier.dart';
import 'package:foodyman/application/home/home_state.dart';
import 'shimmer/category_two_shimmer.dart';
import 'widget/category_two_item.dart';

class CategoryTwo extends StatelessWidget {
  final HomeState state;
  final HomeNotifier event;
  final RefreshController categoryController;
  final VoidCallback onTap;


  const CategoryTwo(
      {super.key,
      required this.state,
      required this.event,
      required this.categoryController,
      required this.onTap,});

  @override
  Widget build(BuildContext context) {
    return state.isCategoryLoading
        ? const CategoryTwoShimmer()
        : SizedBox(
            height: state.categories.isNotEmpty ? 132.h : 0,
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
                  padding: EdgeInsets.only(left: 16.r, bottom: 16.r, top: 8.r),
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
                          child: CategoryTwoItem(
                                  index: index,
                                  image: state.categories[index].img ?? "",
                                  title: state.categories[index].translation
                                          ?.title ??
                                      "",
                                  isActive: state.selectIndexCategory == index,
                                  onTap: () {
                                    event.setSelectCategory(index, context);
                                    onTap.call();
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
