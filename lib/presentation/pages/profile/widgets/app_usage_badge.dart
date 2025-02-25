// lib/presentation/pages/profile/widgets/app_usage_badge.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:remixicon/remixicon.dart';
import 'package:foodyman/infrastructure/services/app_helpers.dart';
import 'package:foodyman/infrastructure/services/tr_keys.dart';
import 'package:foodyman/presentation/theme/theme.dart';

import '../../../../utils/app_usage_service.dart';

class AppUsageBadge extends StatefulWidget {
  const AppUsageBadge({Key? key}) : super(key: key);

  @override
  State<AppUsageBadge> createState() => _AppUsageBadgeState();
}

class _AppUsageBadgeState extends State<AppUsageBadge> {
  int daysInAppThisYear = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAppUsage();
  }

  Future<void> _loadAppUsage() async {
    // Only get stats, don't record usage here
    final stats = await AppUsageService.getAppUsageStats();

    if (mounted) {
      setState(() {
        daysInAppThisYear = stats['days_in_app_this_year'] ?? 0;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.r),
      decoration: BoxDecoration(
        color: AppStyle.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: isLoading
          ? SizedBox(
        width: 16.r,
        height: 16.r,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(AppStyle.primary),
        ),
      )
          : Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Remix.calendar_2_line, color: AppStyle.primary, size: 16.r),
          SizedBox(width: 4.w),
          Text(
            '$daysInAppThisYear ${AppHelpers.getTranslation(TrKeys.daysInAppThisYear)}',
            style: AppStyle.interNormal(
              size: 12.sp,
              color: AppStyle.primary,
            ),
          ),
        ],
      ),
    );
  }
}