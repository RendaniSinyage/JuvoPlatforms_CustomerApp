import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:riverpodtemp/infrastructure/services/app_helpers.dart';
import 'package:riverpodtemp/infrastructure/services/tr_keys.dart';
import 'package:riverpodtemp/presentation/components/custom_network_image.dart';
import 'package:riverpodtemp/presentation/theme/app_style.dart';

class ImageDialog extends StatelessWidget {
  final String? img;

  const ImageDialog({super.key, this.img});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                AppHelpers.getTranslation(TrKeys.thisImageWasUploadDriver),
                style: AppStyle.interNormal(),
              ),
            ),
            GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Padding(
                  padding: REdgeInsets.all(4),
                  child: const Icon(FlutterRemix.close_circle_line),
                )),
          ],
        ),
        12.verticalSpace,
        CustomNetworkImage(
          url: img,
          radius: 16,
        ),
      ],
    );
  }
}
