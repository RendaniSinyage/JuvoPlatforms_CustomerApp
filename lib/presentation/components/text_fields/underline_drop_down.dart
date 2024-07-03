import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:riverpodtemp/infrastructure/services/app_helpers.dart';
import 'package:riverpodtemp/presentation/theme/app_style.dart';

class UnderlineDropDown extends StatelessWidget {
  final String? value;
  final String? hint;
  final String? label;
  final List<String> list;
  final ValueChanged<String> onChanged;
  final String? Function(String?)? validator;

  const UnderlineDropDown({
    super.key,
    this.value,
    required this.list,
    required this.onChanged,
    this.hint,
    this.label,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      padding: EdgeInsets.zero,
      hint: Text(
        AppHelpers.getTranslation(hint ?? ''),
        style: AppStyle.interNormal(
          size: 14,
          color: AppStyle.black.withOpacity(0.7),
        ),
      ),
      value: value,
      validator: validator,
      items: list.map((e) {
        return DropdownMenuItem(
            value: e,
            child: Text(
              AppHelpers.getTranslation(e),
            ));
      }).toList(),
      onChanged: (s) => onChanged.call(s.toString()),
      elevation: 0,
      dropdownColor: AppStyle.white,
      iconEnabledColor: AppStyle.black,
      borderRadius: BorderRadius.circular(8.r),
      style: AppStyle.interNormal(),
      decoration: InputDecoration(
        contentPadding: REdgeInsets.symmetric(horizontal: 2),
        labelText:
        label != null ? "${AppHelpers.getTranslation(label!)}*" : null,
        labelStyle: AppStyle.interNormal(
          size: 14,
          color: AppStyle.black.withOpacity(0.9),
        ),
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide.merge(
                const BorderSide(color: AppStyle.differBorderColor),
                const BorderSide(color: AppStyle.differBorderColor))),
        errorBorder: InputBorder.none,
        border: const UnderlineInputBorder(),
        focusedErrorBorder: const UnderlineInputBorder(),
        disabledBorder: UnderlineInputBorder(
            borderSide: BorderSide.merge(
                const BorderSide(color: AppStyle.differBorderColor),
                const BorderSide(color: AppStyle.differBorderColor))),
        focusedBorder: const UnderlineInputBorder(),
      ),
    );
  }
}