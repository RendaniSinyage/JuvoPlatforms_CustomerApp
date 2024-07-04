import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:riverpodtemp/infrastructure/services/app_helpers.dart';
import 'package:riverpodtemp/infrastructure/services/tr_keys.dart';
import 'package:riverpodtemp/presentation/components/buttons/custom_button.dart';
import 'package:riverpodtemp/presentation/theme/theme.dart';

class CartClearDialog extends StatelessWidget {
  final VoidCallback cancel;
  final VoidCallback clear;
  final bool isLoading;
  const CartClearDialog({super.key, required this.cancel, required this.clear, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (MediaQuery.sizeOf(context).width-60.w),
      decoration: BoxDecoration(
        color: AppStyle.white.withOpacity(0.96),
        boxShadow: [
          BoxShadow(
            color: AppStyle.white.withOpacity(0.65),
            spreadRadius: 0,
            blurRadius: 60,
            offset: const Offset(0, 20), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AppHelpers.getTranslation(TrKeys.clearCard),
            style: AppStyle.interNormal(
              size: 14,
              color: AppStyle.black,
            ),
          ),
          50.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: CustomButton(
                  title: AppHelpers.getTranslation(TrKeys.cancel),
                  onPressed: cancel,
                  background: AppStyle.transparent,
                  textColor: AppStyle.black,
                  borderColor: AppStyle.borderColor,
                ),
              ),
              16.horizontalSpace,
              Expanded(
                child: CustomButton(
                  title: AppHelpers.getTranslation(TrKeys.clear),
                  onPressed: clear,
                  background: AppStyle.red,
                  textColor: AppStyle.white,
                  isLoading: isLoading,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
