import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:riverpodtemp/application/home/home_notifier.dart';
import 'package:riverpodtemp/application/home/home_state.dart';
import 'package:riverpodtemp/infrastructure/services/app_helpers.dart';
import 'package:riverpodtemp/infrastructure/services/local_storage.dart';
import 'package:riverpodtemp/infrastructure/services/tr_keys.dart';
import 'package:riverpodtemp/presentation/components/app_bars/common_app_bar.dart';
import 'package:riverpodtemp/presentation/components/sellect_address_screen.dart';
import 'package:riverpodtemp/presentation/routes/app_router.dart';
import 'package:riverpodtemp/presentation/theme/app_style.dart';

class AppBarHome extends StatelessWidget {
  final HomeState state;
  final HomeNotifier event;

  const AppBarHome({super.key, required this.state, required this.event});

  @override
  Widget build(BuildContext context) {
    return CommonAppBar(
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
                shape: BoxShape.circle, color: AppStyle.bgGrey),
            padding: EdgeInsets.all(12.r),
            child: SvgPicture.asset("assets/svgs/adress.svg"),
          ),
          10.horizontalSpace,
          Column(
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
                    width: MediaQuery.sizeOf(context).width - 120.w,
                    child: Text(
                      (LocalStorage.getAddressSelected()?.title?.isEmpty ??
                              true)
                          ? LocalStorage.getAddressSelected()?.address ?? ''
                          : LocalStorage.getAddressSelected()?.title ?? "",
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
          )
        ],
      ),
    ));
  }
}
