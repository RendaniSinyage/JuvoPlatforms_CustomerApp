import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpodtemp/application/app_widget/app_provider.dart';

import '../../theme/theme.dart';

class ForgotTextButton extends ConsumerWidget {
  final String title;
  final Function() onPressed;
  final double? fontSize;
  final Color? fontColor;
  final double? letterSpacing;

  const ForgotTextButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.fontSize,
    this.fontColor = AppStyle.black,
    this.letterSpacing = -14 * 0.02,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(appProvider);
    return TextButton(
      style: ButtonStyle(
        overlayColor: WidgetStateColor.resolveWith(
          (states) => state.isDarkMode
              ? AppStyle.mainBackDark
              : AppStyle.dontHaveAccBtnBack,
        ),
      ),
      onPressed: onPressed,
      child: Text(
        title,
        style: AppStyle.interNormal(
          textDecoration: TextDecoration.underline,
          size: 12,
          color: AppStyle.black,
        ),
      ),
    );
  }
}
