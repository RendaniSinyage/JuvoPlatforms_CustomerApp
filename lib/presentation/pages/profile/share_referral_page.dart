// ignore_for_file: use_build_context_synchronously

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:riverpodtemp/application/profile/profile_provider.dart';
import 'package:riverpodtemp/infrastructure/services/app_helpers.dart';
import 'package:riverpodtemp/infrastructure/services/tr_keys.dart';
import 'package:riverpodtemp/presentation/components/buttons/custom_button.dart';
import 'package:riverpodtemp/presentation/components/custom_network_image.dart';
import 'package:riverpodtemp/presentation/components/loading.dart';
import 'package:riverpodtemp/presentation/routes/app_router.dart';

import '../../../infrastructure/services/local_storage.dart';
import '../../components/app_bars/common_app_bar.dart';
import '../../components/buttons/pop_button.dart';
import '../../theme/app_style.dart';


@RoutePage()
class ShareReferralPage extends ConsumerStatefulWidget {
  const ShareReferralPage({super.key});

  @override
  ConsumerState<ShareReferralPage> createState() => _ShareReferralPageState();
}

class _ShareReferralPageState extends ConsumerState<ShareReferralPage> {
  late RefreshController controller;
  final bool isLtr = LocalStorage.getLangLtr();

  @override
  void initState() {
    controller = RefreshController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(profileProvider.notifier).fetchReferral(context);
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(profileProvider);

    return Directionality(
      textDirection: isLtr ? TextDirection.ltr : TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppStyle.bgGrey,
        body: Column(
          children: [
            CommonAppBar(
              child: Text(
                AppHelpers.getTranslation(TrKeys.referral),
                style: AppStyle.interNoSemi(
                  size: 18,
                  color: AppStyle.black,
                ),
              ),
            ),
            state.isReferralLoading
                ? const Loading()
                : Padding(
                    padding: EdgeInsets.all(16.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 200.h,
                          width: double.infinity,
                          child: CustomNetworkImage(
                            url: state.referralData?.img ?? "",
                            height: 42.r,
                            width: 42.r,
                            radius: 8.r,
                          ),
                        ),
                        Text(
                          state.referralData?.translation?.title ?? "",
                          style: AppStyle.interNoSemi(
                            size: 20,
                            color: AppStyle.black,
                          ),
                        ),
                        16.verticalSpace,
                        GestureDetector(
                          onTap: () {
                            context.pushRoute(ShareReferralFaqRoute(
                                terms: state
                                        .referralData?.translation?.shortDesc ??
                                    ""));
                          },
                          child: RichText(
                            text: TextSpan(
                                text:
                                    "${state.referralData?.translation?.description} ",
                                style: AppStyle.interNoSemi(
                                  size: 14,
                                  color: AppStyle.textGrey,
                                ),
                                children: [
                                  TextSpan(
                                    text: AppHelpers.getTranslation(
                                            TrKeys.referralFaq)
                                        .toLowerCase(),
                                    style: AppStyle.interNoSemi(
                                        size: 14,
                                        color: AppStyle.black,
                                        decoration: TextDecoration.underline),
                                  )
                                ]),
                          ),
                        ),
                        16.verticalSpace,
                        CustomButton(
                            title: AppHelpers.getTranslation(TrKeys.share),
                            onPressed: () {
                              FlutterShare.share(
                                  title: AppHelpers.getTranslation(
                                      TrKeys.referral),
                                  linkUrl: ref
                                          .watch(profileProvider)
                                          .userData
                                          ?.referral ??
                                      "");
                            }),
                        16.verticalSpace,
                        CustomButton(
                            background: AppStyle.transparent,
                            borderColor: AppStyle.black,
                            title: AppHelpers.getTranslation(TrKeys.copyCode),
                            onPressed: () async {
                              await Clipboard.setData(ClipboardData(
                                  text: ref
                                          .watch(profileProvider)
                                          .userData
                                          ?.referral ??
                                      ""));
                              AppHelpers.showCheckTopSnackBarDone(context,
                                  AppHelpers.getTranslation(TrKeys.copyCode));
                            }),
                        16.verticalSpace,
                        Container(
                          height: 74.r,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.r),
                            border: Border.all(color: AppStyle.black),
                          ),
                          alignment: Alignment.center,
                          child: Padding(
                            padding: REdgeInsets.symmetric(horizontal: 24),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  FlutterRemix.coins_fill,
                                  size: 45.r,
                                  color: AppStyle.black,
                                ),
                                10.horizontalSpace,
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      AppHelpers.getTranslation(TrKeys.balance),
                                      style: AppStyle.interNormal(
                                        size: 14.sp,
                                        color: AppStyle.black,
                                        letterSpacing: -0.3,
                                      ),
                                    ),
                                    Text(
                                      AppHelpers.numberFormat(
                                          number: (state.userData
                                                      ?.referralFromPrice ??
                                                  0) -
                                              (state.userData
                                                      ?.referralFromWithdrawPrice ??
                                                  0)),
                                      style: AppStyle.interSemi(
                                        size: 18.sp,
                                        color: AppStyle.black,
                                        letterSpacing: -0.3,
                                      ),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                Container(
                                  width: 1.r,
                                  height: 46.r,
                                  color: AppStyle.black,
                                ),
                                const Spacer(),
                                Text(
                                  ((state.userData?.referralFromPrice ?? 0) -
                                          (state.userData
                                                  ?.referralFromWithdrawPrice ??
                                              0))
                                      .toString(),
                                  style: AppStyle.interSemi(
                                    size: 18.sp,
                                    color: AppStyle.black,
                                    letterSpacing: -0.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        floatingActionButton: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: const PopButton(),
        ),
      ),
    );
  }
}
