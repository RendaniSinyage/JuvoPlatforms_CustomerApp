// ignore_for_file: library_private_types_in_public_api, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:riverpodtemp/presentation/theme/app_style.dart';

class BottomNavigatorThree extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavigatorThree(
      {super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: REdgeInsets.symmetric(horizontal: 24),
      child: FloatingNavbar(
        onTap: onTap,
        currentIndex: currentIndex,
        items: [
          FloatingNavbarItem(
            customWidget: SvgPicture.asset(
              "assets/svgs/home3.svg",
              color: currentIndex == 0 ? AppStyle.black : AppStyle.textGrey,
            ),
            // title: AppHelpers.getTranslation(TrKeys.shops),
          ),
          FloatingNavbarItem(
            customWidget: SvgPicture.asset(
              "assets/svgs/category3.svg",
              color: currentIndex == 1 ? AppStyle.black : AppStyle.textGrey,
            ),
            // title: AppHelpers.getTranslation(TrKeys.allServices),
          ),
          FloatingNavbarItem(
            customWidget: SvgPicture.asset(
              "assets/svgs/fosend3.svg",
              color: currentIndex == 2 ? AppStyle.black : AppStyle.textGrey,
            ),
            // title: AppHelpers.getTranslation(TrKeys.cart),
          ),
          FloatingNavbarItem(
            customWidget: SvgPicture.asset(
              "assets/svgs/bag3.svg",
              color: currentIndex == 3 ? AppStyle.black : AppStyle.textGrey,
            ),
            // title: AppHelpers.getTranslation(TrKeys.cart),
          ),
        ],
      ),
    );
  }
}

typedef ItemBuilder = Widget Function(
    BuildContext context, int index, FloatingNavbarItem items);

class FloatingNavbar extends StatefulWidget {
  final List<FloatingNavbarItem> items;
  final int currentIndex;
  final void Function(int val)? onTap;
  final Color selectedBackgroundColor;
  final Color? selectedItemColor;
  final Color? unselectedItemColor;
  final Color backgroundColor;
  final ItemBuilder itemBuilder;
  final double width;
  final double elevation;

  FloatingNavbar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
    ItemBuilder? itemBuilder,
    this.backgroundColor = AppStyle.white,
    this.selectedBackgroundColor = AppStyle.transparent,
    this.selectedItemColor = AppStyle.black,
    this.unselectedItemColor = AppStyle.textGrey,
    this.width = double.infinity,
    this.elevation = 0.0,
  })  : assert(items.length > 1),
        assert(items.length <= 5),
        assert(currentIndex <= items.length),
        assert(width > 50),
        itemBuilder = itemBuilder ??
            _defaultItemBuilder(
              unselectedItemColor: unselectedItemColor,
              selectedItemColor: selectedItemColor,
              width: width,
              backgroundColor: backgroundColor,
              currentIndex: currentIndex,
              items: items,
              onTap: onTap,
              selectedBackgroundColor: selectedBackgroundColor,
            );

  @override
  _FloatingNavbarState createState() => _FloatingNavbarState();
}

class _FloatingNavbarState extends State<FloatingNavbar> {
  List<FloatingNavbarItem> get items => widget.items;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(36.r),
            color: widget.backgroundColor,
            boxShadow: const [
              BoxShadow(
                color: AppStyle.shadowBottom,
                blurRadius: 20,
                offset: Offset(0, -4),
                spreadRadius: 0,
              )
            ],
          ),
          width: widget.width,
          child: Padding(
            padding: REdgeInsets.all(6),
            child: Container(
              padding: REdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                color: AppStyle.bgGrey,
                borderRadius: BorderRadius.circular(32.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.max,
                children: items
                    .asMap()
                    .map((i, f) =>
                        MapEntry(i, widget.itemBuilder(context, i, f)))
                    .values
                    .toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

ItemBuilder _defaultItemBuilder({
  Function(int val)? onTap,
  required List<FloatingNavbarItem> items,
  int? currentIndex,
  Color? selectedBackgroundColor,
  Color? selectedItemColor,
  Color? unselectedItemColor,
  Color? backgroundColor,
  double width = double.infinity,
}) {
  return (BuildContext context, int index, FloatingNavbarItem item) => Expanded(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                color: currentIndex == index
                    ? selectedBackgroundColor
                    : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: InkWell(
                onTap: () => onTap!(index),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: width.isFinite
                      ? (width / items.length - 8)
                      : MediaQuery.of(context).size.width / items.length - 24,
                  padding: REdgeInsets.all(10),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      item.customWidget == null
                          ? Icon(
                              item.icon,
                              color: currentIndex == index
                                  ? selectedItemColor
                                  : unselectedItemColor,
                              size: currentIndex == index ? 26 : 24,
                            )
                          : item.customWidget!,
                      if (item.title != null)
                        Text(
                          '${item.title}',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: currentIndex == index
                                ? selectedItemColor
                                : unselectedItemColor,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}

class FloatingNavbarItem {
  final String? title;
  final IconData? icon;
  final Widget? customWidget;

  FloatingNavbarItem({
    this.icon,
    this.title,
    this.customWidget,
  }) : assert(icon != null || customWidget != null);
}
