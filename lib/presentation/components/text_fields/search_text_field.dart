import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:riverpodtemp/infrastructure/services/app_helpers.dart';
import 'package:riverpodtemp/infrastructure/services/tr_keys.dart';
import '../../theme/theme.dart';

class SearchTextField extends StatelessWidget {
  final String? hintText;
  final Widget? suffixIcon;
  final TextEditingController? textEditingController;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final Color bgColor;
  final bool isBorder;
  final bool isRead;
  final bool autofocus;
  final bool isSearchIcon;

  const SearchTextField({
    super.key,
    this.hintText,
    this.suffixIcon,
    this.textEditingController,
    this.onChanged,
    this.bgColor = AppStyle.transparent,
    this.isBorder = false,
    this.isRead = false,
    this.autofocus = false,
    this.onTap,
    this.isSearchIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: isRead,
      autocorrect: true,
      autofocus: autofocus,
      onTap: onTap,
      style: AppStyle.interRegular(
        size: 16,
        color: AppStyle.black,
      ),
      onChanged: onChanged,
      controller: textEditingController,
      cursorColor: AppStyle.black,
      cursorWidth: 1,
      decoration: InputDecoration(
        hintStyle: AppStyle.interNormal(
          size: 13,
          color: AppStyle.hintColor,
        ),
        hintText: hintText ?? AppHelpers.getTranslation(TrKeys.searchProducts),
        contentPadding: REdgeInsets.symmetric(horizontal: 15, vertical: 14),
        prefixIcon: isSearchIcon
            ? Icon(
                FlutterRemix.search_2_line,
                size: 20.r,
                color: AppStyle.black,
              )
            : null,
        suffixIcon: suffixIcon,
        fillColor: bgColor,
        filled: true,
        focusedBorder: isBorder
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide:
                    const BorderSide(color: AppStyle.borderColor, width: 1.2))
            : InputBorder.none,
        border: isBorder
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide:
                    const BorderSide(color: AppStyle.borderColor, width: 1.2))
            : InputBorder.none,
        enabledBorder: isBorder
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide:
                    const BorderSide(color: AppStyle.borderColor, width: 1.2))
            : InputBorder.none,
      ),
    );
  }
}
