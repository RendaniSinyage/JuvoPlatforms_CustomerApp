import 'package:flutter/material.dart';
import 'package:foodyman/infrastructure/services/time_service.dart';

extension StringDate on String? {
  String get toTime {
    if (this == null) {
      return '';
    }
    final firstTime = this!.substring(0, this!.indexOf("-"));
    final endTime = this!.substring(this!.indexOf("-") + 2, this!.length);
    final start = TimeService.timeFormat(DateTime.now().copyWith(
      hour: int.tryParse(firstTime.substring(0, firstTime.indexOf(":"))),
      minute: int.tryParse(
          firstTime.substring(firstTime.indexOf(":") + 1, firstTime.length)),
    ));

    final end = TimeService.timeFormat(DateTime.now().copyWith(
      hour: int.tryParse(endTime.substring(0, endTime.indexOf(":"))),
      minute: int.tryParse(
          endTime.substring(endTime.indexOf(":") + 1, endTime.length)),
    ));

    return "$start - $end";
    // return this;
  }

  String get toSingleTime {
    if (this == null) {
      return '';
    }
    return TimeService.timeFormat(DateTime.now().copyWith(
      hour: int.tryParse(this!.substring(0, this!.indexOf("-"))),
      minute:
          int.tryParse(this!.substring(this!.indexOf("-") + 1, this!.length)),
    ));
  }

  TimeOfDay get toNextTime {
    return TimeOfDay(
      hour: int.tryParse(this?.substring((this?.indexOf("-") ?? 0)+2,(this?.lastIndexOf(":") ?? 0)) ?? '') ?? 0,
      minute: int.tryParse(this?.substring((this?.lastIndexOf(":") ?? 0) +1) ?? '') ?? 0,
    );
    // return TimeOfDay(
    //   hour: int.tryParse(this?.substring(0, (this?.indexOf(":") ?? 0)) ?? '') ??
    //       0,
    //   minute: int.tryParse(this?.substring(
    //               (this?.indexOf(":") ?? 0) + 1, (this?.indexOf(" ") ?? 0)) ??
    //           '') ??
    //       0,
    // );
  }

  TimeOfDay get toStartTime {
    return TimeOfDay(
      hour: int.tryParse(this?.substring(0, (this?.indexOf(":") ?? 0)) ?? '') ??
          0,
      minute: int.tryParse(this?.substring(
                  (this?.indexOf(":") ?? 0) + 1, (this?.indexOf(" ") ?? 0)) ??
              '') ??
          0,
    );
  }

  TimeOfDay get toTimeOfDay {
    return TimeOfDay(
      hour:
          int.tryParse(this?.substring(0, this?.indexOf("-") ?? 0) ?? "") ?? 0,
      minute:
          int.tryParse(this?.substring((this?.indexOf("-") ?? 0) + 1) ?? "") ??
              0,
    );
  }
}

extension Time on DateTime {
  DateTime get withoutTime => DateTime(year, month, day);

  DateTime addTime(String? time) {
    return copyWith(
        hour: int.tryParse(time?.substring(0, 2) ?? '0'),
        minute: int.tryParse(time?.substring(3, 5) ?? '00'),
        second: 0,
        millisecond: 0,
        microsecond: 0);
  }
}
