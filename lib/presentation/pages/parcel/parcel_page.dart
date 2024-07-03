// ignore_for_file: unused_result


import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:riverpodtemp/application/parcel/parcel_provider.dart';
import 'package:riverpodtemp/infrastructure/services/app_helpers.dart';
import 'package:riverpodtemp/infrastructure/services/local_storage.dart';
import 'package:riverpodtemp/infrastructure/services/tr_keys.dart';
import 'package:riverpodtemp/presentation/components/app_bars/common_app_bar.dart';
import 'package:riverpodtemp/presentation/components/buttons/custom_button.dart';
import 'package:riverpodtemp/presentation/components/buttons/pop_button.dart';
import 'package:riverpodtemp/presentation/components/keyboard_dismisser.dart';
import 'package:riverpodtemp/presentation/components/title_icon.dart';
import 'package:riverpodtemp/presentation/pages/parcel/widgets/recipient_widget.dart';
import 'package:riverpodtemp/presentation/pages/parcel/widgets/sender_widget.dart';
import 'package:riverpodtemp/presentation/theme/app_style.dart';
import 'widgets/info_item.dart';
import 'widgets/parcel_payments.dart';
import 'widgets/time_and_type.dart';


@RoutePage()
class ParcelPage extends ConsumerStatefulWidget {
  const ParcelPage({super.key});

  @override
  ConsumerState<ParcelPage> createState() => _ParcelPageState();
}

class _ParcelPageState extends ConsumerState<ParcelPage> {
  final TextEditingController fromUsername =
      TextEditingController(text: LocalStorage.getFirstName());
  final TextEditingController fromPhone = TextEditingController();
  final TextEditingController fromHouse = TextEditingController();
  final TextEditingController fromFloor = TextEditingController();
  final TextEditingController toUsername = TextEditingController();
  final TextEditingController toPhone = TextEditingController();
  final TextEditingController toHouse = TextEditingController();
  final TextEditingController toFloor = TextEditingController();
  final TextEditingController note = TextEditingController();
  final TextEditingController comment = TextEditingController();
  final TextEditingController itemValue = TextEditingController();
  final TextEditingController instruction = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.refresh(parcelProvider.notifier).fetchTypes(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(parcelProvider);
    final event = ref.read(parcelProvider.notifier);
    return Scaffold(
      body: KeyboardDismisser(
        child: Column(
          children: [
            CommonAppBar(
                child: Text(
              AppHelpers.getTranslation(TrKeys.doorToDoor),
              style: AppStyle.interNoSemi(
                size: 18,
                color: AppStyle.black,
              ),
            )),
            AppHelpers.getParcel()
                ? Expanded(
                    child: ListView(
                      padding: EdgeInsets.only(top: 16.r),
                      shrinkWrap: true,
                      children: [
                        Container(
                          color: AppStyle.white,
                          padding: EdgeInsets.all(16.r),
                          child: Form(
                            key: formKey,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          SenderWidget(
                                            state: state,
                                            event: event,
                                            username: fromUsername,
                                            phone: fromPhone,
                                            house: fromHouse,
                                            flour: fromFloor,
                                            comment: comment,
                                          ),
                                          10.verticalSpace,
                                          RecipientWidget(
                                            state: state,
                                            event: event,
                                            username: toUsername,
                                            phone: toPhone,
                                            house: toHouse,
                                            flour: toFloor,
                                            description: note,
                                            addInstruction: instruction,
                                            value: itemValue,
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (state.addressTo != null &&
                                        state.addressFrom != null &&
                                        !state.expand)
                                      InkWell(
                                        onTap: () => event.switchAddress(
                                            context: context),
                                        child: const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Icon(
                                              FlutterRemix.arrow_up_down_line),
                                        ),
                                      )
                                  ],
                                ),
                                10.verticalSpace,
                                if(state.expand)
                                CustomButton(
                                    icon: const Icon(
                                      FlutterRemix.wallet_2_line,
                                      color: AppStyle.black,
                                    ),
                                    background: AppStyle.bgGrey,
                                    isLoading: state.isButtonLoading,
                                    title: AppHelpers.getTranslation(state
                                            .selectPayment
                                            ?.tag ??
                                        TrKeys.paymentMethods),
                                    onPressed: () {
                                      AppHelpers.showCustomModalBottomSheet(
                                        paddingTop:
                                            MediaQuery.of(context).padding.top,
                                        context: context,
                                        modal: ParcelPayments(
                                          payLater: (payment) async {
                                            event.setPayment(payment);
                                          },
                                        ),
                                        isDarkMode: false,
                                        isDrag: true,
                                        radius: 12,
                                      );
                                    }),
                                if (state.addressTo == null &&
                                    state.addressFrom == null)
                                  _infoWidget(),
                              ],
                            ),
                          ),
                        ),
                        if (state.addressTo != null ||
                            state.addressFrom != null)
                          TypeAndTime(
                            event: event,
                            state: state,
                          ),
                        96.verticalSpace
                      ],
                    ),
                  )
                : Column(
                    children: [
                      32.verticalSpace,
                      Lottie.asset("assets/lottie/not_found_page.json"),
                      24.verticalSpace,
                      Padding(
                        padding: EdgeInsets.all(16.r),
                        child: Text(
                          AppHelpers.getTranslation(
                              TrKeys.ifYouWantToUseThisService),
                          style: AppStyle.interNormal(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Row(
          children: [
            const PopButton(),
            if (state.types.isNotEmpty &&
                (state.addressFrom?.isNotEmpty??false) &&
                (state.addressTo?.isNotEmpty??false))
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 16.r),
                  child: CustomButton(
                    borderColor:
                        !state.error ? AppStyle.transparent : AppStyle.textGrey,
                    background: !state.error ? AppStyle.brandGreen : AppStyle.white,
                    textColor: !state.error ? AppStyle.black : AppStyle.textGrey,
                    title:
                        "${state.expand ? AppHelpers.getTranslation(TrKeys.order) : AppHelpers.getTranslation(TrKeys.continueText)} ${AppHelpers.numberFormat(number: state.calculate?.data?.price ?? 0)}",
                    onPressed: () {
                      if (state.error) {
                        return;
                      }
                      if (!state.expand) {
                        event.changeExpand();
                      } else {
                        if (formKey.currentState?.validate() ?? false) {
                          event.orderParcel(
                              context: context,
                              note: note.text,
                              usernameTo: toUsername.text,
                              usernameFrom: fromUsername.text,
                              phoneTo: toPhone.text,
                              phoneFrom: fromPhone.text,
                              houseFrom: fromHouse.text,
                              houseTo: toHouse.text,
                              floorTo: toFloor.text,
                              floorFrom: fromFloor.text,
                              comment: comment.text,
                              value: itemValue.text,
                              instruction: instruction.text, totalPrice: state.calculate?.data?.price ?? 0);
                        }
                      }
                    },
                    isLoading: state.isLoading,
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }

  Widget _infoWidget() {
    return Column(
      children: [
        24.verticalSpace,
        TitleAndIcon(title: AppHelpers.getTranslation(TrKeys.howItWorks)),
        12.verticalSpace,
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                InfoItem(
                  isLarge: true,
                  index: 0,
                ),
                InfoItem(
                  index: 1,
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InfoItem(
                  index: 2,
                ),
                InfoItem(
                  isLarge: true,
                  index: 3,
                ),
              ],
            )
          ],
        )
      ],
    );
  }
}
