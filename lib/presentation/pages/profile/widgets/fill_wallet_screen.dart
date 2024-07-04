/*import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:riverpodtemp/utils/profile/profile_bloc.dart';
import 'package:riverpodtemp/utils/wallet/wallet_bloc.dart';
import 'package:riverpodtemp/utils/model/user_model.dart';
import 'package:riverpodtemp/infrastructure/services/app_helpers.dart';
import 'package:riverpodtemp/infrastructure/services/tpying_delay.dart';
import 'package:riverpodtemp/infrastructure/services/tr_keys.dart';
import 'package:riverpodtemp/infrastructure/services/app_validators.dart';
import 'package:riverpodtemp/infrastructure/services/local_storage.dart';
import 'package:riverpodtemp/presentation/components/buttons/custom_button.dart';
import 'package:riverpodtemp/presentation/components/custom_textformfield.dart';
import 'package:riverpodtemp/presentation/components/keyboard_dismisser.dart';
import 'package:riverpodtemp/presentation/theme/theme.dart';

class FillWalletScreen extends StatefulWidget {
  //final CustomColorSet colors;

  const FillWalletScreen({super.key, //required this.colors
   });

  @override
  State<FillWalletScreen> createState() => _FillWalletScreenState();
}

class _FillWalletScreenState extends State<FillWalletScreen> {
  final GlobalKey<FormState> form = GlobalKey<FormState>();
  late TextEditingController priceController;

  @override
  void initState() {
    priceController = TextEditingController();
    super.initState();
  }

  @override
  void deactivate() {
    priceController.dispose();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      //isLtr: LocalStorage.getLangLtr(),
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          //color: AppStyle.backgroundColor,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(16.r),
            topLeft: Radius.circular(16.r),
          ),
        ),
        child: Form(
          key: form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              24.verticalSpace,
              Text(
                AppHelpers.getTranslation(TrKeys.fillWallet),
                style: AppStyle.interNoSemi(color: AppStyle.textGrey),
              ),
              16.verticalSpace,
              CustomTextFormField(
                hint:
                    "${AppHelpers.getTranslation(TrKeys.price)} ${AppHelpers.getTranslation(LocalStorage.getSelectedCurrency()?.symbol ?? "")}",
                validation: AppValidators.isNotEmptyValidator,
                controller: priceController,
                inputType: TextInputType.number,
              ),
              16.verticalSpace,
              BlocBuilder<WalletBloc, WalletState>(
                builder: (context, state) {
                  return Expanded(
                    child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: state.list?.length ?? 0,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              WidgetsBinding.instance.focusManager.primaryFocus
                                  ?.unfocus();
                              context
                                  .read<WalletBloc>()
                                  .add(WalletEvent.selectPayment(index: index));
                            },
                            child: Column(
                              children: [
                                8.verticalSpace,
                                Row(
                                  children: [
                                    Icon(
                                      state.selectPayment == index
                                          ? FlutterRemix.checkbox_circle_fill
                                          : FlutterRemix
                                              .checkbox_blank_circle_line,
                                      color: state.selectPayment == index
                                          ? AppStyle.brandGreen
                                          : AppStyle.black,
                                    ),
                                    10.horizontalSpace,
                                    Text(
                                      state.list?[index].tag ?? "",
                                      style: AppStyle.interNormal(
                                        size: 14,
                                        color: AppStyle.textGrey,
                                      ),
                                    )
                                  ],
                                ),
                                const Divider(
                                  color: AppStyle.red,
                                ),
                                8.verticalSpace
                              ],
                            ),
                          );
                        }),
                  );
                },
              ),
              16.verticalSpace,
              BlocBuilder<WalletBloc, WalletState>(
                buildWhen: (p, n) {
                  return p.isButtonLoading != n.isButtonLoading;
                },
                builder: (context, state) {
                  return CustomButton(
                      isLoading: state.isButtonLoading,
                      title: AppHelpers.getTranslation(TrKeys.pay),
                     // bgColor: AppStyle.brandGreen,
                      textColor: AppStyle.white,
                      onPressed: () {
                        if (form.currentState?.validate() ?? false) {
                          if (state.list?.isEmpty ?? true) {
                            AppHelpers.openDialog(
                                context: context,
                                title: AppHelpers.getTranslation(
                                    TrKeys.thereAreNoPaymentTypesHere));
                            return;
                          }
                          context.read<WalletBloc>().add(WalletEvent.fillWallet(
                              context: context,
                              walletId: LocalStorage.getUserId(getUser().wallet?.id ?? 0,
                              price: priceController.text,
                              onSuccess: () {
                                context.read<WalletBloc>().add(
                                    WalletEvent.fetchTransactions(
                                        context: context, isRefresh: true));
                                context.read<ProfileBloc>().add(
                                    ProfileEvent.fetchProfile(
                                        context: context));
                                Navigator.pop(context);
                              }));
                        }
                      });
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
*/