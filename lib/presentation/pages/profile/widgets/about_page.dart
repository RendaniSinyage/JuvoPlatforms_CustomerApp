import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:riverpodtemp/presentation/components/loading.dart';
import 'package:riverpodtemp/presentation/theme/app_style.dart';
import 'package:riverpodtemp/presentation/components/buttons/pop_button.dart';
import '../../../../infrastructure/services/app_helpers.dart';
import '../../../../infrastructure/services/tr_keys.dart';
import 'package:riverpodtemp/infrastructure/services/app_assets.dart';
import 'package:riverpodtemp/presentation/components/app_bars/common_app_bar.dart';
import 'package:riverpodtemp/application/about/about_provider.dart';
import 'package:riverpodtemp/presentation/components/custom_network_image.dart';

class AboutPage extends ConsumerStatefulWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  ConsumerState<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends ConsumerState<AboutPage> {
  @override
  Widget build(BuildContext context) {
    final aboutState = ref.watch(aboutProvider);

    return Scaffold(
      backgroundColor: AppStyle.bgGrey,
      body: aboutState.isLoading
          ? const Loading()
          : aboutState.value == null
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
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Text(
                                "About us",
                                style: AppStyle.interSemi(color: AppStyle.brandGreen),
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
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  "About us",
                                  style: AppStyle.interSemi(color: AppStyle.brandGreen),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (aboutState.hasValue)
                        Padding(
                          padding: EdgeInsets.all(16.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (aboutState.value!['img'] != null)
                                CustomNetworkImage(
                                  url: aboutState.value!['img'], // Pass the 'img' URL
                                  height: 200, // Adjust height as needed
                                  width: MediaQuery.of(context).size.width, // Use full width of the screen
                                  radius: 10, // Adjust border radius as needed
                                  fit: BoxFit.cover, // Adjust fit as needed
                                  bgColor: Colors.transparent, // Adjust background color as needed
                                ),
                              if (aboutState.value!['img'] != null)
                                SizedBox(height: 16.h), // Add spacing between image and description
                              Container(
                                margin: EdgeInsets.only(bottom: 8.h),
                                padding: EdgeInsets.all(16.r),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: AppStyle.white,
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                child: Html(
                                  data: aboutState.value?['description'] ?? '',
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
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: const PopButton(),
        ),
      ),
    );
  }
}