import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:riverpodtemp/application/home/home_provider.dart';
import 'package:riverpodtemp/application/profile/profile_provider.dart';
import 'package:riverpodtemp/infrastructure/models/data/address_old_data.dart';
import 'package:riverpodtemp/infrastructure/models/data/location.dart';
import 'package:riverpodtemp/infrastructure/services/app_helpers.dart';
import 'package:riverpodtemp/infrastructure/services/local_storage.dart';
import 'package:riverpodtemp/infrastructure/services/tr_keys.dart';
import 'package:riverpodtemp/presentation/components/app_bars/common_app_bar.dart';
import 'package:riverpodtemp/presentation/components/buttons/custom_button.dart';
import 'package:riverpodtemp/presentation/components/buttons/pop_button.dart';
import 'package:riverpodtemp/presentation/components/select_address_item.dart';
import 'package:riverpodtemp/presentation/routes/app_router.dart';

import '../../theme/app_style.dart';


@RoutePage()
class AddressListPage extends StatefulWidget {
  const AddressListPage({super.key});

  @override
  State<AddressListPage> createState() => _AddressListPageState();
}

class _AddressListPageState extends State<AddressListPage> {
  final bool isLtr = LocalStorage.getLangLtr();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        final state = ref.watch(profileProvider).userData?.addresses ?? [];
        final event = ref.read(profileProvider.notifier);
        return Directionality(
          textDirection: isLtr ? TextDirection.ltr : TextDirection.rtl,
          child: Scaffold(
            backgroundColor: AppStyle.bgGrey,
            body: Column(
              children: [
                CommonAppBar(
                  child: Text(
                    AppHelpers.getTranslation(TrKeys.deliveryAddress),
                    style: AppStyle.interNoSemi(
                      size: 18,
                      color: AppStyle.black,
                    ),
                  ),
                ),
                ListView.builder(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.r, vertical: 24.r),
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: state.length,
                    itemBuilder: (context, index) {
                      return SelectAddressItem(
                        onTap: () {
                          event.change(index);
                        },
                        isActive:
                            ref.watch(profileProvider).selectAddress == index,
                        address: state[index],
                        update: () async {
                          await context.pushRoute(ViewMapRoute(
                              address: ref
                                  .watch(profileProvider)
                                  .userData
                                  ?.addresses?[index],
                              indexAddress: index));
                          if (context.mounted) {
                            ref
                                .read(profileProvider.notifier)
                                .fetchUser(context, onSuccess: () {
                              ref
                                  .read(profileProvider.notifier)
                                  .findSelectIndex();
                            });
                          }
                        },
                      );
                    }),
              ],
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                children: [
                  PopButton(
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  24.horizontalSpace,
                  Expanded(
                      child: CustomButton(
                          title: AppHelpers.getTranslation(TrKeys.addAddress),
                          onPressed: () {
                            context.pushRoute(ViewMapRoute());
                          })),
                  24.horizontalSpace,
                  Expanded(
                      child: CustomButton(
                          title: AppHelpers.getTranslation(TrKeys.save),
                          onPressed: () {
                            ref.read(profileProvider.notifier).setActiveAddress(
                                index: ref.watch(profileProvider).selectAddress,
                                id: ref
                                    .watch(profileProvider)
                                    .userData
                                    ?.addresses?[ref
                                        .watch(profileProvider)
                                        .selectAddress]
                                    .id);
                            LocalStorage.setAddressSelected(AddressData(
                                title: ref
                                        .watch(profileProvider)
                                        .userData
                                        ?.addresses?[ref
                                            .watch(profileProvider)
                                            .selectAddress]
                                        .title ??
                                    "",
                                address: ref
                                        .watch(profileProvider)
                                        .userData
                                        ?.addresses?[ref
                                            .watch(profileProvider)
                                            .selectAddress]
                                        .address
                                        ?.address ??
                                    "",
                                location: LocationModel(
                                    longitude: ref
                                        .watch(profileProvider)
                                        .userData
                                        ?.addresses?[ref
                                            .watch(profileProvider)
                                            .selectAddress]
                                        .location
                                        ?.last,
                                    latitude: ref
                                        .watch(profileProvider)
                                        .userData
                                        ?.addresses?[ref
                                            .watch(profileProvider)
                                            .selectAddress]
                                        .location
                                        ?.first)));
                            ref.read(homeProvider.notifier)
                              ..fetchBannerPage(context, RefreshController(),
                                  isRefresh: true)
                              ..fetchRestaurantPage(
                                  context, RefreshController(),
                                  isRefresh: true)
                              ..fetchShopPageRecommend(
                                  context, RefreshController(),
                                  isRefresh: true)
                              ..fetchShopPage(context, RefreshController(),
                                  isRefresh: true)
                              ..fetchStorePage(context, RefreshController(),
                                  isRefresh: true)
                              ..fetchRestaurantPageNew(
                                  context, RefreshController(),
                                  isRefresh: true)
                              ..fetchCategoriesPage(
                                  context, RefreshController(),
                                  isRefresh: true)
                              ..setAddress();
                            Navigator.pop(context);
                          }))
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
