
// ignore_for_file: deprecated_member_use

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:riverpodtemp/application/home/home_provider.dart';
import 'package:riverpodtemp/presentation/components/app_bars/common_app_bar.dart';
import 'package:riverpodtemp/presentation/components/buttons/pop_button.dart';
import 'package:riverpodtemp/presentation/theme/app_style.dart';

import 'filter_category_service.dart';

@RoutePage()
class ServiceTwoCategoryPage extends ConsumerStatefulWidget {
  final int index;
  const ServiceTwoCategoryPage({super.key, required this.index});

  @override
  ConsumerState<ServiceTwoCategoryPage> createState() => _ServiceTwoCategoryPageState();
}

class _ServiceTwoCategoryPageState extends ConsumerState<ServiceTwoCategoryPage> {
  final RefreshController _restaurantController = RefreshController();
  @override
  void dispose() {
    _restaurantController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homeProvider);
    final notifier = ref.read(homeProvider.notifier);
    final title = state.selectIndexCategory != -1
        ? state.categories[state.selectIndexCategory].translation?.title
        : "";
    return WillPopScope(
      onWillPop: (){
        notifier.setSelectCategory(-1, context);
        // context.popRoute();
        return Future.value(true);
      },
      child: Scaffold(
        body: Column(
          children: [
            CommonAppBar(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title ?? "",
                    style: AppStyle.interNormal(size: 18),
                  ),
                ],
              ),
            ),
            Expanded(
              child: FilterCategoryService(
                state: state,
                event: notifier,
                categoryIndex: widget.index, restaurantController: _restaurantController,
              ),
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        floatingActionButton: const PopButton(),
      ),
    );
  }
}
