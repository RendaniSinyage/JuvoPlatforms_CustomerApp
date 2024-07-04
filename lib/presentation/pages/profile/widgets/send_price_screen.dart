import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
import 'package:riverpodtemp/presentation/components/custom_network_image.dart';
import 'package:riverpodtemp/presentation/components/custom_textformfield.dart';
import 'package:riverpodtemp/presentation/components/loading.dart';
import 'package:riverpodtemp/presentation/theme/theme.dart';

class SenPriceScreen extends StatefulWidget {
  //final CustomColorSet colors;

  const SenPriceScreen({super.key,
    //required this.colors
  });

  @override
  State<SenPriceScreen> createState() => _SenPriceScreenState();
}

class _SenPriceScreenState extends State<SenPriceScreen> {
  final GlobalKey<FormState> form = GlobalKey<FormState>();
  final delayed = Delayed(milliseconds: 700);
  late TextEditingController priceController;
  late TextEditingController userController;
  UserModel? user;

  @override
  void initState() {
    priceController = TextEditingController();
    userController = TextEditingController();
    super.initState();
  }

  @override
  void deactivate() {
    priceController.dispose();
    userController.dispose();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppStyle.red,
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
              AppHelpers.getTranslation(TrKeys.send),
              style: AppStyle.interNoSemi(color: AppStyle.textGrey),
            ),
            16.verticalSpace,
            CustomTextFormField(
              hint:
                  "${AppHelpers.getTranslation(TrKeys.price)} ${AppHelpers.getTranslation(LocalStorage.getSelectedCurrency()?.symbol ?? "")}",
              validation: AppValidators.isValidPrice,
              controller: priceController,
              inputType: TextInputType.number,
            ),
            16.verticalSpace,
            BlocBuilder<WalletBloc, WalletState>(
              builder: (context, state) {
                return Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextFormField(
                        hint: AppHelpers.getTranslation(TrKeys.searchUser),
                        validation: AppValidators.isNotEmptyValidator,
                        controller: userController,
                        onChanged: (text) {
                          delayed.run(() {
                            context.read<WalletBloc>().add(
                                WalletEvent.searchUser(
                                    context: context,
                                    search: text,
                                    isRefresh: true));
                          });
                        },
                      ),
                      state.isSearchingLoading
                          ? const Loading()
                          : Expanded(
                              child: ListView.builder(
                                  padding: EdgeInsets.only(top: 16.r),
                                  itemCount: state.listOfUser?.length ?? 0,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return _userItem(state, index, context);
                                  }),
                            )
                    ],
                  ),
                );
              },
            ),
            BlocBuilder<WalletBloc, WalletState>(
              buildWhen: (p, n) {
                return p.isButtonLoading != n.isButtonLoading;
              },
              builder: (context, state) {
                return CustomButton(
                    isLoading: state.isButtonLoading,
                    title: AppHelpers.getTranslation(TrKeys.pay),
                    //bgColor: widget.colors.primary,
                    textColor: AppStyle.white,
                    onPressed: () {
                      if (form.currentState?.validate() ?? false) {
                        context.read<WalletBloc>().add(WalletEvent.sendWallet(
                            onSuccess: () {
                              context.read<WalletBloc>().add(
                                  WalletEvent.fetchTransactions(
                                      context: context, isRefresh: true));
                              context.read<ProfileBloc>().add(
                                  ProfileEvent.fetchProfile(context: context));
                              Navigator.pop(context);
                            },
                            context: context,
                            price: priceController.text,
                            uuid: user?.uuid ?? ""));
                      }
                    });
              },
            )
          ],
        ),
      ),
    );
  }

  InkWell _userItem(WalletState state, int index, BuildContext context) {
    return InkWell(
      onTap: () {
        userController.text =
            "${state.listOfUser?[index].firstname ?? ""} ${state.listOfUser?[index].lastname ?? ""}";
        user = state.listOfUser?[index];
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4.r),
        child: Row(
          children: [
            CustomNetworkImage(
              url: state.listOfUser?[index].img ?? "",
              height: 56,
              width: 56,
              radius: 28,
              name: state.listOfUser?[index].firstname ??
                  state.listOfUser?[index].lastname,
            ),
            16.horizontalSpace,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.sizeOf(context).width - 250.r,
                  child: Text(
                    state.listOfUser?[index].firstname ?? "",
                    style:
                        AppStyle.interNormal(color: AppStyle.textGrey),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                6.verticalSpace,
                SizedBox(
                    width: MediaQuery.sizeOf(context).width - 250.r,
                    child: Text(
                      state.listOfUser?[index].lastname ?? "",
                      style: AppStyle.interNormal(
                          color: AppStyle.textGrey),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
