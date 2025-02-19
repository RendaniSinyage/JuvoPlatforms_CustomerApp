import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodyman/application/home/home_notifier.dart';
import 'package:foodyman/application/home/home_state.dart';
import 'package:foodyman/infrastructure/services/app_helpers.dart';
import 'package:foodyman/infrastructure/services/local_storage.dart';
import 'package:foodyman/infrastructure/services/tr_keys.dart';
import 'package:foodyman/presentation/components/app_bars/common_app_bar.dart';
import 'package:foodyman/presentation/components/custom_network_image.dart';
import 'package:foodyman/presentation/components/sellect_address_screen.dart';
import 'package:foodyman/presentation/routes/app_router.dart';
import 'package:foodyman/presentation/theme/app_style.dart';

class AppBarTwo extends StatelessWidget {
  final HomeState state;
  final HomeNotifier event;

  const AppBarTwo({super.key, required this.state, required this.event});

  @override
  Widget build(BuildContext context) {
    return CommonAppBar(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  if (LocalStorage.getToken().isEmpty) {
                    context.pushRoute(ViewMapRoute());
                    return;
                  }
                  AppHelpers.showCustomModalBottomSheet(
                      context: context,
                      modal: SelectAddressScreen(
                        addAddress: () async {
                          await context.pushRoute(ViewMapRoute());
                        },
                      ),
                      isDarkMode: false);
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: AppStyle.white),
                      padding: EdgeInsets.all(12.r),
                      child: SvgPicture.asset("assets/svgs/adress.svg"),
                    ),
                    10.horizontalSpace,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            AppHelpers.getTranslation(TrKeys.deliveryAddress),
                            style: AppStyle.interNormal(
                              size: 12,
                              color: AppStyle.textGrey,
                            ),
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: MediaQuery.sizeOf(context).width - 210.w,
                                child: Text(
                                  (LocalStorage
                                      .getAddressSelected()
                                      ?.title
                                      ?.isEmpty ??
                                      true)
                                      ? LocalStorage.getAddressSelected()
                                      ?.address ??
                                      ''
                                      : LocalStorage.getAddressSelected()?.title ??
                                      "",
                                  style: AppStyle.interBold(
                                    size: 14,
                                    color: AppStyle.black,
                                  ),
                                  maxLines: 1,
                                ),
                              ),
                              const Icon(Icons.keyboard_arrow_down_sharp)
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            10.horizontalSpace,
            GestureDetector(
              onTap: () {
                context.pushRoute(SearchRoute());
              },
              child: Padding(
                padding: REdgeInsets.only(top: 16, left: 16, right: 16, bottom: 6),
                child: const Icon(FlutterRemix.search_2_line),
              ),
            ),
            GestureDetector(
              onTap: () {
                if (LocalStorage.getToken().isEmpty) {
                  context.router.replace(const LoginRoute());
                } else {
                  context.pushRoute(ProfileRoute());
                }
              },
              child: Container(
                width: 40.r,
                height: 40.r,
                decoration: const BoxDecoration(shape: BoxShape.circle),
                child: CustomNetworkImage(
                  profile: true,
                  url: LocalStorage.getUser()?.img,
                  height: 40.r,
                  width: 40.r,
                  radius: 20.r,
                ),
              ),
            )
          ],
        ));
  }
}
