// loan_qualification_dialog.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../components/buttons/custom_button.dart';
import '../../../theme/theme.dart';

class LoanQualificationDialog extends ConsumerWidget {
  final Map<String, dynamic> eligibilityData;
  final double qualifyingAmount;
  final Function() onAccept;
  final Function() onDecline;

  const LoanQualificationDialog({
    super.key,
    required this.eligibilityData,
    required this.qualifyingAmount,
    required this.onAccept,
    required this.onDecline,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Loan Pre-Approval',
          style: AppStyle.interSemi(size: 16.sp, color: AppStyle.primary),
          textAlign: TextAlign.center,
        ),
        16.verticalSpace,
        Text(
          'Based on your financial information, you qualify for:',
          style: AppStyle.interNormal(size: 14.sp),
          textAlign: TextAlign.center,
        ),
        16.verticalSpace,
        Text(
          'R ${NumberFormat('#,##0').format(qualifyingAmount)}',
          style: AppStyle.interBold(size: 24.sp, color: AppStyle.primary),
          textAlign: TextAlign.center,
        ),
        24.verticalSpace,
        Row(
          children: [
            Expanded(
              child: CustomButton(
                background: AppStyle.white,
                borderColor: AppStyle.borderColor,
                textColor: AppStyle.textGrey,
                title: 'Decline',
                onPressed: () {
                  onDecline();
                  Navigator.pop(context);
                },
              ),
            ),
            16.horizontalSpace,
            Expanded(
              child: CustomButton(
                background: AppStyle.primary,
                textColor: AppStyle.white,
                title: 'Accept',
                onPressed: () {
                  onAccept();
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}