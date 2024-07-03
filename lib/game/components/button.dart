import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:riverpodtemp/presentation/theme/theme.dart';

import '../const/colors.dart';

class ButtonWidget extends StatelessWidget {


  const ButtonWidget(
      {super.key,
      this.text,
      this.icon,
      required this.onPressed});

  final String? text;
  final IconData? icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    if (icon != null) {
      return Container(
        padding: EdgeInsets.all(6.r),
        decoration: BoxDecoration(
            color: AppStyle.newStoreDataBorder,
            borderRadius: BorderRadius.circular(8.0)),
        child: IconButton(
            color: AppStyle.black,
            onPressed: onPressed,
            icon: Icon(
              icon,
              size: 32.0,
            )),
      );
    }
    return ElevatedButton(
        style: ButtonStyle(
            padding: WidgetStateProperty.all<EdgeInsets>(
                const EdgeInsets.all(16.0)),
            backgroundColor: WidgetStateProperty.all<Color>(buttonColor)),
        onPressed: onPressed,
        child: Text(
          text!,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
        ));
  }
}
