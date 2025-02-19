import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BadgeItem extends StatelessWidget {
  const BadgeItem({super.key});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset("assets/svgs/badge.svg",height: 16.r,);
  }
}
