import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpodtemp/presentation/routes/app_router.dart';
import '../../../../application/splash/splash_provider.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

@RoutePage()
class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref.read(splashProvider.notifier).getTranslations(context);
      ref.read(splashProvider.notifier).getToken(context, goMain: () {
        FlutterNativeSplash.remove();
        context.replaceRoute(const MainRoute());
      }, goLogin: () {
        FlutterNativeSplash.remove();
        context.replaceRoute(const LoginRoute());
      }, goNoInternet: () {
        FlutterNativeSplash.remove();
        context.replaceRoute(const NoConnectionRoute());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      "assets/images/splash.png",
      fit: BoxFit.fill,
    );
  }
}
