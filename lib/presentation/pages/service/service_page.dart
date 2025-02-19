import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:foodyman/application/home/home_provider.dart';
import 'package:foodyman/infrastructure/services/app_helpers.dart';
import 'package:foodyman/infrastructure/services/tr_keys.dart';
import 'package:foodyman/presentation/components/app_bars/common_app_bar.dart';
import 'package:foodyman/presentation/routes/app_router.dart';
import 'package:foodyman/presentation/theme/app_style.dart';

import 'widgets/service_two_categories_item.dart';

class ServicePage extends StatefulWidget {
  const ServicePage({super.key});

  @override
  State<ServicePage> createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {
  late RefreshController categoryController;

  @override
  void initState() {
    categoryController = RefreshController();
    super.initState();
  }

  @override
  void dispose() {
    categoryController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CommonAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
               SizedBox(width: 46.r,),
              const Spacer(),
              Text(
                AppHelpers.getTranslation(TrKeys.allServices),
                style: AppStyle.interNoSemi(),
              ),
              const Spacer(),
              IconButton(onPressed: (){
                context.pushRoute( SearchRoute());
              }, icon: const Icon(FlutterRemix.search_2_line)),
            ],
          ),
        ),
        Expanded(
          child: Consumer(builder: (context, ref, child) {
            final state = ref.watch(homeProvider);
            final notifier = ref.read(homeProvider.notifier);
            return SmartRefresher(
              scrollDirection: Axis.vertical,
              enablePullDown: false,
              enablePullUp: true,
              controller: categoryController,
              onLoading: () async {
                await notifier.fetchCategoriesPage(context, categoryController);
              },
              child: GridView.custom(
                physics: const BouncingScrollPhysics(),
                padding: REdgeInsets.symmetric(horizontal: 16, vertical: 12),
                gridDelegate: SliverQuiltedGridDelegate(
                  crossAxisCount: 3,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  repeatPattern: QuiltedGridRepeatPattern.same,
                  pattern: [
                    const QuiltedGridTile(1, 2),
                    const QuiltedGridTile(1, 1),
                    const QuiltedGridTile(1, 1),
                    const QuiltedGridTile(1, 2),
                  ],
                ),
                childrenDelegate: SliverChildBuilderDelegate(
                  childCount: state.categories.length,
                  (context, index) => ServiceTwoCategoriesItem(
                    category: state.categories[index],
                    onTap: () async {
                      if (state.selectIndexCategory != index) {
                        notifier.setSelectCategory(index, context);
                      }

                      context.pushRoute(ServiceTwoCategoryRoute(index: index));
                    },
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
