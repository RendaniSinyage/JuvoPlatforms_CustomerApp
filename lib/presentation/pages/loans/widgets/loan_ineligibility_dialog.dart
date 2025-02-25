import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodyman/infrastructure/services/app_helpers.dart';
import 'package:foodyman/infrastructure/services/tr_keys.dart';
import 'package:foodyman/presentation/components/buttons/custom_button.dart';
import 'package:foodyman/presentation/theme/app_style.dart';

class LoanIneligibilityDialog extends ConsumerWidget {
  final Map<String, dynamic> eligibilityData;
  final Function() onUnderstood;

  const LoanIneligibilityDialog({
    super.key,
    required this.eligibilityData,
    required this.onUnderstood,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Loan Application Declined',
          style: AppStyle.interSemi(size: 16.sp, color: AppStyle.red),
          textAlign: TextAlign.center,
        ),
        16.verticalSpace,
        Text(
          'Unfortunately, you are not eligible for a loan at this time.',
          style: AppStyle.interNormal(size: 14.sp),
          textAlign: TextAlign.center,
        ),
        16.verticalSpace,
        Text(
          'Reasons:',
          style: AppStyle.interSemi(size: 14.sp),
          textAlign: TextAlign.center,
        ),
        8.verticalSpace,
        ..._buildIneligibilityReasons(),
        24.verticalSpace,
        CustomButton(
          background: AppStyle.red,
          textColor: AppStyle.white,
          title: 'I Understand',
          onPressed: () {
            onUnderstood();
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  List<Widget> _buildIneligibilityReasons() {
    final List<Widget> reasons = [];

    if (eligibilityData['income_too_low'] == true) {
      reasons.add(
        Padding(
          padding: EdgeInsets.symmetric(vertical: 4.h),
          child: Text(
            '• Monthly income is insufficient',
            style: AppStyle.interNormal(size: 14.sp),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (eligibilityData['debt_to_income_ratio_high'] == true) {
      reasons.add(
        Padding(
          padding: EdgeInsets.symmetric(vertical: 4.h),
          child: Text(
            '• Debt-to-income ratio is too high',
            style: AppStyle.interNormal(size: 14.sp),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (eligibilityData['insufficient_credit_score'] == true) {
      reasons.add(
        Padding(
          padding: EdgeInsets.symmetric(vertical: 4.h),
          child: Text(
            '• Credit score does not meet our requirements',
            style: AppStyle.interNormal(size: 14.sp),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (eligibilityData['has_unpaid_loans'] == true) {
      reasons.add(
        Padding(
          padding: EdgeInsets.symmetric(vertical: 4.h),
          child: Text(
            '• You have unpaid loans',
            style: AppStyle.interNormal(size: 14.sp),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    // Add a generic reason if no specific reasons are provided
    if (reasons.isEmpty) {
      reasons.add(
        Padding(
          padding: EdgeInsets.symmetric(vertical: 4.h),
          child: Text(
            '• You do not meet our eligibility criteria',
            style: AppStyle.interNormal(size: 14.sp),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return reasons;
  }
}