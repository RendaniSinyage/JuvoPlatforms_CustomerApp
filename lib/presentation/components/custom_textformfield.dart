import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/theme.dart';

class CustomTextFormField extends StatelessWidget {
  final String? hint;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool? obscure;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final VoidCallback? onTap;
  final String? Function(String?)? validation;
  final TextInputType? inputType;
  final List<TextInputFormatter>? inputFormatters;
  final String? initialText;
  final bool readOnly;
  final bool isError;
  final bool autoFocus;
  final double radius;

  const CustomTextFormField({
    Key? key,
    this.suffixIcon,
    this.prefixIcon,
    this.onTap,
    this.obscure,
    this.validation,
    this.onChanged,
    this.controller,
    this.inputType,
    this.initialText,
    this.readOnly = false,
    this.isError = false,
    this.hint = "",
    this.radius = 16,
    this.autoFocus = false,
    this.inputFormatters,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
      return TextFormField(
        autofocus: autoFocus,
        onTap: onTap,
        maxLength: 200,
        onChanged: onChanged,
        autocorrect: true,
        inputFormatters: inputFormatters,
        obscureText: !(obscure ?? true),
        obscuringCharacter: '*',
        controller: controller,
        validator: validation,
        style: AppStyle.interNormal(
          size: 14.sp,
          color: AppStyle.textGrey,
        ),
        cursorWidth: 1,
        cursorColor: AppStyle.textGrey,
        keyboardType: inputType,
        initialValue: initialText,
        readOnly: readOnly,
        decoration: InputDecoration(
          counterText: "",
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 16.r, vertical: 16.r),
          hintText: hint,
          hintStyle: AppStyle.interNormal(
            size: 14.sp,
            color: AppStyle.hintColor,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          fillColor: AppStyle.black,
          filled: false,
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide.merge(
                const BorderSide(color: AppStyle.iconButtonBack, width: 0.9),
                const BorderSide(color: AppStyle.iconButtonBack, width: 0.9),
              ),
              borderRadius: BorderRadius.circular(radius.r)),
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide.merge(
                const BorderSide(color: AppStyle.iconButtonBack, width: 0.9),
                const BorderSide(color: AppStyle.iconButtonBack, width: 0.9),
              ),
              borderRadius: BorderRadius.circular(radius.r)),
          border: OutlineInputBorder(
              borderSide: BorderSide.merge(
                const BorderSide(color: AppStyle.iconButtonBack, width: 0.9),
                const BorderSide(color: AppStyle.iconButtonBack, width: 0.9),
              ),
              borderRadius: BorderRadius.circular(radius.r)),
          focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide.merge(
                const BorderSide(color: AppStyle.iconButtonBack, width: 0.9),
                const BorderSide(color: AppStyle.iconButtonBack, width: 0.9),
              ),
              borderRadius: BorderRadius.circular(radius.r)),
          disabledBorder: OutlineInputBorder(
              borderSide: BorderSide.merge(
                const BorderSide(color: AppStyle.iconButtonBack, width: 0.9),
                const BorderSide(color: AppStyle.iconButtonBack, width: 0.9),
              ),
              borderRadius: BorderRadius.circular(radius.r)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide.merge(
                const BorderSide(color: AppStyle.iconButtonBack, width: 0.9),
                const BorderSide(color: AppStyle.iconButtonBack, width: 0.9),
              ),
              borderRadius: BorderRadius.circular(radius.r)),
        ),
      );
  }
}
