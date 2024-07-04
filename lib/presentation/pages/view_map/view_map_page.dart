import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/services.dart' show rootBundle;
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
//import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:remixicon/remixicon.dart';
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
import 'package:riverpodtemp/application/map/view_map_notifier.dart';
import 'package:riverpodtemp/application/map/view_map_provider.dart';
import 'package:riverpodtemp/application/poidata/poi_data_provider.dart';
import 'package:riverpodtemp/infrastructure/models/data/poi_data.dart';
import 'package:lottie/lottie.dart' as lottie;




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

class _ViewMapPageState extends ConsumerState<ViewMapPage> with TickerProviderStateMixin {
  late final AnimationController _animationController = AnimationController(vsync: this);
  late ViewMapNotifier event;
  late TextEditingController controller;
  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
  GoogleMapController? googleMapController;
  CameraPosition? cameraPosition;
  dynamic check;
  late LatLng latLng;
  final Delayed delayed = Delayed(milliseconds: 700);
  Set<Marker> markers = {};
  String _nearestPOIInfo = '';

  @override
  void dispose() {
    controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    event = ref.read(viewMapProvider.notifier);
    super.didChangeDependencies();
  }

  bool _isPoiInRadius(POIData poi, LatLng location, double radius) {
    final double distance = GeolocatorPlatform.instance.distanceBetween(
      location.latitude,
      location.longitude,
      poi.latitude,
      poi.longitude,
    );
    return distance <= radius;
  }

  POIData? _findNearestPOI(LatLng currentLocation, List<POIData> poiData) {
    POIData? nearestPOI;
    double minDistance = double.infinity;

    for (var poi in poiData) {
      final distance = GeolocatorPlatform.instance.distanceBetween(
        currentLocation.latitude,
        currentLocation.longitude,
        poi.latitude,
        poi.longitude,
      );

      if (distance < minDistance && distance <= 1000) { // 1000 meters = 1 km
        minDistance = distance;
        nearestPOI = poi;
      }
    }

    return nearestPOI;
  }

  Future<Set<Marker>> _getMarkers(List<POIData> poiData) async {
    List<Future<Marker>> markerFutures = poiData.map((poi) async {
      // Load the PNG image
      final ByteData data = await rootBundle.load('assets/images/poi/${poi.pin}');
      final Uint8List bytes = data.buffer.asUint8List();

      // Decode the PNG image
      final ui.Codec codec = await ui.instantiateImageCodec(bytes);
      final ui.FrameInfo fi = await codec.getNextFrame();
      final ui.Image image = fi.image;

      // Create a canvas to draw on
      final pictureRecorder = ui.PictureRecorder();
      final canvas = Canvas(pictureRecorder);
      final paint = Paint();

      // Draw the original image
      canvas.drawImage(image, Offset.zero, paint);

      // Apply color filter
      paint.colorFilter = ColorFilter.mode(poi.titleColor.withOpacity(0.5),BlendMode.srcATop);
      //canvas.drawRect(Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()), paint);

      // Convert to image
      final ui.Image coloredImage = await pictureRecorder.endRecording().toImage(image.width, image.height);
      final ByteData? byteData = await coloredImage.toByteData(format: ui.ImageByteFormat.png);
      final Uint8List coloredImageData = byteData!.buffer.asUint8List();

      // Create BitmapDescriptor from the colored image
      final BitmapDescriptor customMarkerIcon = BitmapDescriptor.fromBytes(coloredImageData);

      return Marker(
        markerId: MarkerId(poi.name),
        position: LatLng(poi.latitude, poi.longitude),
        icon: customMarkerIcon,
        infoWindow: InfoWindow(title: '${poi.name}✅'),
        onTap: () {
          googleMapController?.showMarkerInfoWindow(MarkerId(poi.name));
        },
      );
    }).toList();

    List<Marker> markers = await Future.wait(markerFutures);
    return markers.toSet();
  }

