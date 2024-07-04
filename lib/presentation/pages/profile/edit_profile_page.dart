import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart' as intl;
import 'package:riverpodtemp/application/edit_profile/edit_profile_provider.dart';
import 'package:riverpodtemp/application/profile/profile_provider.dart';
import 'package:riverpodtemp/infrastructure/models/models.dart';
import 'package:riverpodtemp/infrastructure/services/app_constants.dart';
import 'package:riverpodtemp/infrastructure/services/app_helpers.dart';
import 'package:riverpodtemp/infrastructure/services/app_validators.dart';
import 'package:riverpodtemp/infrastructure/services/local_storage.dart';
import 'package:riverpodtemp/infrastructure/services/tr_keys.dart';
import 'package:riverpodtemp/presentation/components/buttons/custom_button.dart';
import 'package:riverpodtemp/presentation/components/custom_network_image.dart';
import 'package:riverpodtemp/presentation/components/keyboard_dismisser.dart';
import 'package:riverpodtemp/presentation/components/loading.dart';
import 'package:riverpodtemp/presentation/components/text_fields/outline_bordered_text_field.dart';
import 'package:riverpodtemp/presentation/components/text_fields/underline_drop_down.dart';
import 'package:riverpodtemp/presentation/components/title_icon.dart';
import 'package:riverpodtemp/presentation/theme/theme.dart';

