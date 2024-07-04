import 'package:flutter/material.dart';
import '../../../infrastructure/services/app_helpers.dart';
import '../../../infrastructure/services/tr_keys.dart';
import '../../../presentation/theme/theme.dart'; // Import your theme file

class ComingSoonDialog extends StatelessWidget {
  const ComingSoonDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20), // Adjust the radius as needed
      child: AlertDialog(
        backgroundColor: AppStyle.white, // Use your app's color theme
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // Match this with ClipRRect
        ),
        title: Text(
          AppHelpers.getTranslation(TrKeys.comingSoon),
          style: AppStyle.interBold(size: 18, color: AppStyle.black),
        ),
        content: Text(
          AppHelpers.getTranslation(TrKeys.featureNotAvailable),
          style: AppStyle.interRegular(size: 16, color: AppStyle.black),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              AppHelpers.getTranslation(TrKeys.ok),
              style: AppStyle.interBold(size: 16, color: AppStyle.brandGreen),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}