// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodyman/infrastructure/services/app_helpers.dart';
import 'package:foodyman/infrastructure/services/tr_keys.dart';
import 'package:foodyman/presentation/theme/app_style.dart';

class BottomNavigatorOne extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavigatorOne(
      {super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppStyle.black,
        onTap: onTap,
        items: [
          BottomNavigationBarItem(
              icon: const Icon(FlutterRemix.home_smile_fill),
              label: AppHelpers.getTranslation(TrKeys.home)),
          BottomNavigationBarItem(
              icon: const Icon(FlutterRemix.apps_2_line),
              label: AppHelpers.getTranslation(TrKeys.allServices)),
          BottomNavigationBarItem(
              icon: SvgPicture.asset(
                "assets/svgs/box.svg",
                color: currentIndex == 3 ? AppStyle.black : AppStyle.textGrey,
              ),
              label: AppHelpers.getTranslation(TrKeys.fosend)),
          BottomNavigationBarItem(
              icon: const Icon(FlutterRemix.shopping_bag_3_line),
              label: AppHelpers.getTranslation(TrKeys.cart)),
        ]);
  }
}
