import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:riverpodtemp/infrastructure/services/app_helpers.dart';
import 'package:riverpodtemp/infrastructure/services/local_storage.dart';
import 'package:riverpodtemp/infrastructure/services/tr_keys.dart';
import 'package:riverpodtemp/presentation/components/buttons/animation_button_effect.dart';
import 'package:riverpodtemp/presentation/routes/app_router.dart';
import 'package:riverpodtemp/presentation/theme/app_style.dart';

class DoorThree extends StatelessWidget {
  const DoorThree({super.key});

  @override
  Widget build(BuildContext context) {
    return  Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          AppHelpers.getTranslation(TrKeys.especiallyForYou),
          style: AppStyle.interNoSemi(size: 20),
        ),
        6.verticalSpace,
        Padding(
          padding: REdgeInsets.symmetric(horizontal: 24),
          child: Text(
            AppHelpers.getTranslation(TrKeys.yourPersonalDoor),
            style: AppStyle.interNormal(size: 14, color: AppStyle.textGrey),
            textAlign: TextAlign.center,
          ),
        ),
        20.verticalSpace,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: InkWell(
            onTap: (){
              if (LocalStorage.getToken().isEmpty) {
                context.pushRoute(const LoginRoute());
                return;
              }
              context.pushRoute(const ParcelRoute());
              return;
            },
            child: AnimationButtonEffect(
              child: Stack(
                children: [
                  Container(
                    height: 180,
                    padding: REdgeInsets.all(20),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: AppStyle.doorColor,
                        borderRadius: BorderRadius.circular(16.r)),
                  ),
                  Positioned(
                      right: 16.r,
                      bottom: 30.r,
                      child: Image.asset(
                        "assets/images/door_to_door_3.png",
                        height: 105.r,
                        width: 121.r,
                      )),
                  Positioned(
                      left: 16.r,
                      top: 16.r,
                      right: 110.r,
                      bottom: 16.r,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppHelpers.getTranslation(TrKeys.doorToDoor),
                            style:
                            AppStyle.interNoSemi(color: AppStyle.white, size: 24),
                          ),
                          const Spacer(),
                          Container(
                            width: 170.r,
                            height: 36.r,
                            padding: REdgeInsets.all(3),
                            decoration: ShapeDecoration(
                              color: AppStyle.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 32.r,
                                  height: double.infinity,
                                  decoration: const BoxDecoration(
                                    color: AppStyle.doorColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    FlutterRemix.twenty_four_hours_fill,
                                    color: AppStyle.white,
                                    size: 20.r,
                                  ),
                                ),
                                6.horizontalSpace,
                                Expanded(
                                  child: Text(
                                    AppHelpers.getTranslation(TrKeys.workForYou),
                                    style:
                                    AppStyle.interNoSemi(color: AppStyle.doorColor, size: 14),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ))
                ],
              ),
            ),
          ),
        ),
        24.verticalSpace,
      ],
    );
  }
}
