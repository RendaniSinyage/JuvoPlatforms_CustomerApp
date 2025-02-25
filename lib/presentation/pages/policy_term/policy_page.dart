import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodyman/application/profile/profile_provider.dart';
//import 'package:foodyman/infrastructure/services/app_helpers.dart';
//import 'package:foodyman/infrastructure/services/tr_keys.dart';
import 'package:foodyman/presentation/components/buttons/pop_button.dart';
import 'package:foodyman/presentation/theme/theme.dart';
import 'package:foodyman/infrastructure/services/app_assets.dart';
import 'package:foodyman/presentation/components/app_bars/common_app_bar.dart';

import 'package:foodyman/presentation/components/loading.dart';

@RoutePage()
class PolicyPage extends ConsumerStatefulWidget {
  const PolicyPage({super.key});

  @override
  ConsumerState<PolicyPage> createState() => _PolicyPageState();
}

class _PolicyPageState extends ConsumerState<PolicyPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(profileProvider.notifier).getPolicy(context: context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(profileProvider);
    return Scaffold(
      //backgroundColor: AppStyle.bgGrey,
      body: state.isPolicyLoading
          ? const Center(child: Loading())
          : Column(
        crossAxisAlignment: CrossAxisAlignment.center,
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
                      state.policy?.title ?? "",
                      style: AppStyle.interSemi(color: AppStyle.primary),
                    ),
                  ),
                ),
              ],
            ),
          ),
          state.isPolicyLoading
              ? const Center(child: Loading())
              : Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Html(
                    data: state.policy?.description ?? "",
                    style: {
                      "body": Style(),
                    },
                  )
                ],
              ),
            ),
          )
        ],
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: const PopButton(),
    );
  }
}
