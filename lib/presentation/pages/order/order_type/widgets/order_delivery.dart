import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:riverpodtemp/application/edit_profile/edit_profile_provider.dart';
import 'package:riverpodtemp/application/order/order_provider.dart';
import 'package:riverpodtemp/infrastructure/services/app_helpers.dart';
import 'package:riverpodtemp/infrastructure/services/app_validators.dart';
import 'package:riverpodtemp/infrastructure/services/local_storage.dart';
import 'package:riverpodtemp/infrastructure/services/tr_keys.dart';
import 'package:riverpodtemp/presentation/components/custom_checkbox.dart';
import 'package:riverpodtemp/presentation/components/text_fields/outline_bordered_text_field.dart';

import 'package:intl/intl.dart' as intl;
import 'package:riverpodtemp/presentation/pages/profile/phone_verify.dart';
import 'package:riverpodtemp/presentation/routes/app_router.dart';
import '../../order_check/widgets/time_delivery.dart';
import 'order_container.dart';
import '../../../../components/sellect_address_screen.dart';

class OrderDelivery extends StatefulWidget {
  final ValueChanged<bool> onChange;
  final VoidCallback getLocation;
  final int shopId;

  const OrderDelivery({
    super.key,
    required this.onChange,
    required this.getLocation,
    required this.shopId,
  });

  @override
  State<OrderDelivery> createState() => _OrderDeliveryState();
}

class _OrderDeliveryState extends State<OrderDelivery> {
  late TextEditingController houseController;
  late TextEditingController floorController;
  late TextEditingController commentController;
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController userPhoneNumber;

  @override
  void initState() {
    houseController = TextEditingController(
        text: LocalStorage.getAddressInformation()?.house);
    floorController = TextEditingController(
        text: LocalStorage.getAddressInformation()?.floor);
    commentController = TextEditingController();
    nameController = TextEditingController();
    phoneController = TextEditingController();
    userPhoneNumber = TextEditingController(text: LocalStorage.getPhone());
    super.initState();
  }

  @override
  void dispose() {
    houseController.dispose();
    floorController.dispose();
    commentController.dispose();
    nameController.dispose();
    phoneController.dispose();
    userPhoneNumber.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 24.h),
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Consumer(builder: (context, ref, child) {
          ref.listen(editProfileProvider, (previous, next) {
            if (next.isSuccess &&
                (next.isSuccess != (previous?.isSuccess ?? false))) {
              userPhoneNumber.text = next.userData?.phone ?? "";
            }
          });
          return Column(
            children: [
              OrderContainer(
                onTap: () async {
                  AppHelpers.showCustomModalBottomSheet(
                      context: context,
                      modal: SelectAddressScreen(
                        addAddress: () async {
                          await context
                              .pushRoute(ViewMapRoute(shopId: widget.shopId));
                          widget.getLocation();
                        },
                      ),
                      isDarkMode: false);
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
                description:  (LocalStorage.getAddressSelected()?.title?.isEmpty ??
                    true)
                    ? LocalStorage.getAddressSelected()?.address ?? ''
                    : LocalStorage.getAddressSelected()?.title ?? "",
              ),
              10.verticalSpace,
              OrderContainer(
                onTap: () {
                  AppHelpers.showCustomModalBottomSheet(
                    paddingTop: MediaQuery.of(context).padding.top + 150.h,
                    context: context,
                    modal: const TimeDelivery(),
                    isDarkMode: false,
                    isDrag: true,
                    radius: 12,
                  );
                },
                icon: const Icon(FlutterRemix.calendar_check_line),
                title: AppHelpers.getTranslation(TrKeys.timeDelivery),
                description: ref.watch(orderProvider).selectDate == null
                    ? AppHelpers.getTranslation(TrKeys.notWorkTodayAndTomorrow)
                    : "${intl.DateFormat("MMMM dd").format(ref.watch(orderProvider).selectDate!)}  ${ref.watch(orderProvider).selectTime.hour.toString().padLeft(2, '0')}:${ref.watch(orderProvider).selectTime.minute.toString().padLeft(2, '0')}",
              ),
              20.verticalSpace,
              OutlinedBorderTextField(
                label: AppHelpers.getTranslation(TrKeys.house).toUpperCase(),
                textController: houseController,
                onChanged: (s) {
                  ref.read(orderProvider.notifier).setAddressInfo(house: s);
                },
              ),
              16.verticalSpace,
              OutlinedBorderTextField(
                label: AppHelpers.getTranslation(TrKeys.floor).toUpperCase(),
                textController: floorController,
                onChanged: (s) {
                  ref.read(orderProvider.notifier).setAddressInfo(floor: s);
                },
              ),
              16.verticalSpace,
              OutlinedBorderTextField(
                label: AppHelpers.getTranslation(TrKeys.comment).toUpperCase(),
                textController: commentController,
                onChanged: (s) {
                  ref.read(orderProvider.notifier).setAddressInfo(note: s);
                },
              ),
              16.verticalSpace,
              Column(
                children: [
                  OutlinedBorderTextField(
                    label:
                        AppHelpers.getTranslation(TrKeys.phoneNumber).toUpperCase(),
                    textController: userPhoneNumber,
                    readOnly: true,
                    onTap: () {
                      AppHelpers.showCustomModalBottomSheet(
                          context: context,
                          modal: const PhoneVerify(),
                          isDarkMode: false,
                          paddingTop: MediaQuery.of(context).padding.top);
                    },
                  ),
                  16.verticalSpace,
                ],
              ),

              Row(
                children: [
                  CustomCheckbox(
                      isActive: ref.watch(orderProvider).sendOtherUser,
                      onTap: () {
                        ref
                            .read(orderProvider.notifier)
                            .checkBox(!ref.watch(orderProvider).sendOtherUser);
                      }),
                  12.horizontalSpace,
                  Text(
                      AppHelpers.getTranslation(TrKeys.iWantToOrderForSomeone)),
                ],
              ),
             if(ref.watch(orderProvider).sendOtherUser)
              Column(
                children: [
                  16.verticalSpace,
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedBorderTextField(
                          label: AppHelpers.getTranslation(TrKeys.firstname)
                              .toUpperCase(),
                          textController: nameController,
                          validation: AppValidators.isNotEmptyValidator,
                          onChanged: (s) {
                            ref.read(orderProvider.notifier).setUser(username: s);
                          },
                        ),
                      ),
                      16.horizontalSpace,
                      Expanded(
                        child: OutlinedBorderTextField(
                          label: AppHelpers.getTranslation(TrKeys.phoneNumber)
                              .toUpperCase(),
                          textController: phoneController,
                          inputType: TextInputType.phone,
                          validation: AppValidators.isNotEmptyValidator,
                          onChanged: (s) {
                            ref.read(orderProvider.notifier).setUser(phone: s);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ],
          );
        }),
      ),
    );
  }
}
