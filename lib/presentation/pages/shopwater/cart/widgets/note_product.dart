import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:riverpodtemp/infrastructure/services/app_helpers.dart';
import 'package:riverpodtemp/presentation/components/buttons/custom_button.dart';
import 'package:riverpodtemp/presentation/components/text_fields/outline_bordered_text_field.dart';
import 'package:riverpodtemp/presentation/components/title_icon.dart';

import '../../../../../infrastructure/services/tr_keys.dart';

class NoteProduct extends StatefulWidget {
  final String? comment;
  final bool isSave;
  final ValueChanged<String> onTap;

  const NoteProduct(
      {super.key, required this.onTap, this.comment, this.isSave = true});

  @override
  State<NoteProduct> createState() => _NoteProductState();
}

class _NoteProductState extends State<NoteProduct> {
  late TextEditingController controller;

  @override
  void initState() {
    controller =
        TextEditingController(text: widget.comment);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TitleAndIcon(
          title: AppHelpers.getTranslation(TrKeys.productNote),
          paddingHorizontalSize: 0,
        ),
        24.verticalSpace,
        OutlinedBorderTextField(
          readOnly: !widget.isSave,
          textController: controller,
          label: AppHelpers.getTranslation(TrKeys.comment).toUpperCase(),
        ),
        32.verticalSpace,
        if (widget.isSave)
          CustomButton(
              title: AppHelpers.getTranslation(TrKeys.save),
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  widget.onTap(controller.text);
                  Navigator.pop(context);
                }
              }),
      ],
    );
  }
}
