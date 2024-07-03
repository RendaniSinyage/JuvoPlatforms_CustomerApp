import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
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

class SenderWidget extends StatelessWidget {
  final ParcelState state;
  final ParcelNotifier event;
  final TextEditingController username;
  final TextEditingController phone;
  final TextEditingController house;
  final TextEditingController flour;
  final TextEditingController comment;

  const SenderWidget(
      {super.key,
      required this.state,
      required this.event,
      required this.username,
      required this.phone,
      required this.house,
      required this.flour,
      required this.comment});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (state.expand)
          Padding(
            padding: EdgeInsets.only(bottom: 16.r),
            child: Text(
              AppHelpers.getTranslation(TrKeys.sender),
              style: AppStyle.interNoSemi(size: 16),
            ),
          ),
        InkWell(
          onTap: () async {
            final data =
                await context.pushRoute(ViewMapRoute(isShopLocation: true,isParcel: true));
            if (data.runtimeType == AddressNewModel) {
              if (context.mounted) {
                event.setFromAddress(
                    title: (data as AddressNewModel).address?.address,
                    location: LocationModel(
                        longitude: data.location?.last,
                        latitude: data.location?.first),
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
                  SvgPicture.asset("assets/svgs/pickUpFrom.svg"),
                  12.horizontalSpace,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (state.addressFrom != null)
                        Text(
                          AppHelpers.getTranslation(TrKeys.pickup),
                          style: AppStyle.interRegular(size: 12),
                        ),
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width / 2 - 20.r,
                        child: Text(
                          state.addressFrom ??
                              AppHelpers.getTranslation(TrKeys.pickup),
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
                label: AppHelpers.getTranslation(TrKeys.comment),
                textController: comment,
              ),
              24.verticalSpace,
            ],
          ),
        )
      ],
    );
  }
}
