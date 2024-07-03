// ignore_for_file: prefer_interpolation_to_compose_strings, use_build_context_synchronously
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:riverpodtemp/application/app_widget/app_provider.dart';
import 'package:riverpodtemp/application/profile/profile_provider.dart';
import 'package:riverpodtemp/domain/di/dependency_manager.dart';
import 'package:riverpodtemp/infrastructure/models/data/address_information.dart';
import 'package:riverpodtemp/infrastructure/models/data/address_new_data.dart';
import 'package:riverpodtemp/infrastructure/services/app_constants.dart';
import 'package:riverpodtemp/infrastructure/services/app_helpers.dart';
import 'package:riverpodtemp/infrastructure/services/local_storage.dart';
import 'package:riverpodtemp/infrastructure/services/tpying_delay.dart';
import 'package:riverpodtemp/infrastructure/services/tr_keys.dart';
import 'package:riverpodtemp/presentation/components/buttons/custom_button.dart';
import 'package:riverpodtemp/presentation/components/buttons/pop_button.dart';
import 'package:riverpodtemp/presentation/components/keyboard_dismisser.dart';
import 'package:riverpodtemp/presentation/pages/view_map/view_map_modal.dart';
import 'package:riverpodtemp/presentation/routes/app_router.dart';
import 'package:riverpodtemp/presentation/theme/theme.dart';
import '../../../../application/map/view_map_notifier.dart';
import '../../../../application/map/view_map_provider.dart';


@RoutePage()
class ViewMapPage extends ConsumerStatefulWidget {
  final bool isShopLocation;
  final bool isPop;
  final bool isParcel;
  final int? shopId;
  final int? indexAddress;
  final AddressNewModel? address;

  const ViewMapPage({
    super.key,
    this.isParcel = false,
    this.isPop = true,
    this.isShopLocation = false,
    this.shopId,
    this.indexAddress,
    this.address,
  });

  @override
  ConsumerState<ViewMapPage> createState() => _ViewMapPageState();
}

