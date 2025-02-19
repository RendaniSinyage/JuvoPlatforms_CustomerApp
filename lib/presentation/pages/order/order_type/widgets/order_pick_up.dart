import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:foodyman/application/order/order_provider.dart';
import 'package:foodyman/app_constants.dart';
import 'package:foodyman/infrastructure/services/app_helpers.dart';
import 'package:foodyman/presentation/components/select_item.dart';
import 'package:foodyman/presentation/components/title_icon.dart';
import 'package:foodyman/presentation/theme/app_style.dart';
import 'package:foodyman/infrastructure/services/tr_keys.dart';
import 'order_container.dart';

class OrderPickUp extends ConsumerStatefulWidget {
  const OrderPickUp({super.key});

  @override
  ConsumerState<OrderPickUp> createState() => _OrderPickUpState();
}

class _OrderPickUpState extends ConsumerState<OrderPickUp> {
  @override
  build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 24.h),
      child: Column(
        children: [
          Consumer(builder: (context, ref, child) {
            return OrderContainer(
              onTap: () {
                if (ref.watch(orderProvider).branches?.isNotEmpty ?? false) {
                  AppHelpers.showCustomModalBottomSheet(
                    context: context,
                    modal: Container(
                      decoration: BoxDecoration(
                        color: AppStyle.white,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(24.r),
                            topLeft: Radius.circular(24.r)),
                      ),
                      child: Column(
                        children: [
                          24.verticalSpace,
                          TitleAndIcon(
                              title:
                                  AppHelpers.getTranslation(TrKeys.branches)),
                          16.verticalSpace,
                          Expanded(
                            child: Consumer(builder: (context, ref, child) {
                              return ListView.builder(
                                itemBuilder: (context, index) {
                                  return SelectItem(
                                      onTap: () {
                                        ref
                                            .read(orderProvider.notifier)
                                            .changeBranch(index);
                                      },
                                      isActive: ref
                                              .watch(orderProvider)
                                              .branchIndex ==
                                          index,
                                      desc: ref
                                              .watch(orderProvider)
                                              .branches?[index]
                                              .address
                                              ?.address ??
                                          "",
                                      title: ref
                                              .watch(orderProvider)
                                              .branches?[index]
                                              .translation
                                              ?.title ??
                                          "");
                                },
                                itemCount:
                                    ref.watch(orderProvider).branches?.length ??
                                        0,
                                shrinkWrap: true,
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                    isDarkMode: false,
                  );
                }
              },
              icon: Padding(
                padding: EdgeInsets.only(left: 4.w),
                child: SvgPicture.asset(
                  "assets/svgs/adress.svg",
                  width: 20.w,
                  height: 20.h,
                ),
              ),
              title: AppHelpers.getTranslation(TrKeys.deliveryAddress),
              description:
                  ref.watch(orderProvider).shopData?.translation?.address ?? '',
            );
          }),
          10.verticalSpace,
          Consumer(builder: (context, ref, child) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: SizedBox(
                height: 300.r,
                width: double.infinity,
                child: GoogleMap(
                  padding: REdgeInsets.only(bottom: 12,left: 4),
                  myLocationButtonEnabled: false,
                  markers: ref.watch(orderProvider).shopMarkers,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                      ref.read(orderProvider).shopData?.location?.latitude ??
                          AppConstants.demoLatitude,
                      ref.read(orderProvider).shopData?.location?.longitude ??
                          AppConstants.demoLongitude,
                    ),
                    zoom: 14,
                  ),
                  mapToolbarEnabled: false,
                  zoomControlsEnabled: false,
                ),
              ),
            );
          })
        ],
      ),
    );
  }
}