import 'phone_verify.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  final ScrollController controller;

  const EditProfileScreen({
    super.key,
    required this.controller,
  });

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final formKey = GlobalKey<FormState>();
  late TextEditingController birthDay;

  @override
  void initState() {
    birthDay = TextEditingController(
        text: intl.DateFormat("yyyy-MM-dd").format(DateTime.tryParse(
                    ref.read(profileProvider).userData?.birthday ?? "")
                ?.toLocal() ??
            DateTime.now()));
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref
          .read(editProfileProvider.notifier)
          .setPhone(ref.read(profileProvider).userData?.phone ?? "");
      ref.read(editProfileProvider.notifier).setBirth(
          intl.DateFormat("yyyy-MM-dd").format(DateTime.tryParse(
                      ref.read(profileProvider).userData?.birthday ?? "")
                  ?.toLocal() ??
              DateTime.now()));
    });
    super.initState();
  }

  @override
  void dispose() {
    birthDay.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isLtr = LocalStorage.getLangLtr();
    final event = ref.read(editProfileProvider.notifier);
    final user = ref.watch(profileProvider).userData;
    final state = ref.watch(editProfileProvider);
    ref.listen(editProfileProvider, (previous, next) {
      if (next.isSuccess && (previous?.isSuccess ?? false) != next.isSuccess) {
        ref
            .read(profileProvider.notifier)
            .setUser(next.userData ?? ProfileData());
      }
    });
    return Directionality(
      textDirection: isLtr ? TextDirection.ltr : TextDirection.rtl,
      child: KeyboardDismisser(
      child: Padding(
      padding: const EdgeInsets.all(16.0),
        child: Container(
          margin: MediaQuery.of(context).viewInsets,
          decoration: BoxDecoration(
              color: AppStyle.bgGrey.withOpacity(0.96),
              borderRadius: BorderRadius.all(Radius.circular(16.r))),
          width: double.infinity,
          child: state.isLoading
              ? const Loading()
              : Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: SingleChildScrollView(
                    controller: widget.controller,
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              8.verticalSpace,
                              Center(
                                child: Container(
                                  height: 4.h,
                                  width: 48.w,
                                  decoration: BoxDecoration(
                                      color: AppStyle.dragElement,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(40.r))),
                                ),
                              ),
                              24.verticalSpace,
                              TitleAndIcon(
                                title: AppHelpers.getTranslation(
                                    TrKeys.profileSettings),
                                paddingHorizontalSize: 0,
                                titleSize: 18,
                              ),
                              24.verticalSpace,
                              Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(42.r),
                                      color: AppStyle.shimmerBase,
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(42.r),
                                      child:
                                          ((user?.img?.isNotEmpty ?? false) &&
                                                  state.imagePath.isEmpty)
                                              ? CustomNetworkImage(
                                                  profile: true,
                                                  url: user!.img ?? "",
                                                  height: 84.r,
                                                  width: 84.r,
                                                  radius: 42.r)
                                              : state.imagePath.isNotEmpty
                                                  ? Image.file(
                                                      File(state.imagePath),
                                                      width: 84.r,
                                                      height: 84.r,
                                                    )
                                                  : CustomNetworkImage(
                                                      profile: true,
                                                      url: state.url,
                                                      height: 84.r,
                                                      width: 84.r,
                                                      radius: 42.r),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(top: 56.h, left: 50.w),
                                    child: GestureDetector(
                                      onTap: () {
                                        event.getPhoto();
                                      },
                                      child: Container(
                                        width: 38.w,
                                        height: 38.h,
                                        decoration: BoxDecoration(
                                            color: AppStyle.white,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                color: AppStyle.borderColor)),
                                        child: const Icon(
                                            FlutterRemix.pencil_line),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              24.verticalSpace,
                              OutlinedBorderTextField(
                                readOnly: AppValidators.isValidEmail(
                                    user?.email ?? ''),
                                label: AppHelpers.getTranslation(TrKeys.email)
                                    .toUpperCase(),
                                initialText: user?.email ?? "",
                                validation: AppValidators.emailCheck,
                                onChanged: event.setEmail,
                              ),
                              34.verticalSpace,
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: (MediaQuery.sizeOf(context).width -
                                            88) /
                                        2,
                                    child: OutlinedBorderTextField(
                                      label: AppHelpers.getTranslation(
                                              TrKeys.firstname)
                                          .toUpperCase(),
                                      initialText: user?.firstname ?? "",
                                      validation:
                                          AppValidators.isNotEmptyValidator,
                                      onChanged: (s) {
                                        event.setFirstName(s);
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: (MediaQuery.sizeOf(context).width -
                                            40) /
                                        2,
                                    child: OutlinedBorderTextField(
                                      label: AppHelpers.getTranslation(
                                              TrKeys.surname)
                                          .toUpperCase(),
                                      initialText: user?.lastname ?? "",
                                      validation:
                                          AppValidators.isNotEmptyValidator,
                                      onChanged: (s) {
                                        event.setLastName(s);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              34.verticalSpace,
                              OutlinedBorderTextField(
                                readOnly: true,
                                label: AppHelpers.getTranslation(
                                        TrKeys.phoneNumber)
                                    .toUpperCase(),
                                hint: "+1 990 000 00 00",
                                initialText: user?.phone ?? "",
                                validation: AppValidators.isNotEmptyValidator,
                                onTap: () {
                                  AppHelpers.showCustomModalBottomSheet(
                                      context: context,
                                      modal: const PhoneVerify(),
                                      isDarkMode: false,
                                      paddingTop:
                                          MediaQuery.paddingOf(context).top);
                                },
                              ),
                              34.verticalSpace,
                              OutlinedBorderTextField(
                                onTap: () {
                                  AppHelpers.showCustomModalBottomSheet(
                                      context: context,
                                      modal: Container(
                                        height: 250.h,
                                        padding:
                                            const EdgeInsets.only(top: 6.0),
                                        margin: EdgeInsets.only(
                                          bottom:
                                              MediaQuery.viewInsetsOf(context)
                                                  .bottom,
                                        ),
                                        color: CupertinoColors.systemBackground
                                            .resolveFrom(context),
                                        child: SafeArea(
                                          top: false,
                                          child: CupertinoDatePicker(
                                            initialDateTime:
                                                DateTime.tryParse(birthDay.text)
                                                        ?.toLocal() ??
                                                    DateTime.now(),
                                            maximumDate: DateTime.now(),
                                            mode: CupertinoDatePickerMode.date,
                                            use24hFormat: true,
                                            onDateTimeChanged:
                                                (DateTime newDate) {
                                              birthDay.text =
                                                  intl.DateFormat("yyyy-MM-dd")
                                                      .format(newDate);
                                              event
                                                  .setBirth(newDate.toString());
                                            },
                                          ),
                                        ),
                                      ),
                                      isDarkMode: false);
                                },
                                readOnly: true,
                                label: AppHelpers.getTranslation(
                                        TrKeys.dateOfBirth)
                                    .toUpperCase(),
                                hint: "YYYY-MM-DD",
                                validation: AppValidators.isNotEmptyValidator,
                                textController: birthDay,
                              ),
                              34.verticalSpace,
                              UnderlineDropDown(
                                value: user?.gender,
                                hint:
                                AppHelpers.getTranslation(TrKeys.typeHere),
                                label: AppHelpers.getTranslation(TrKeys.gender)
                                    .toUpperCase(),
                                list: AppConstants.genderList,
                                onChanged: event.setGender,
                                validator: (s) {
                                  if (s?.isNotEmpty ?? false) {
                                    return null;
                                  }
                                  return AppHelpers.getTranslation(
                                      TrKeys.canNotBeEmpty);
                                },
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                bottom: MediaQuery.of(context).padding.bottom +
                                    24.h,
                                top: 24.h),
                            child: CustomButton(
                              title: AppHelpers.getTranslation(TrKeys.save),
                              onPressed: () {
                                if (formKey.currentState?.validate() ?? false) {
                                  event.editProfile(context, user!);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
        ),
      ),
    ));
  }
}
