import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:riverpodtemp/application/parcel/parcel_notifier.dart';
import 'package:riverpodtemp/application/parcel/parcel_state.dart';
import 'package:riverpodtemp/infrastructure/models/data/address_new_data.dart';
import 'package:riverpodtemp/infrastructure/services/app_helpers.dart';
import 'package:riverpodtemp/infrastructure/services/tr_keys.dart';
import 'package:riverpodtemp/presentation/components/buttons/animation_button_effect.dart';
import 'package:riverpodtemp/presentation/components/text_fields/outline_bordered_text_field.dart';
import 'package:riverpodtemp/presentation/routes/app_router.dart';
import 'package:riverpodtemp/presentation/theme/app_style.dart';

import '../../../../infrastructure/models/models.dart';
import 'custom_expanded.dart';

class RecipientWidget extends StatelessWidget {
  final ParcelState state;
  final ParcelNotifier event;
  final TextEditingController username;
  final TextEditingController phone;
  final TextEditingController house;
  final TextEditingController flour;
  final TextEditingController description;
  final TextEditingController addInstruction;
  final TextEditingController value;

  const RecipientWidget(
      {super.key,
      required this.state,
      required this.event,
      required this.username,
      required this.phone,
      required this.house,
      required this.flour,
      required this.description,
      required this.addInstruction,
      required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (state.expand)
          Padding(
            padding: EdgeInsets.only(bottom: 16.r),
            child: Text(AppHelpers.getTranslation(TrKeys.recipient),
                style: AppStyle.interNoSemi(size: 16)),
          ),
        InkWell(
          onTap: () async {
            final data =
                await context.pushRoute(ViewMapRoute(isShopLocation: true,isParcel: true));
            if (data.runtimeType == AddressNewModel) {
              if (context.mounted) {
                event.setToAddress(
                    title: (data as AddressNewModel).address?.address,
                    location: LocationModel(
                        latitude: data.location?.first,
                        longitude: data.location?.last),
                    context: context);
              }
            }
          },
          child: AnimationButtonEffect(
            child: Container(
              decoration: BoxDecoration(
                  color: AppStyle.bgGrey,
                  borderRadius: BorderRadius.circular(10.r)),
              padding: EdgeInsets.symmetric(horizontal: 20.r, vertical: 16.r),
              child: Row(
                children: [
                  const Icon(FlutterRemix.map_pin_range_line),
                  12.horizontalSpace,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (state.addressTo != null)
                        Text(
                          AppHelpers.getTranslation(TrKeys.deliveryTo),
                          style: AppStyle.interRegular(size: 12),
                        ),
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width / 2 - 20.r,
                        child: Text(
                          state.addressTo ??
                              AppHelpers.getTranslation(TrKeys.deliveryTo),
                          style: AppStyle.interSemi(size: 16),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  const Icon(
                    FlutterRemix.arrow_right_s_line,
                  )
                ],
              ),
            ),
          ),
        ),
        ExpandedSection(
          expand: state.expand,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              24.verticalSpace,
              OutlinedBorderTextField(
                inputType: TextInputType.phone,
                label: AppHelpers.getTranslation(TrKeys.phoneNumber),
                textController: phone,
                validation: (s) {
                  if (s?.isNotEmpty ?? false) {
                    return null;
                  }
                  return AppHelpers.getTranslation(TrKeys.canNotBeEmpty);
                },
              ),
              16.verticalSpace,
              OutlinedBorderTextField(
                label: AppHelpers.getTranslation(TrKeys.fullName),
                textController: username,
                validation: (s) {
                  if (s?.isNotEmpty ?? false) {
                    return null;
                  }
                  return AppHelpers.getTranslation(TrKeys.canNotBeEmpty);
                },
              ),
              16.verticalSpace,
              OutlinedBorderTextField(
                label: AppHelpers.getTranslation(TrKeys.house),
                textController: house,
              ),
              16.verticalSpace,
              OutlinedBorderTextField(
                label: AppHelpers.getTranslation(TrKeys.floor),
                textController: flour,
              ),
              16.verticalSpace,
              OutlinedBorderTextField(
                label: AppHelpers.getTranslation(TrKeys.addInstruction),
                textController: addInstruction,
              ),
              24.verticalSpace,
              Text(AppHelpers.getTranslation(TrKeys.itemDescription),
                  style: AppStyle.interNoSemi(size: 16)),
              16.verticalSpace,
              TextFormField(
                autocorrect: true,
                controller: description,
                decoration: InputDecoration(
                  fillColor: AppStyle.bgGrey,
                  filled: true,
                  hintText: AppHelpers.getTranslation(TrKeys.whatAreYouSending),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide.merge(
                          const BorderSide(color: AppStyle.transparent),
                          const BorderSide(color: AppStyle.transparent))),
                  errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide.merge(
                          const BorderSide(color: AppStyle.transparent),
                          const BorderSide(color: AppStyle.transparent))),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide.merge(
                          const BorderSide(color: AppStyle.transparent),
                          const BorderSide(color: AppStyle.transparent))),
                  focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide.merge(
                          const BorderSide(color: AppStyle.transparent),
                          const BorderSide(color: AppStyle.transparent))),
                  disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide.merge(
                          const BorderSide(color: AppStyle.transparent),
                          const BorderSide(color: AppStyle.transparent))),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide.merge(
                          const BorderSide(color: AppStyle.transparent),
                          const BorderSide(color: AppStyle.transparent))),
                ),
              ),
              16.verticalSpace,
              if (state.types.isNotEmpty)
                if ((state.types[state.selectType]?.options?.isNotEmpty ??
                    false))
                  SizedBox(
                    height: 36.r,
                    child: ListView.builder(
                        padding: EdgeInsets.zero,
                        scrollDirection: Axis.horizontal,
                        itemCount:
                            state.types[state.selectType]?.options?.length ?? 0,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              if (description.text.contains((state
                                      .types[state.selectType]
                                      ?.options?[index]
                                      .translation
                                      ?.title ??
                                  ""))) {
                                return;
                              }
                              if (description.text.isNotEmpty) {
                                description.text = "${description.text}, ";
                              }
                              description.text = description.text +
                                  (state
                                          .types[state.selectType]
                                          ?.options?[index]
                                          .translation
                                          ?.title ??
                                      "");
                            },
                            child: AnimationButtonEffect(
                              child: Container(
                                margin: EdgeInsets.only(right: 8.r),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 18.r, vertical: 10.r),
                                decoration: BoxDecoration(
                                  color: AppStyle.bgGrey,
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                child: Text(
                                  state.types[state.selectType]?.options?[index]
                                          .translation?.title ??
                                      "",
                                  style: AppStyle.interNormal(size: 14),
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
              16.verticalSpace,
              TextFormField(
                autocorrect: true,
                controller: value,
                decoration: InputDecoration(
                  fillColor: AppStyle.bgGrey,
                  filled: true,
                  hintText: AppHelpers.getTranslation(TrKeys.itemValue),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide.merge(
                          const BorderSide(color: AppStyle.transparent),
                          const BorderSide(color: AppStyle.transparent))),
                  errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide.merge(
                          const BorderSide(color: AppStyle.transparent),
                          const BorderSide(color: AppStyle.transparent))),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide.merge(
                          const BorderSide(color: AppStyle.transparent),
                          const BorderSide(color: AppStyle.transparent))),
                  focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide.merge(
                          const BorderSide(color: AppStyle.transparent),
                          const BorderSide(color: AppStyle.transparent))),
                  disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide.merge(
                          const BorderSide(color: AppStyle.transparent),
                          const BorderSide(color: AppStyle.transparent))),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide.merge(
                          const BorderSide(color: AppStyle.transparent),
                          const BorderSide(color: AppStyle.transparent))),
                ),
              ),
              16.verticalSpace,
            ],
          ),
        )
      ],
    );
  }
}