class _ViewMapPageState extends ConsumerState<ViewMapPage> {
  late ViewMapNotifier event;
  late TextEditingController controller;
  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
  GoogleMapController? googleMapController;
  CameraPosition? cameraPosition;
  dynamic check;
  late LatLng latLng;
  final Delayed delayed = Delayed(milliseconds: 700);

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    event = ref.read(viewMapProvider.notifier);
    super.didChangeDependencies();
  }

  checkPermission() async {
    check = await _geolocatorPlatform.checkPermission();
  }

  Future<void> getMyLocation() async {
    if (check == LocationPermission.denied ||
        check == LocationPermission.deniedForever) {
      check = await Geolocator.requestPermission();
      if (check != LocationPermission.denied &&
          check != LocationPermission.deniedForever) {
        var loc = await Geolocator.getCurrentPosition();
        latLng = LatLng(loc.latitude, loc.longitude);
        googleMapController!
            .animateCamera(CameraUpdate.newLatLngZoom(latLng, 15));
      }
    } else {
      if (check != LocationPermission.deniedForever) {
        var loc = await Geolocator.getCurrentPosition();
        latLng = LatLng(loc.latitude, loc.longitude);
        googleMapController!
            .animateCamera(CameraUpdate.newLatLngZoom(latLng, 15));
      }
    }
  }

  @override
  void initState() {
    controller = TextEditingController();
    latLng = LatLng(
      widget.address?.location?.first ??
          LocalStorage.getAddressSelected()?.location?.latitude ??
          (AppHelpers.getInitialLatitude() ?? AppConstants.demoLatitude),
      widget.address?.location?.last ??
          LocalStorage.getAddressSelected()?.location?.longitude ??
          (AppHelpers.getInitialLongitude() ?? AppConstants.demoLongitude),
    );
    checkPermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(viewMapProvider);
    final bool isLtr = LocalStorage.getLangLtr();
    final bool isDarkMode = ref.watch(appProvider).isDarkMode;
    return KeyboardDismisser(
      child: Directionality(
        textDirection: isLtr ? TextDirection.ltr : TextDirection.rtl,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: isDarkMode ? AppStyle.mainBackDark : AppStyle.mainBack,
          body: SizedBox(
            width: MediaQuery.sizeOf(context).width,
            height: MediaQuery.sizeOf(context).height,
            child: Stack(
              children: [
                SizedBox(
                  width: MediaQuery.sizeOf(context).width,
                  height: state.isScrolling
                      ? MediaQuery.sizeOf(context).height
                      : MediaQuery.sizeOf(context).height - 0.r,
                  child: GoogleMap(
                    onCameraMoveStarted: () {
                      ref.read(viewMapProvider.notifier).scrolling(true);
                    },
                    myLocationButtonEnabled: false,
                    initialCameraPosition: CameraPosition(
                      bearing: 0,
                      target: latLng,
                      tilt: 0,
                      zoom: 17,
                    ),
                    mapToolbarEnabled: false,
                    zoomControlsEnabled: false,
                    onTap: (position) {
                      event.updateActive();
                      delayed.run(() async {
                        try {
                          final List<Placemark> placemarks =
                              await placemarkFromCoordinates(
                            cameraPosition?.target.latitude ?? latLng.latitude,
                            cameraPosition?.target.longitude ??
                                latLng.longitude,
                          );

                          if (placemarks.isNotEmpty) {
                            final Placemark pos = placemarks[0];
                            final List<String> addressData = [];
                            addressData.add(pos.locality!);
                            if (pos.subLocality != null &&
                                pos.subLocality!.isNotEmpty) {
                              addressData.add(pos.subLocality!);
                            }
                            if (pos.thoroughfare != null &&
                                pos.thoroughfare!.isNotEmpty) {
                              addressData.add(pos.thoroughfare!);
                            }
                            addressData.add(pos.name!);
                            final String placeName = addressData.join(', ');
                            controller.text = placeName;
                          }
                        } catch (e) {
                          controller.text = '';
                        }

                        event
                          ..checkDriverZone(
                              context: context,
                              location: LatLng(
                                cameraPosition?.target.latitude ??
                                    latLng.latitude,
                                cameraPosition?.target.longitude ??
                                    latLng.longitude,
                              ),
                              shopId: widget.shopId)
                          ..changePlace(
                            AddressNewModel(
                              address:
                                  AddressInformation(address: controller.text),
                              location: [
                                cameraPosition?.target.latitude ??
                                    latLng.latitude,
                                cameraPosition?.target.longitude ??
                                    latLng.longitude
                              ],
                            ),
                          );
                      });
                      googleMapController!.animateCamera(
                          CameraUpdate.newLatLngZoom(position, 15));
                    },
                    onCameraIdle: () {
                      event.updateActive();
                      delayed.run(() async {
                        try {
                          final List<Placemark> placemarks =
                              await placemarkFromCoordinates(
                            cameraPosition?.target.latitude ?? latLng.latitude,
                            cameraPosition?.target.longitude ??
                                latLng.longitude,
                          );

                          if (placemarks.isNotEmpty) {
                            final Placemark pos = placemarks[0];
                            final List<String> addressData = [];
                            addressData.add(pos.locality!);
                            if (pos.subLocality != null &&
                                pos.subLocality!.isNotEmpty) {
                              addressData.add(pos.subLocality!);
                            }
                            if (pos.thoroughfare != null &&
                                pos.thoroughfare!.isNotEmpty) {
                              addressData.add(pos.thoroughfare!);
                            }
                            addressData.add(pos.name!);
                            final String placeName = addressData.join(', ');
                            controller.text = placeName;
                          }
                        } catch (e) {
                          controller.text = '';
                        }

                        if (!widget.isShopLocation) {
                          event
                            ..checkDriverZone(
                                context: context,
                                location: LatLng(
                                  cameraPosition?.target.latitude ??
                                      latLng.latitude,
                                  cameraPosition?.target.longitude ??
                                      latLng.longitude,
                                ),
                                shopId: widget.shopId)
                            ..changePlace(
                              AddressNewModel(
                                address: AddressInformation(
                                    address: controller.text),
                                location: [
                                  cameraPosition?.target.latitude ??
                                      latLng.latitude,
                                  cameraPosition?.target.longitude ??
                                      latLng.longitude
                                ],
                              ),
                            );
                        } else {
                          event.changePlace(
                            AddressNewModel(
                              address:
                                  AddressInformation(address: controller.text),
                              location: [
                                cameraPosition?.target.latitude ??
                                    latLng.latitude,
                                cameraPosition?.target.longitude ??
                                    latLng.longitude
                              ],
                            ),
                          );
                        }
                        ref.read(viewMapProvider.notifier).scrolling(false);
                      });
                    },
                    onCameraMove: (position) {
                      cameraPosition = position;
                    },
                    onMapCreated: (controller) {
                      googleMapController = controller;
                    },
                  ),
                ),
                AnimatedPositioned(
                  bottom: MediaQuery.paddingOf(context).bottom +
                      (MediaQuery.sizeOf(context).height / 2),
                  left: MediaQuery.sizeOf(context).width / 2 - 23.w,
                  duration: const Duration(milliseconds: 500),
                  child: Image.asset(
                    "assets/images/marker.png",
                    width: 46.w,
                    height: 46.h,
                  ),
                ),
                AnimatedPositioned(
                  top: MediaQuery.paddingOf(context).top + 24,
                  left: 24,
                  right: 24,
                  duration: const Duration(milliseconds: 500),
                  child: Center(
                    child: Text(
                      controller.text,
                      style: AppStyle.interNormal(size: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 500),
                  bottom: 94.r,
                  right: state.isScrolling ? -100 : 16.w,
                  child: InkWell(
                    onTap: () async {
                      await getMyLocation();
                    },
                    child: Container(
                      width: 50.r,
                      height: 50.r,
                      decoration: BoxDecoration(
                          color: AppStyle.white,
                          borderRadius: BorderRadius.all(Radius.circular(10.r)),
                          boxShadow: [
                            BoxShadow(
                                color: AppStyle.shimmerBase,
                                blurRadius: 2,
                                offset: const Offset(0, 2))
                          ]),
                      child: const Center(
                          child: Icon(FlutterRemix.navigation_line)),
                    ),
                  ),
                ),
                if (widget.address != null &&
                    !(widget.address?.active ?? false))
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 500),
                    top: 32.r,
                    right: state.isScrolling ? -100 : 16.w,
                    child: InkWell(
                      onTap: () async {
                        ref.read(profileProvider.notifier).deleteAddress(
                            index: widget.indexAddress ?? 0,
                            id: widget.address?.id);
                        context.popRoute();
                      },
                      child: Container(
                        width: 48.r,
                        height: 48.r,
                        decoration: BoxDecoration(
                            color: AppStyle.red,
                            borderRadius:
                                BorderRadius.all(Radius.circular(24.r)),
                            boxShadow: [
                              BoxShadow(
                                  color: AppStyle.shimmerBase,
                                  blurRadius: 2,
                                  offset: const Offset(0, 2))
                            ]),
                        child: const Center(
                            child: Icon(
                          FlutterRemix.delete_bin_fill,
                          color: AppStyle.white,
                        )),
                      ),
                    ),
                  ),
                AnimatedPositioned(
                  left: 16,
                  right: 16,
                  bottom: 32,
                  duration: const Duration(milliseconds: 500),
                  child: Row(
                    children: [
                      if (widget.isPop)
                        Padding(
                          padding: REdgeInsets.only(right: 8),
                          child: const PopButton(),
                        ),
                      Expanded(
                        child: Opacity(
                          opacity: state.isScrolling ? 0.5 : 1,
                          child: CustomButton(
                            isLoading:controller.text.isEmpty ,
                            title: AppHelpers.getTranslation(TrKeys.apply),
                            onPressed: () {

                              if(widget.isParcel){
                                Navigator.pop(context,AddressNewModel(
                                  address: AddressInformation(
                                      address: controller.text),
                                  location: [
                                    cameraPosition
                                        ?.target.latitude ??
                                        latLng.latitude,
                                    cameraPosition
                                        ?.target.longitude ??
                                        latLng.longitude
                                  ],
                                ));
                                return;
                              }
                              if (!state.isScrolling) {
                                AppHelpers.showCustomModalBottomSheet(
                                  paddingTop: -50,
                                    context: context,
                                    modal: ViewMapModal(
                                      controller: controller,
                                      address: widget.address,
                                      latLng: latLng,
                                      isShopLocation: widget.isShopLocation,
                                      onSearch: () async {
                                        final placeId = await context
                                            .pushRoute(const MapSearchRoute());
                                        if (placeId != null) {
                                          final res = await googlePlace.details
                                              .get(placeId.toString());
                                          try {
                                            final List<Placemark> placemarks =
                                                await placemarkFromCoordinates(
                                              res?.result?.geometry?.location
                                                      ?.lat ??
                                                  latLng.latitude,
                                              res?.result?.geometry?.location
                                                      ?.lng ??
                                                  latLng.longitude,
                                            );

                                            if (placemarks.isNotEmpty) {
                                              final Placemark pos =
                                                  placemarks[0];
                                              final List<String> addressData =
                                                  [];
                                              addressData.add(pos.locality!);
                                              if (pos.subLocality != null &&
                                                  pos.subLocality!.isNotEmpty) {
                                                addressData
                                                    .add(pos.subLocality!);
                                              }
                                              if (pos.thoroughfare != null &&
                                                  pos.thoroughfare!
                                                      .isNotEmpty) {
                                                addressData
                                                    .add(pos.thoroughfare!);
                                              }
                                              addressData.add(pos.name!);
                                              final String placeName =
                                                  addressData.join(', ');
                                              controller.text = placeName;
                                            }
                                          } catch (e) {
                                            controller.text = '';
                                          }

                                          googleMapController!.animateCamera(
                                              CameraUpdate.newLatLngZoom(
                                                  LatLng(
                                                      res?.result?.geometry
                                                              ?.location?.lat ??
                                                          latLng.latitude,
                                                      res?.result?.geometry
                                                              ?.location?.lng ??
                                                          latLng.longitude),
                                                  15));
                                          event.changePlace(
                                            AddressNewModel(
                                              address: AddressInformation(
                                                  address: controller.text),
                                              location: [
                                                cameraPosition
                                                        ?.target.latitude ??
                                                    latLng.latitude,
                                                cameraPosition
                                                        ?.target.longitude ??
                                                    latLng.longitude
                                              ],
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                    isDarkMode: isDarkMode);
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
