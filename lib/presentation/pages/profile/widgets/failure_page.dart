import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodyman/presentation/components/buttons/custom_button.dart';
import 'package:foodyman/presentation/theme/app_style.dart';

import '../../../../infrastructure/services/app_helpers.dart';
import '../../../../infrastructure/services/tr_keys.dart';

class FailurePage extends StatelessWidget {
  const FailurePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              16.verticalSpace,
              Text(
                AppHelpers.getTranslation(TrKeys.checkout),
                style: AppStyle.interSemi(color: AppStyle.textGrey, size: 22),
              ),
              42.verticalSpace,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.r),
                child: Image.asset("assets/images/payment_rejected.png"),
              ),
              6.verticalSpace,
              Align(
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      AppHelpers.getTranslation(TrKeys.paymentRejected),
                      style: AppStyle.interBold(
                          color: AppStyle.textGrey, size: 20),
                    ),
                    6.verticalSpace,
                    Text(
                      AppHelpers.getTranslation(TrKeys.tryAgain),
                      style: AppStyle.interNormal(
                          color: AppStyle.textGrey, size: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.r),
        child: SizedBox(
          height: 60.r,
          width: double.infinity,
          child: CustomButton(
            title: AppHelpers.getTranslation(TrKeys.returnHome),
            background: AppStyle.primary,
            textColor: AppStyle.white,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}