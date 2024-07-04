import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../theme/app_style.dart';

class BadgeItem extends StatelessWidget {
  final Color? color;
  final double? size;

  const BadgeItem({super.key, this.color, this.size});

  @override
  Widget build(BuildContext context) {
    return Icon(
      Remix.verified_badge_line,
      size: size ?? 15,
      color: color ?? AppStyle.starColor,
    );
  }
}