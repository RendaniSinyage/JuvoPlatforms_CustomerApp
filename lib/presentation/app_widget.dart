import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:riverpodtemp/application/app_widget/app_provider.dart';
import 'package:riverpodtemp/domain/di/dependency_manager.dart';
import 'package:riverpodtemp/infrastructure/services/local_storage.dart';
import 'package:riverpodtemp/presentation/theme/app_style.dart';

import 'components/custom_range_slider.dart';
import 'routes/app_router.dart';

class AppWidget extends ConsumerWidget {
  AppWidget({super.key});

  final appRouter = AppRouter();

  Future fetchSetting() async {
    final connect = await Connectivity().checkConnectivity();
    if (connect == ConnectivityResult.wifi ||
        connect == ConnectivityResult.mobile) {
      settingsRepository.getGlobalSettings();
      await settingsRepository.getLanguages();
      await settingsRepository.getMobileTranslations();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.refresh(appProvider);
    return FutureBuilder(
        future: Future.wait([
          FlutterDisplayMode.setHighRefreshRate(),
          if (LocalStorage.getTranslations().isEmpty) fetchSetting()
        ]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          return ScreenUtilInit(
            useInheritedMediaQuery: false,
            designSize: const Size(375, 812),
            builder: (context, child) {
              return RefreshConfiguration(
                footerBuilder: () => const ClassicFooter(
                  idleIcon: SizedBox(),
                  idleText: "",
                ),
                headerBuilder: () => const WaterDropMaterialHeader(
                  backgroundColor: AppStyle.white,
                  color: AppStyle.textGrey,
                ),
                child: MaterialApp.router(
                  debugShowCheckedModeBanner: false,
                  routerDelegate: appRouter.delegate(),
                  routeInformationParser: appRouter.defaultRouteParser(),
                  locale: Locale(state.activeLanguage?.locale ?? 'en'),
                  theme: ThemeData(
                    useMaterial3: false,
                    sliderTheme: SliderThemeData(
                      overlayShape: SliderComponentShape.noOverlay,
                      rangeThumbShape: CustomRoundRangeSliderThumbShape(
                        enabledThumbRadius: 12.r,
                      ),
                    ),
                  ),
                  themeMode:
                      state.isDarkMode ? ThemeMode.dark : ThemeMode.light,
                ),
              );
            },
          );
        });
  }
}

