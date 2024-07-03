import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/app_style.dart';

class ResendButton extends StatelessWidget {
  final String title;
  final IconData iconData;
  final bool isTimeExpired;
  final bool isResending;
  final Function()? onPressed;

  const ResendButton({
    super.key,
    required this.title,
    this.iconData = FlutterRemix.refresh_line,
    this.isTimeExpired = false,
    this.isResending = false,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        shadowColor: AppStyle.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        minimumSize: Size(97.r, 46.r),
        backgroundColor: AppStyle.black,
      ),
      onPressed: onPressed,
      child: isTimeExpired
          ? isResending
              ? SizedBox(
                  width: 10.r,
                  height: 10.r,
                  child: CircularProgressIndicator(
                    strokeWidth: 1.r,
                    color: AppStyle.white,
                  ),
                )
              : Icon(
                  iconData,
                  color: AppStyle.white,
                  size: 20,
                )
          : Text(
              title,
              style: AppStyle.interNormal(
                size: 15,
                color: AppStyle.white,
              ),
            ),
    );
  }
}
