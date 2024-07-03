import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:riverpodtemp/application/profile/profile_provider.dart';
import 'package:riverpodtemp/infrastructure/services/app_helpers.dart';
import 'package:riverpodtemp/infrastructure/services/tr_keys.dart';
import 'package:riverpodtemp/presentation/components/buttons/pop_button.dart';
import 'package:riverpodtemp/presentation/components/loading.dart';
import 'package:riverpodtemp/presentation/theme/theme.dart';

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
      body: SafeArea(
        child: Column(
          children: [
            Text(
              AppHelpers.getTranslation(TrKeys.terms),
              style: AppStyle.interNoSemi(size: 18),
            ),
            state.isTermLoading
                ? const Center(child: Loading())
                : Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(16.r),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            state.term?.title ?? "",
                            style: AppStyle.interNoSemi(),
                          ),
                          8.verticalSpace,
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
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: const PopButton(),
    );
  }
}
