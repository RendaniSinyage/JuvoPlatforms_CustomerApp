import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
//import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:foodyman/presentation/components/loading.dart';
import 'package:foodyman/presentation/theme/app_style.dart';
import 'package:foodyman/presentation/components/buttons/pop_button.dart';
//import '../../../../infrastructure/services/app_helpers.dart';
//import '../../../../infrastructure/services/tr_keys.dart';
import 'package:foodyman/infrastructure/services/app_assets.dart';
import 'package:foodyman/presentation/components/app_bars/common_app_bar.dart';
import 'package:foodyman/application/delivery/delivery_provider.dart';

class DeliveryPage extends ConsumerStatefulWidget {
  const DeliveryPage({super.key});

  @override
  ConsumerState<DeliveryPage> createState() => _DeliveryPageState();
}

class _DeliveryPageState extends ConsumerState<DeliveryPage> {
  @override
  Widget build(BuildContext context) {
    final deliveryState = ref.watch(deliveryProvider);

    return Scaffold(
      backgroundColor: AppStyle.bgGrey,
      body: deliveryState.isLoading
          ? const Loading()
          : deliveryState.value == null
              ? Column(
                  children: [
                    CommonAppBar(
                      child: Row(
                          children: [
                            Image.asset(
                              AppAssets.pngLogo,
                              width: 40,
                              height: 40,
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  "Looking for delivery driver jobs?",
                                  style: AppStyle.interSemi(color: AppStyle.primary),
                                ),
                              ),
                            ),
                          ],
                        ),
                    ),
                  ],
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      CommonAppBar(
                        child: Row(
                          children: [
                            Image.asset(
                              AppAssets.pngLogo,
                              width: 40,
                              height: 40,
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  "Looking for delivery driver jobs?",
                                  style: AppStyle.interSemi(color: AppStyle.primary),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (deliveryState.hasValue)
                        Padding(
                          padding: EdgeInsets.all(16.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(bottom: 8.h),
                                padding: EdgeInsets.all(16.r),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: AppStyle.white,
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                child: Html(
                                  data: deliveryState.value?['description'] ?? '',
                                  style: {
                                    'body': Style(
                                      fontSize: FontSize(16.sp),
                                      color: AppStyle.textGrey,
                                    ),
                                    'strong': Style(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                     
                    ],
                  ),
                ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: Visibility(
        visible: MediaQuery.of(context).viewInsets.bottom == 0.0,
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: PopButton(),
        ),
      ),
    );
  }
}
