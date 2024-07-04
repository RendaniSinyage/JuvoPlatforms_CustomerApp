import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:riverpodtemp/application/profile/profile_provider.dart';
//import 'package:riverpodtemp/infrastructure/services/app_helpers.dart';
//import 'package:riverpodtemp/infrastructure/services/tr_keys.dart';
import 'package:riverpodtemp/presentation/components/buttons/pop_button.dart';
import 'package:riverpodtemp/presentation/components/loading.dart';
import 'package:riverpodtemp/presentation/theme/theme.dart';
import 'package:riverpodtemp/infrastructure/services/app_assets.dart';
import 'package:riverpodtemp/presentation/components/app_bars/common_app_bar.dart';

@RoutePage()
class TermPage extends ConsumerStatefulWidget {
  const TermPage({super.key});

  @override
  ConsumerState<TermPage> createState() => _TermPageState();
}

class _TermPageState extends ConsumerState<TermPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(profileProvider.notifier).getTerm(context: context);
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
                      style: AppStyle.interSemi(color: AppStyle.brandGreen),
                    ),
                  ),
                ),
              ],
            ),
          ),
          state.isTermLoading
              ? const Center(child: Loading())
              : Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Html(
                    data: state.term?.description ?? "",
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