  Future<void> _createMarkers() async {
    final poiData = ref.read(poiDataProvider);
    final cameraPosition = this.cameraPosition;

    if (cameraPosition != null) {
      final filteredPoiData = poiData.where((poi) {
        return _isPoiInRadius(
          poi,
          cameraPosition.target,
          1000, // 1000 meters = 1 km
        );
      }).toList();

      final markers = await _getMarkers(filteredPoiData);

      // Find the nearest POI
      final nearestPOI = _findNearestPOI(cameraPosition.target, filteredPoiData);

      setState(() {
        this.markers = markers;
        if (nearestPOI != null) {
          final distance = GeolocatorPlatform.instance.distanceBetween(
            cameraPosition.target.latitude,
            cameraPosition.target.longitude,
            nearestPOI.latitude,
            nearestPOI.longitude,
          ).round();
          _nearestPOIInfo = 'Nearest POI: ${nearestPOI.name} (${distance}m)';

          // Open the info window of the nearest POI
          WidgetsBinding.instance.addPostFrameCallback((_) {
            googleMapController?.showMarkerInfoWindow(MarkerId(nearestPOI.name));
          });
        } else {
          _nearestPOIInfo = '';
        }
      });
    }
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
        if (googleMapController != null) {
          await Future.delayed(const Duration(milliseconds: 500));
          googleMapController!.animateCamera(CameraUpdate.newLatLng(latLng));
        }
      }
    } else {
      if (check != LocationPermission.deniedForever) {
        var loc = await Geolocator.getCurrentPosition();
        latLng = LatLng(loc.latitude, loc.longitude);
        if (googleMapController != null) {
          await Future.delayed(const Duration(milliseconds: 500));
          googleMapController!.animateCamera(CameraUpdate.newLatLng(latLng));
        }
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
    _createMarkers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(viewMapProvider);
    final poiData = ref.watch(poiDataProvider);
    final bool isLtr = LocalStorage.getLangLtr();
    final bool isDarkMode = ref.watch(appProvider).isDarkMode;

    return KeyboardDismisser(
      child: Directionality(
        textDirection: isLtr ? TextDirection.ltr : TextDirection.rtl,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: isDarkMode ? AppStyle.mainBackDark : AppStyle.mainBack,
          body: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: state.isScrolling
                      ? MediaQuery.of(context).size.height
                      : MediaQuery.of(context).size.height - 0.r,
                  child: GoogleMap(
                    onCameraMoveStarted: () {
                      ref.read(viewMapProvider.notifier).scrolling(true);
                      _animationController.repeat();
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
                            cameraPosition?.target.longitude ?? latLng.longitude,
                          );
                          if (placemarks.isNotEmpty) {
                            final Placemark pos = placemarks[0];
                            final List<String> addressData = [];
                            addressData.add(pos.locality!);
                            if (pos.subLocality != null && pos.subLocality!.isNotEmpty) {
                              addressData.add(pos.subLocality!);
                            }
                            if (pos.thoroughfare != null && pos.thoroughfare!.isNotEmpty) {
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
                              cameraPosition?.target.latitude ?? latLng.latitude,
                              cameraPosition?.target.longitude ?? latLng.longitude,
                            ),
                            shopId: widget.shopId,
                          )
                          ..changePlace(
                            AddressNewModel(
                              address: AddressInformation(address: controller.text),
                              location: [
                                cameraPosition?.target.latitude ?? latLng.latitude,
                                cameraPosition?.target.longitude ?? latLng.longitude,
                              ],
                            ),
                          );
                      });
                      googleMapController!.animateCamera(CameraUpdate.newLatLng(latLng));
                    },
                    onCameraIdle: () {
                      event.updateActive();
                      delayed.run(() async {
                        try {
                          final List<Placemark> placemarks =
                          await placemarkFromCoordinates(
                            cameraPosition?.target.latitude ?? latLng.latitude,
                            cameraPosition?.target.longitude ?? latLng.longitude,
                          );
                          if (placemarks.isNotEmpty) {
                            final Placemark pos = placemarks[0];
                            final List<String> addressData = [];
                            addressData.add(pos.locality!);
                            if (pos.subLocality != null && pos.subLocality!.isNotEmpty) {
                              addressData.add(pos.subLocality!);
                            }
                            if (pos.thoroughfare != null && pos.thoroughfare!.isNotEmpty) {
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
                                cameraPosition?.target.latitude ?? latLng.latitude,
                                cameraPosition?.target.longitude ?? latLng.longitude,
                              ),
                              shopId: widget.shopId,
                            )
                            ..changePlace(
                              AddressNewModel(
                                address: AddressInformation(address: controller.text),
                                location: [
                                  cameraPosition?.target.latitude ?? latLng.latitude,
                                  cameraPosition?.target.longitude ?? latLng.longitude,
                                ],
                              ),
                            );
                        } else {
                          event.changePlace(
                            AddressNewModel(
                              address: AddressInformation(address: controller.text),
                              location: [
                                cameraPosition?.target.latitude ?? latLng.latitude,
                                cameraPosition?.target.longitude ?? latLng.longitude,
                              ],
                            ),
                          );
                        }
                        ref.read(viewMapProvider.notifier).scrolling(false);
                      });
                      _animationController.forward(from: 0.0);
                    },
                    onCameraMove: (position) {
                      cameraPosition = position;
                      _createMarkers();
                    },
                    onMapCreated: (controller) {
                      googleMapController = controller;
                      _animationController.forward(from: 0.0);
                    },
                    markers: markers,
                  ),
                ),
                IgnorePointer(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        bottom: 78.0,
                      ),
                      child: lottie.Lottie.asset(
                        "assets/lottie/pin.json",
                        onLoaded: (composition) {
                          _animationController.duration = composition.duration;
                        },
                        controller: _animationController,
                        width: 250.w,
                        height: 250.h,
                      ),
                    ),
                  ),
                ),
                AnimatedPositioned(
                  top: MediaQuery.of(context).padding.top + 24,
                  left: 24,
                  right: 24,
                  duration: const Duration(milliseconds: 500),
                  child: Column(
                    children: [
                      5.verticalSpace,
                      Row(
                        children: [
                          10.horizontalSpace,
                          Container(
                            decoration: const BoxDecoration(
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                    color: AppStyle.textGrey,
                                    offset: Offset(0, 2),
                                    blurRadius: 2,
                                    spreadRadius: 0,
                                  ),
                                ],
                                shape: BoxShape.circle, color: AppStyle.white),
                            padding: EdgeInsets.all(10.r),
                            child: const Center(child: Icon(FlutterRemix.map_pin_range_line, size: 30)),
                          ),
                          6.horizontalSpace,
                          Container(
                            width: MediaQuery.of(context).size.width - 122,
                            height: 50.r,
                            padding: REdgeInsets.symmetric(horizontal: 15),
                            decoration: BoxDecoration(
                              boxShadow: const <BoxShadow>[
                                BoxShadow(
                                  color: AppStyle.textGrey,
                                  offset: Offset(0, 2),
                                  blurRadius: 2,
                                  spreadRadius: 0,
                                ),
                              ],
                              color: AppStyle.white,
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            child: Center(
                              child: Text(
                                controller.text,
                                style: AppStyle.interNormal(size: 16),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
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
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Center(child: Icon(FlutterRemix.navigation_line)),
                    ),
                  ),
                ),
                if (widget.address != null && !(widget.address?.active ?? false))
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 500),
                    top: 32.r,
                    right: state.isScrolling ? -100 : 16.w,
                    child: InkWell(
                      onTap: () async {
                        ref.read(profileProvider.notifier).deleteAddress(
                          index: widget.indexAddress ?? 0,
                          id: widget.address?.id,
                        );
                        context.popRoute();
                      },
                      child: Container(
                        width: 48.r,
                        height: 48.r,
                        decoration: BoxDecoration(
                          color: AppStyle.red,
                          borderRadius: BorderRadius.all(Radius.circular(24.r)),
                          boxShadow: [
                            BoxShadow(
                              color: AppStyle.shimmerBase,
                              blurRadius: 2,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Icon(
                            FlutterRemix.delete_bin_fill,
                            color: AppStyle.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                AnimatedPositioned(
                  left: 16,
                  right: 16,
                  bottom: 32,
                  duration: const Duration(milliseconds: 500),
                  child: Column(
                    children: [
                      // Inside the build method, add this before the CustomButton
                      if (_nearestPOIInfo.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.only(bottom: 8.r),
                          child: Text(
                            _nearestPOIInfo,
                            style: AppStyle.interNormal(size: 14, color: AppStyle.black),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      Row(
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
                                isLoading: controller.text.isEmpty,
                                title: AppHelpers.getTranslation(TrKeys.confirmLocation),
                                onPressed: () {
                                  if (widget.isParcel) {
                                    Navigator.pop(
                                      context,
                                      AddressNewModel(
                                        address: AddressInformation(address: controller.text),
                                        location: [
                                          cameraPosition?.target.latitude ??
                                              latLng.latitude,
                                          cameraPosition?.target.longitude ??
                                              latLng.longitude,
                                        ],
                                      ),
                                    );
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
                                                      latLng.longitude,
                                                ),
                                                15,
                                              ),
                                            );
                                            event.changePlace(
                                              AddressNewModel(
                                                address: AddressInformation(
                                                  address: controller.text,
                                                ),
                                                location: [
                                                  cameraPosition?.target.latitude ??
                                                      latLng.latitude,
                                                  cameraPosition?.target.longitude ??
                                                      latLng.longitude,
                                                ],
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                      isDarkMode: isDarkMode,
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
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