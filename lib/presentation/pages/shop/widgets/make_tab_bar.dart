import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:riverpodtemp/infrastructure/models/models.dart';
import 'package:riverpodtemp/infrastructure/services/app_helpers.dart';
import 'package:riverpodtemp/infrastructure/services/tr_keys.dart';
import 'package:riverpodtemp/presentation/routes/app_router.dart';
import 'package:riverpodtemp/presentation/theme/theme.dart';

import 'shop_tab_bar_item.dart';

Widget makeTabBarHeader(
    {TabController? tabController,
      ValueChanged<int>? onTab,
      int index = 0,
      bool category = false,
      required String shopId,
      required String? cartId,
      required bool isPopularProduct,
      required List<CategoryData>? list,
      required BuildContext context}) {
  return Container(
    color: AppStyle.white,
    height: 110.h,
    width: double.infinity,
    child: Container(
      decoration: BoxDecoration(
          color: AppStyle.bgGrey,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.w), topRight: Radius.circular(16.w))),
      child: ListView(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        children: [
          TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            onTap: (e) {
              onTab?.call(e);
            },
            padding: EdgeInsets.only(left: 24.r),
            labelPadding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            isScrollable: true,
            indicatorPadding: EdgeInsets.zero,
            indicatorColor: AppStyle.transparent,
            labelColor: AppStyle.brandGreen,
            unselectedLabelColor: AppStyle.white,
            controller: tabController,
            tabs: isPopularProduct
                ? [
              ShopTabBarItem(
                  image: "",
                  title: AppHelpers.getTranslation(TrKeys.popular),
                  onTap: () {
                    tabController?.index = 0;
                    onTab?.call(0);
                  },
                  isActive: index == 0),
              ShopTabBarItem(
                  image: "",
                  onTap: () {
                    tabController?.index = 1;
                    onTab?.call(1);
                  },
                  title: AppHelpers.getTranslation(TrKeys.all),
                  isActive: index == 1),
              if (!category)
                ...list!.map(
                      (e) => ShopTabBarItem(
                    onTap: () {
                      tabController?.index = (list.indexOf(e) + 2);
                      onTab?.call(list.indexOf(e) + 2);
                    },
                    title: e.translation?.title ?? "",
                    isActive: index == (list.indexOf(e) + 2),
                    image: e.img ?? "",
                    category: e,
                  ),
                )
            ]
                : [
              ShopTabBarItem(
                  image: "",
                  onTap: () {
                    tabController?.index = 0;
                    onTab?.call(0);
                  },
                  title: AppHelpers.getTranslation(TrKeys.all),
                  isActive: index == 0),
              if (!category)
                ...list!.map(
                      (e) => ShopTabBarItem(
                    title: e.translation?.title ?? "",
                    isActive: index == (list.indexOf(e) + 1),
                    image: e.img ?? "",
                    category: e,
                    onTap: () {
                      tabController?.index = (list.indexOf(e) + 1);
                      onTab?.call(list.indexOf(e) + 1);
                    },
                  ),
                )
            ],
          ),
          if (category)
            ...list!.map(
                  (e) => Padding(
                padding: EdgeInsets.symmetric(vertical: 20.r),
                child: ShopTabBarItem(
                  title: e.translation?.title ?? "",
                  isActive: index == (list.indexOf(e) + 2),
                  image: e.img ?? "",
                  category: e,
                  onTap: () {
                    context.pushRoute(SubCategoryRoute(
                        category: e, shopId: shopId, cartId: cartId));
                  },
                ),
              ),
            )
        ],
      ),
    ),
  );
}
