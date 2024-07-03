import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:riverpodtemp/application/order/order_provider.dart';
import 'package:riverpodtemp/application/profile/profile_provider.dart';
import 'package:riverpodtemp/application/shop_order/shop_order_provider.dart';
import 'package:riverpodtemp/infrastructure/models/data/address_old_data.dart';
import 'package:riverpodtemp/infrastructure/models/data/location.dart';
import 'package:riverpodtemp/infrastructure/services/app_constants.dart';
import 'package:riverpodtemp/infrastructure/services/app_helpers.dart';
import 'package:riverpodtemp/infrastructure/services/local_storage.dart';
import 'package:riverpodtemp/infrastructure/services/tr_keys.dart';
import 'package:riverpodtemp/presentation/components/buttons/custom_button.dart';
import 'package:riverpodtemp/presentation/components/keyboard_dismisser.dart';
import 'package:riverpodtemp/presentation/components/title_icon.dart';
import 'package:riverpodtemp/presentation/routes/app_router.dart';
import 'package:riverpodtemp/presentation/theme/app_style.dart';

import '../../application/home/home_provider.dart';
import 'select_address_item.dart';

class SelectAddressScreen extends ConsumerStatefulWidget {
  final VoidCallback addAddress;

  const SelectAddressScreen({
    super.key,
    required this.addAddress,
  });

  @override
  ConsumerState<SelectAddressScreen> createState() =>
      _SelectAddressScreenState();
}

class _SelectAddressScreenState extends ConsumerState<SelectAddressScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(profileProvider.notifier).findSelectIndex();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bool isLtr = LocalStorage.getLangLtr();
    return Directionality(
      textDirection: isLtr ? TextDirection.ltr : TextDirection.rtl,
      child: KeyboardDismisser(
        child: Container(
          decoration: BoxDecoration(
              color: AppStyle.bgGrey.withOpacity(0.96),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                topRight: Radius.circular(16.r),
              )),
          width: double.infinity,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  8.verticalSpace,
                  Center(
                    child: Container(
                      height: 4.h,
                      width: 48.w,
                      decoration: BoxDecoration(
                          color: AppStyle.dragElement,
                          borderRadius:
                              BorderRadius.all(Radius.circular(40.r))),
                    ),
                  ),
                  24.verticalSpace,
                  TitleAndIcon(
                    title: AppHelpers.getTranslation(TrKeys.selectAddress),
                    paddingHorizontalSize: 0,
                    titleSize: 18,
                  ),
                  24.verticalSpace,
                  ListView.builder(
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: ref
                              .watch(profileProvider)
                              .userData
                              ?.addresses
                              ?.length ??
                          0,
                      itemBuilder: (context, index) {
                        return SelectAddressItem(
                          onTap: () {
                            ref.read(profileProvider.notifier).change(index);
                          },
                          isActive:
                              ref.watch(profileProvider).selectAddress == index,
                          address: ref
                              .watch(profileProvider)
                              .userData
                              ?.addresses?[index],
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
                  16.verticalSpace,
                  CustomButton(
                      background: AppStyle.white,
                      title: AppHelpers.getTranslation(TrKeys.addAddress),
                      onPressed: () {
                        widget.addAddress.call();
                      }),
                  16.verticalSpace,
                  CustomButton(
                      title: AppHelpers.getTranslation(TrKeys.save),
                      onPressed: () {
                        ref.read(profileProvider.notifier).setActiveAddress(
                            index: ref.watch(profileProvider).selectAddress,
                            id: ref
                                .watch(profileProvider)
                                .userData
                                ?.addresses?[
                                    ref.watch(profileProvider).selectAddress]
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
                          ..fetchRestaurantPage(context, RefreshController(),
                              isRefresh: true)
                          ..fetchShopPageRecommend(context, RefreshController(),
                              isRefresh: true)
                          ..fetchShopPage(context, RefreshController(),
                              isRefresh: true)
                          ..fetchStorePage(context, RefreshController(),
                              isRefresh: true)
                          ..fetchRestaurantPageNew(context, RefreshController(),
                              isRefresh: true)
                          ..fetchCategoriesPage(context, RefreshController(),
                              isRefresh: true)
                          ..setAddress();
                        ref.read(orderProvider.notifier).getCalculate(
                            context: context,
                            isLoading: false,
                            cartId: ref.read(shopOrderProvider).cart?.id ?? 0,
                            long: LocalStorage.getAddressSelected()
                                    ?.location
                                    ?.longitude ??
                                AppConstants.demoLongitude,
                            lat: LocalStorage.getAddressSelected()
                                    ?.location
                                    ?.latitude ??
                                AppConstants.demoLatitude,
                            type: ref.read(orderProvider).tabIndex == 1
                                ? DeliveryTypeEnum.pickup
                                : DeliveryTypeEnum.delivery);
                        context.popRoute();
                      }),
                  32.verticalSpace,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
