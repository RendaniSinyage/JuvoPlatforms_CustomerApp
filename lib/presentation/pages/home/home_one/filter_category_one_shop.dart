import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:foodyman/application/home/home_notifier.dart';
import 'package:foodyman/application/home/home_state.dart';
import 'package:foodyman/infrastructure/services/app_helpers.dart';
import 'package:foodyman/infrastructure/services/tr_keys.dart';
import 'package:foodyman/presentation/components/buttons/animation_button_effect.dart';
import 'package:foodyman/presentation/components/loading.dart';
import 'package:foodyman/presentation/components/tab_bar_item.dart';
import 'package:foodyman/presentation/components/title_icon.dart';
import 'package:foodyman/presentation/pages/home/filter/filter_page.dart';
import 'package:foodyman/presentation/pages/home/home_one/widget/market_one_item.dart';

import 'package:foodyman/presentation/theme/app_style.dart';

class FilterCategoryOneShop extends StatelessWidget {
  final HomeState state;
  final HomeNotifier event;
  final RefreshController shopController;

  const FilterCategoryOneShop(
      {super.key,
      required this.state,
      required this.event,
      required this.shopController});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 46.r,
          child: ListView.builder(
            padding: EdgeInsets.only(bottom: 8.r, left: 16.r),
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: (state.categories[state.selectIndexCategory].children?.length ?? 0) + 1,
            itemBuilder: (BuildContext context, int index) {
              final category = state.categories[state.selectIndexCategory];
              return index == 0
                  ? AnimationButtonEffect(
                    child: InkWell(
                      onTap: (){
                        AppHelpers.showCustomModalBottomDragSheet(
                          context: context,
                          modal: (c)=> FilterPage(controller: c,categoryId: (state
                              .selectIndexSubCategory != -1
                              ? (state
                              .categories[state
                              .selectIndexCategory]
                              .children?[state
                              .selectIndexSubCategory]
                              .id)
                              : state
                              .categories[state
                              .selectIndexCategory]
                              .id) ??
                              0,),
                          isDarkMode: false,
                          isDrag: false,
                          radius: 12,
                        );
                      },
                      child: Container(
                          margin: EdgeInsets.only(right: 8.r),
                          padding:
                              EdgeInsets.symmetric(horizontal: 16.r, vertical: 6.r),
                          decoration: BoxDecoration(
                              color: AppStyle.white,
                              borderRadius: BorderRadius.circular(10.r)),
                          child: Row(
                            children: [
                              SvgPicture.asset("assets/svgs/filter.svg"),
                              6.horizontalSpace,
                              Text(
                                AppHelpers.getTranslation(TrKeys.filter),
                                style: AppStyle.interNormal(
                                  size: 13,
                                  color: AppStyle.black,
                                ),
                              )
                            ],
                          ),
                        ),
                    ),
                  )
                  : TabBarItem(
                      isShopTabBar: index - 1 == state.selectIndexSubCategory,
                      title: category.children?[index - 1].translation?.title ??
                          "",
                      index: index - 1,
                      currentIndex: state.selectIndexSubCategory,
                      onTap: () =>
                          event.setSelectSubCategory(index - 1, context),
                    );
            },
          ),
        ),
        TitleAndIcon(
          title: AppHelpers.getTranslation(TrKeys.restaurants),
          rightTitle:
              "${AppHelpers.getTranslation(TrKeys.found)} ${state.totalShops} ${AppHelpers.getTranslation(TrKeys.results)}",
        ),
        state.isSelectCategoryLoading == -1
            ? const Loading()
            : state.filterShops.isNotEmpty
            ? ListView.builder(
                padding: EdgeInsets.only(top: 6.h),
                shrinkWrap: true,
                
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: state.filterShops.length,
                itemBuilder: (context, index) => MarketOneItem(
                  shop: state.filterShops[index],
                  isSimpleShop: true,
                ),
              )
            : Padding(
                padding: EdgeInsets.only(top: 24.h),
                child: Center(child: _resultEmpty()),
              ),
      ],
    );
  }
}

Widget _resultEmpty() {
  return Column(
    children: [
      Image.asset("assets/images/notFound.png"),
      Text(
        AppHelpers.getTranslation(TrKeys.nothingFound),
        style: AppStyle.interSemi(size: 18.sp),
      ),
      Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 32.w,
        ),
        child: Text(
          AppHelpers.getTranslation(TrKeys.trySearchingAgain),
          style: AppStyle.interRegular(size: 14.sp),
          textAlign: TextAlign.center,
        ),
      ),
    ],
  );
}
