import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:riverpodtemp/application/home/home_provider.dart';
import 'package:riverpodtemp/application/map/view_map_provider.dart';
import 'package:riverpodtemp/application/profile/profile_provider.dart';
import 'package:riverpodtemp/infrastructure/models/data/address_information.dart';
import 'package:riverpodtemp/infrastructure/models/data/address_new_data.dart';
import 'package:riverpodtemp/infrastructure/models/data/address_old_data.dart';
import 'package:riverpodtemp/infrastructure/models/models.dart';
import 'package:riverpodtemp/infrastructure/services/app_helpers.dart';
import 'package:riverpodtemp/infrastructure/services/local_storage.dart';
import 'package:riverpodtemp/infrastructure/services/tr_keys.dart';
import 'package:riverpodtemp/presentation/components/buttons/custom_button.dart';
import 'package:riverpodtemp/presentation/components/text_fields/outline_bordered_text_field.dart';
import 'package:riverpodtemp/presentation/components/text_fields/search_text_field.dart';
import 'package:riverpodtemp/presentation/theme/theme.dart';

class ViewMapModal extends ConsumerStatefulWidget {
  final TextEditingController controller;
  final AddressNewModel? address;
  final LatLng latLng;
  final bool isShopLocation;
  final VoidCallback onSearch;

  const ViewMapModal({
    super.key,
    required this.controller,
    required this.address,
    required this.latLng,
    required this.isShopLocation,
    required this.onSearch,
  });

  @override
  ConsumerState<ViewMapModal> createState() => _ViewMapModalState();
}

class _ViewMapModalState extends ConsumerState<ViewMapModal> {
  late TextEditingController office;
  late TextEditingController house;
  late TextEditingController floor;
  final GlobalKey<FormState> fromKey = GlobalKey<FormState>();

  @override
  void initState() {
    office = TextEditingController(text: widget.address?.title);
    house = TextEditingController();
    floor = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    office.dispose();
    house.dispose();
    floor.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(viewMapProvider);
    final event = ref.read(viewMapProvider.notifier);
    return Container(
      margin: MediaQuery.viewInsetsOf(context),
      padding: EdgeInsets.symmetric(horizontal: 16.r),
      decoration: BoxDecoration(
          color: AppStyle.white,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(16.r), topLeft: Radius.circular(16.r))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          8.verticalSpace,
          Container(
            width: 49.w,
            height: 3.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40.r),
              color: AppStyle.dragElement,
            ),
          ),
          16.verticalSpace,
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              AppHelpers.getTranslation(TrKeys.enterADeliveryAddress),
              style: AppStyle.interNoSemi(size: 18),
            ),
          ),
          24.verticalSpace,
          SearchTextField(
            isRead: true,
            isBorder: true,
            textEditingController: widget.controller,
            onTap: () async {
              widget.onSearch();
            },
          ),
          24.verticalSpace,
          Form(
            key: fromKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                OutlinedBorderTextField(
                  textController: office,
                  label: AppHelpers.getTranslation(TrKeys.title).toUpperCase(),
                  validation: (s) {
                    if (s?.isEmpty ?? true) {
                      return AppHelpers.getTranslation(TrKeys.canNotBeEmpty);
                    } else {
                      return null;
                    }
                  },
                ),
                24.verticalSpace,
                Row(
                  children: [
                    Expanded(
                      child: OutlinedBorderTextField(
                        textController: house,
                        label: AppHelpers.getTranslation(TrKeys.house)
                            .toUpperCase(),
                      ),
                    ),
                    24.horizontalSpace,
                    Expanded(
                      child: OutlinedBorderTextField(
                        textController: floor,
                        label: AppHelpers.getTranslation(TrKeys.floor)
                            .toUpperCase(),
                      ),
                    ),
                  ],
                ),
                32.verticalSpace,
              ],
            ),
          ),
          Padding(
            padding: REdgeInsets.only(bottom: 28),
            child: CustomButton(
              isLoading: !widget.isShopLocation ? state.isLoading : false,
              background: !widget.isShopLocation
                  ? (state.isActive ? AppStyle.brandGreen : AppStyle.bgGrey)
                  : AppStyle.brandGreen,
              textColor: !widget.isShopLocation
                  ? (state.isActive ? AppStyle.black : AppStyle.textGrey)
                  : AppStyle.black,
              title: !widget.isShopLocation
                  ? (state.isActive
                      ? AppHelpers.getTranslation(TrKeys.apply)
                      : AppHelpers.getTranslation(TrKeys.noDriverZone))
                  : AppHelpers.getTranslation(TrKeys.apply),
              onPressed: () {
                if (widget.isShopLocation) {
                  Navigator.pop(context, state.place);
                } else {
                  if (state.isActive) {
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
                    LocalStorage.setAddressSelected(AddressData(
                        title: office.text,
                        address: state.place?.address?.address ?? "",
                        location: LocationModel(
                            latitude: state.place?.location?.first,
                            longitude: state.place?.location?.last)));
                    AddressInformation data = AddressInformation(
                        address: widget.controller.text,
                        house: house.text,
                        floor: floor.text);
                    LocalStorage.setAddressInformation(data);
                    if (LocalStorage.getToken().isEmpty) {
                      Navigator.pop(context);
                      Navigator.pop(context);
                      return;
                    }
                    if (widget.address == null) {
                      event.saveLocation(context, onSuccess: () {
                        ref.read(profileProvider.notifier).fetchUser(context);
                        ref.read(homeProvider.notifier).setAddress();
                        Navigator.pop(context);
                        Navigator.pop(context);
                      });
                    } else {
                      event.updateLocation(context, widget.address?.id,
                          onSuccess: () {
                        ref.read(profileProvider.notifier).fetchUser(context);
                        ref.read(homeProvider.notifier).setAddress();
                        Navigator.pop(context);
                        Navigator.pop(context);
                      });
                    }
                  } else {
                    AppHelpers.showCheckTopSnackBarInfo(
                      context,
                      AppHelpers.getTranslation(TrKeys.noDriverZone),
                    );
                  }
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
