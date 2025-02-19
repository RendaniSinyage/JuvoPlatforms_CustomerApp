
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodyman/app_constants.dart';
import 'package:foodyman/infrastructure/services/time_service.dart';
import 'package:foodyman/infrastructure/services/app_helpers.dart';
import 'package:foodyman/infrastructure/services/tr_keys.dart';
import 'package:foodyman/presentation/theme/theme.dart';

class CustomTimePicker {
  static void getTimePicker(
      BuildContext context,
      {bool showSaveButton = false,
        Function? saveButton,
        required ValueChanged<String> onTimeChanged,
        required String helperText
      }
      ) {
    if (!Platform.isIOS) {
      _iosTimePicker(
        onTimeChanged,
        context,
        showSaveButton: showSaveButton,
        saveButtonOnTap: () {
          if (saveButton != null) saveButton();
        }
      );
    }
    else {
      _androidTimePicker(
        context,
        onTimeChanged,
        showSaveButton: showSaveButton,
        saveButtonOnTap: () {
          if (saveButton != null) saveButton();
        },
        helperText: helperText
      );
    }
  }

  static void _androidTimePicker(
      BuildContext context,
      ValueChanged<String> onTimeChanged,
      {bool showSaveButton = false,
        Function? saveButtonOnTap,
        required String helperText}
      ) async {
    var date = await showTimePicker(
      context: context,
      helpText: helperText,
      confirmText: AppHelpers.getTranslation(TrKeys.save),
      initialTime: TimeOfDay.now(),
    );
    if (date != null) {
      final String selectedDate = _dateToAmPm(
        hour: date.hour,
        minute: date.minute
      );
      onTimeChanged(selectedDate);
    }

    if (showSaveButton) {
      saveButtonOnTap!();
    }
  }

  static void _iosTimePicker(
      ValueChanged<String> onTimeChanged,
      BuildContext context,
      {bool showSaveButton = false, Function? saveButtonOnTap}) {
    showCupertinoModalPopup(
        context: context,
        builder: (_) => Container(
          color: AppStyle.white,
          child: Material(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                Visibility(
                    visible: showSaveButton,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        saveButtonOnTap!();
                      },
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        margin: EdgeInsets.only(
                          top: 20.h,
                          right: 20.w
                        ),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Text(
                            AppHelpers.getTranslation(TrKeys.save),
                            style: AppStyle.interSemi(
                              size: 16,
                              color: AppStyle.white,
                            ),
                          ),
                        ),
                      ),
                    )
                ),

                SizedBox(
                  height: 290.h,
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.time,
                    minuteInterval: 1,
                    use24hFormat: AppConstants.use24Format,
                    onDateTimeChanged: (value) {
                      final String selectedDate = _dateToAmPm(
                        hour: value.hour,
                        minute: value.minute
                      );
                      onTimeChanged(selectedDate);
                    },
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }

  static String _dateToAmPm({required int hour, required int minute}) {
    final DateTime now = DateTime.now();
    return TimeService.timeFormat(DateTime(
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    ));
  }
}
