import 'dart:math' show cos, sqrt, asin;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:remixicon/remixicon.dart';
import '../../../app_constants.dart';
import '../../../infrastructure/models/data/shop_data.dart';
import '../../../infrastructure/services/app_helpers.dart';
import '../../../infrastructure/services/tr_keys.dart';
import '../../theme/app_style.dart';
import '../../../infrastructure/services/local_storage.dart';
import '../../../utils/utils.dart';

class DistanceBadge extends StatelessWidget {
  final ShopData shop;
  final double? bottom;
  final double? left;
  final double? right;
  final double? top;

  const DistanceBadge({
    super.key,
    required this.shop,
    this.bottom,
    this.left,
    this.right,
    this.top,
  });

  @override
  Widget build(BuildContext context) {
    final double distance = _calculateDistance();
    final String displayText = _getDisplayText(distance);

    return !(distance == 0) ? Positioned(
      bottom: bottom ?? 80.h,
      left: left,
      right: right ?? 15.w,
      top: top,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Row(
              children: [
                const Icon(
                  Remix.walk_fill,
                  color: AppStyle.white,
                  size: 15,
                ),
                Text(
                  displayText,
                  style: AppStyle.interNormal(
                    color: AppStyle.white,
                    size: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    ) : const SizedBox.shrink();
  }

  double _calculateDistance() {
    final selectedLocation = LocalStorage.getAddressSelected()?.location;
    if (shop.location == null ||
        shop.location!.latitude == null ||
        shop.location!.longitude == null ||
        selectedLocation == null) {
      return 0;
    } else {
      return calculateDistance(
        selectedLocation.latitude ?? AppConstants.demoLatitude,
        selectedLocation.longitude ?? AppConstants.demoLongitude,
        shop.location!.latitude ?? AppConstants.demoLatitude,
        shop.location!.longitude ?? AppConstants.demoLongitude,
      );
    }
  }

  String _getDisplayText(double distance) {
    if (distance == 0) {
      return "| You are here";
    }
    return "| ${distance.toStringAsFixed(2)} ${AppHelpers.getTranslation(TrKeys.km)}";
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double p = 0.017453292519943295; // PI / 180
    final double a = 0.5 - cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) *
            (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a)); // 2 * R; R = 6371 km
  }
}
