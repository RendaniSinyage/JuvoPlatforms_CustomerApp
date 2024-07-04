import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:riverpodtemp/application/profile/profile_notifier.dart';
import 'package:riverpodtemp/application/profile/profile_provider.dart';
import 'package:riverpodtemp/application/profile/profile_state.dart';
import 'package:riverpodtemp/infrastructure/services/app_helpers.dart';
import 'package:riverpodtemp/infrastructure/services/local_storage.dart';
import 'package:riverpodtemp/infrastructure/services/tr_keys.dart';
import 'package:riverpodtemp/presentation/components/app_bars/common_app_bar.dart';
import 'package:intl/intl.dart' as intl;
import 'package:riverpodtemp/presentation/components/buttons/pop_button.dart';
import 'package:riverpodtemp/presentation/components/buttons/second_button.dart';
import 'package:riverpodtemp/presentation/components/loading.dart';
import '../../components/badges.dart';
import '../../theme/app_style.dart';

// Add this extension for the capitalize method
extension StringExtension on String {
  String capitalize() {
    return isNotEmpty ? '${this[0].toUpperCase()}${substring(1)}' : '';
  }
}

@RoutePage()
class WalletHistoryPage extends ConsumerStatefulWidget {
  final bool isBackButton;
  const WalletHistoryPage({super.key, this.isBackButton = true});

  @override
  ConsumerState<WalletHistoryPage> createState() => _WalletHistoryState();
}

class _WalletHistoryState extends ConsumerState<WalletHistoryPage> {
  late RefreshController controller;
  late ProfileState state;
  late ProfileNotifier event;
  final bool isLtr = LocalStorage.getLangLtr();

  @override
  void initState() {
    controller = RefreshController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(profileProvider.notifier).getWallet(context);
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    event = ref.read(profileProvider.notifier);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    state = ref.watch(profileProvider);
    return Directionality(
      textDirection: isLtr ? TextDirection.ltr : TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppStyle.bgGrey,
        body: Column(
          children: [
            CommonAppBar(
              child: Column(
                children: [
                  const SizedBox(height: 55),
                  Row(
                    children: [
                      const SizedBox(width: 10),
                      Text(
                        AppHelpers.getTranslation(TrKeys.transactions),
                        style: AppStyle.interNoSemi(
                          size: 18,
                          color: AppStyle.black,
                        ),
                      ),
                      const SizedBox(width: 70),
                      SecondButton(
                        title: AppHelpers.getTranslation(TrKeys.send),
                        bgColor: AppStyle.brandGreen,
                        titleColor: AppStyle.white,
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return const ComingSoonDialog();
                            },
                          );
                        },
                      ),
                      const SizedBox(width: 8),
                      SecondButton(
                        title: AppHelpers.getTranslation(TrKeys.add),
                        bgColor: AppStyle.brandGreen,
                        titleColor: AppStyle.white,
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return const ComingSoonDialog();
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: state.isLoadingHistory
                  ? const Center(child: Loading())
                  : state.isEmptyWallet
                  ? _resultEmpty()
                  : SmartRefresher(
                enablePullDown: true,
                enablePullUp: true,
                physics: const BouncingScrollPhysics(),
                controller: controller,
                onLoading: () {
                  event.getWalletPage(context, controller);
                },
                onRefresh: () {
                  event.getWallet(context, refreshController: controller);
                },
                child: ListView.builder(
                  padding: EdgeInsets.all(16.r),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemCount: state.walletHistory?.length ?? 0,
                  itemBuilder: (context, index) => Container(
                    margin: EdgeInsets.only(bottom: 16.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      color: state.walletHistory?[index].type == "topup"
                          ? Colors.green.withOpacity(0.5)
                          : state.walletHistory?[index].type == "withdraw"
                          ? AppStyle.red.withOpacity(0.5)
                          : AppStyle.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              top: 16.r, right: 16.r, left: 16.r),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Text(
                                "${AppHelpers.getTranslation(TrKeys.paymentDate)}: ${intl.DateFormat("MMM dd,yyyy h:mm a").format(DateTime.tryParse(state.walletHistory?[index].createdAt ?? "")?.toLocal() ?? DateTime.now())}",
                                style: AppStyle.interRegular(
                                  size: 12.sp,
                                  color: AppStyle.black,
                                ),
                              ),
                              4.verticalSpace,
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "Ref: ",
                                      style: AppStyle.interBold(
                                        size: 16.sp,
                                        color: AppStyle.black,
                                      ),
                                    ),
                                    TextSpan(
                                      text: state.walletHistory?[index].note ?? "",
                                      style: AppStyle.interRegular(
                                        size: 16.sp,
                                        color: AppStyle.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(
                          color: AppStyle.black,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              bottom: 16.r, right: 16.r, left: 16.r),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Transaction type: "
                                    ,
                                    style: AppStyle.interRegular(
                                      size: 12.sp,
                                      color: AppStyle.black,
                                    ),
                                  ),
                                  Text(AppHelpers.numberFormat(
                                        number: state
                                     .walletHistory?[index].price),
                                    style: AppStyle.interBold(
                                      size: 16.sp,
                                      color: AppStyle.black,
                                    ),
                                  )
                                ],
                              ),
                                /*16.verticalSpace,
                                 Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    AppHelpers.getTranslation(
                                        TrKeys.sender),
                                    style: AppStyle.interRegular(
                                      size: 12.sp,
                                      color: AppStyle.black,
                                    ),
                                  ),
                                  Text(
                                    '${state.walletHistory?[index].author?.firstname ?? ""} ${state.walletHistory?[index].author?.lastname ?? ""}',
                                    style: AppStyle.interRegular(
                                      size: 16.sp,
                                      color: AppStyle.black,
                                    ),
                                  )
                                ],
                              ),
                              16.verticalSpace,*/
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text((state.walletHistory?[index].type ?? "").capitalize(),// is ${(state.walletHistory?[index].status ?? "").capitalize()}',


                                    style: AppStyle.interBold(
                                      size: 12.sp,
                                      color: AppStyle.black,
                                    ),
                                  ),
                                  Text('Status: ${(state.walletHistory?[index].status ?? "").capitalize()}',
                                    style: AppStyle.interRegular(
                                      size: 12.sp,
                                      color: AppStyle.black,
                                    ),
                                  )
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
            )
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        floatingActionButton: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: widget.isBackButton ? const PopButton() : const SizedBox.shrink(),
        ),
      ),
    );
  }

  Widget _resultEmpty() {
    return EmptyBadge(
      subtitleText: "Your Transaction History will appear here",
      titleText: "No Transactions",
    );
  }
}