import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodyman/infrastructure/models/response/all_products_response.dart';
import 'package:foodyman/presentation/pages/shop/widgets/shimmer_category_list.dart';
import 'package:foodyman/presentation/theme/theme.dart';

import 'tab_search.dart';

class CategoryTabBar extends StatefulWidget {
  const CategoryTabBar({
    super.key,
    required this.controller,
    required this.textController,
    required this.data,
    required this.isLoading,
    required this.overlapsContent,
  });

  final TabController controller;
  final TextEditingController textController;
  final List<All> data;
  final bool overlapsContent;
  final bool isLoading;

  @override
  State<CategoryTabBar> createState() => _CategoryTabBarState();
}

class _CategoryTabBarState extends State<CategoryTabBar> {
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: widget.overlapsContent ? 16 : 0,
      shadowColor: Colors.black38,
      child: CustomPaint(
        foregroundPainter: FadingEffect(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            12.horizontalSpace,
            TabSearch(controller: widget.textController),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) => widget.isLoading
                    ? const ShimmerCategoryList()
                    : TabBar(
                        controller: widget.controller,
                        isScrollable: true,
                        padding: REdgeInsets.only(
                            top: MediaQuery.paddingOf(context).top - 8,
                            bottom: 8,
                            left: 12,
                            right: 16),
                        labelPadding: REdgeInsets.symmetric(horizontal: 16),
                        indicatorWeight: 6,
                        onTap: (index) {
                          GlobalKey globalKey = widget.data[index].key!;
                          Scrollable.ensureVisible(
                            globalKey.currentContext!,
                            duration: const Duration(milliseconds: 250),
                          );
                        },
                        indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          color: AppStyle.primary,
                        ),
                        tabs: List.generate(widget.data.length, (index) {
                          var item = widget.data[index];
                          return Container(
                            height: 48.r,
                            // duration: const Duration(milliseconds: 300),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.r),
                              boxShadow: [
                                BoxShadow(
                                  color: AppStyle.white.withOpacity(0.07),
                                  spreadRadius: 0,
                                  blurRadius: 2,
                                  offset: const Offset(
                                      0, 1), // changes position of shadow
                                ),
                              ],
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              item.translation?.title ?? '',
                              style: AppStyle.interNormal(
                                size: 13,
                                color: AppStyle.black,
                              ),
                            ),
                          );
                        }),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Timer? timer;

class FadingEffect extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Rect rect =
        Rect.fromPoints(const Offset(0, 0), Offset(size.width, size.height));
    LinearGradient lg = LinearGradient(
        begin: Alignment.centerRight,
        end: Alignment.centerLeft,
        colors: [
          AppStyle.bgGrey,
          Colors.grey.shade50.withOpacity(.4),
          Colors.grey.shade50.withOpacity(.1),
          Colors.grey.shade50.withOpacity(.01),
          Colors.transparent,
          Colors.transparent,
        ]);
    Paint paint = Paint()..shader = lg.createShader(rect);
    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(FadingEffect oldDelegate) => false;
}
