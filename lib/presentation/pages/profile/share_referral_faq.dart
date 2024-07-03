import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:riverpodtemp/infrastructure/services/app_helpers.dart';
import 'package:riverpodtemp/infrastructure/services/tr_keys.dart';
import 'package:riverpodtemp/presentation/components/app_bars/common_app_bar.dart';
import 'package:riverpodtemp/presentation/theme/app_style.dart';

import '../../../infrastructure/services/local_storage.dart';
import '../../components/buttons/pop_button.dart';


@RoutePage()
class ShareReferralFaqPage extends StatefulWidget {
  final String terms;
  const ShareReferralFaqPage({super.key, required this.terms});

  @override
  State<ShareReferralFaqPage> createState() => _ShareReferralFaqPageState();
}

class _ShareReferralFaqPageState extends State<ShareReferralFaqPage> {
  final bool isLtr = LocalStorage.getLangLtr();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: isLtr ? TextDirection.ltr : TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppStyle.bgGrey,
        body: Column(
          children: [
            CommonAppBar(
              child: Text(
                AppHelpers.getTranslation(TrKeys.referralFaq),
                style: AppStyle.interNoSemi(
                  size: 18,
                  color: AppStyle.black,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.r),
              child: Text(
                widget.terms,
                style: AppStyle.interNoSemi(
                  size: 20,
                  color: AppStyle.black,
                ),
              ),
            )
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        floatingActionButton: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: const PopButton(),
        ),
      ),
    );
  }
}
