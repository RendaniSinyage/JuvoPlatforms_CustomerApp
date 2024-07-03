import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:riverpodtemp/infrastructure/models/models.dart';
import 'package:riverpodtemp/infrastructure/services/app_helpers.dart';
import 'package:riverpodtemp/infrastructure/services/tr_keys.dart';
import 'package:riverpodtemp/presentation/theme/theme.dart';

import '../../../../application/shop/shop_provider.dart';
import 'shop_tab_bar_item.dart';

Timer? timer;

Widget makeTabBarHeader(
    {TabController? tabController,
    ValueChanged<int>? onTab,
    int index = 0,
    bool category = false,
    TextEditingController? controller,
    required String shopId,
    required String? cartId,
    required bool isPopularProduct,
    required List<CategoryData>? list,
    required BuildContext context}) {
  return Container(
    height: 100.h,
    width: double.infinity,
    padding: REdgeInsets.symmetric(horizontal: 15),
    decoration: BoxDecoration(
      color: AppStyle.bgGrey,
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.w), topRight: Radius.circular(16.w)),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Consumer(
          builder: (context, ref, child) {
            if (ref.read(shopProvider).products.isNotEmpty) {
              return AnimatedContainer(
                margin: EdgeInsets.only(
                    top: ref.watch(shopProvider).isSearchEnabled ? 20 : 25),
                duration: const Duration(milliseconds: 400),
                width: ref.watch(shopProvider).isSearchEnabled
                    ? MediaQuery.sizeOf(context).width - 36
                    : 45,
                padding: const EdgeInsets.only(right: 7),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (ref.watch(shopProvider).isSearchEnabled)
                      Column(
                        children: [
                          Text(
                            AppHelpers.getTranslation(TrKeys.searchProducts),
                            style: AppStyle.interNoSemi(size: 12),
                            maxLines: 1,
                            overflow: TextOverflow.fade,
                          ),
                          4.verticalSpace,
                        ],
                      ),
                    TextField(
                      controller: controller,
                      cursorColor: AppStyle.brandGreen,
                      readOnly: !ref.watch(shopProvider).isSearchEnabled,
                      onChanged: (value) {
                        timer?.cancel();
                        Timer(const Duration(seconds: 1), () {
                          ref
                              .read(shopProvider.notifier)
                              .changeSearchText(value);
                        });
                      },
                      decoration: InputDecoration(
                        contentPadding:  REdgeInsets.all(16),
                        suffixIcon: ref.watch(shopProvider).isSearchEnabled
                            ? GestureDetector(
                                onTap: () {
                                  controller?.clear();
                                  ref
                                      .read(shopProvider.notifier)
                                      .changeSearchText('');
                                  ref
                                      .read(shopProvider.notifier)
                                      .enableSearch();
                                },
                                child: const Icon(
                                  CupertinoIcons.xmark_circle,
                                  color: Colors.black,
                                ),
                              )
                            : null,
                        prefixIcon: GestureDetector(
                          onTap: () {
                            if (!ref.watch(shopProvider).isSearchEnabled) {
                              ref.read(shopProvider.notifier).enableSearch();
                            }
                          },
                          child: Container(
                            decoration: ref.watch(shopProvider).isSearchEnabled
                                ? null
                                : BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.grey.shade300),
                            child: const Icon(
                              Icons.search,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        border: !ref.watch(shopProvider).isSearchEnabled
                            ? InputBorder.none
                            : OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.black, width: .5),
                                borderRadius: BorderRadius.circular(10),
                              ),
                        enabledBorder: !ref.watch(shopProvider).isSearchEnabled
                            ? InputBorder.none
                            : OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.black, width: .5),
                                borderRadius: BorderRadius.circular(10),
                              ),
                        focusedBorder: !ref.watch(shopProvider).isSearchEnabled
                            ? InputBorder.none
                            : OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.black, width: .5),
                                borderRadius: BorderRadius.circular(10),
                              ),
                        disabledBorder: !ref.watch(shopProvider).isSearchEnabled
                            ? InputBorder.none
                            : OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.black, width: .5),
                                borderRadius: BorderRadius.circular(10),
                              ),
                      ),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
        Expanded(
          child: CustomPaint(
            foregroundPainter: FadingEffect(),
            child: Consumer(
              builder: (context, ref, child) {
                return TabBar(
                  indicatorSize: TabBarIndicatorSize.tab,
                  onTap: (e) {
                    onTab?.call(e);
                  },
                  padding: EdgeInsets.only(left: 8.r),
                  labelPadding: EdgeInsets.zero,
                  // physics: const NeverScrollableScrollPhysics(),
                  isScrollable: true,
                  indicatorPadding: EdgeInsets.zero,
                  indicatorColor: AppStyle.transparent,
                  labelColor: AppStyle.brandGreen,
                  unselectedLabelColor: AppStyle.white,
                  controller: tabController,
                  tabs: [
                    if (ref.watch(shopProvider).popularProducts.isNotEmpty)
                      ShopTabBarItem(
                        title: AppHelpers.getTranslation(TrKeys.popular),
                        isActive: index == 0,
                        image: '',
                        category: CategoryData(),
                        onTap: () {
                          tabController?.index = 0;
                          onTab?.call(0);
                        },
                      ),
                    ...list!.map(
                      (e) => ShopTabBarItem(
                        title: e.translation?.title ?? "",
                        isActive: index == (list.indexOf(e) + 1),
                        image: e.img ?? "",
                        category: e,
                        onTap: () {
                          tabController?.index = (list.indexOf(e) + 1);
                          onTab?.call(list.indexOf(e) + 1);
                        },
                      ),
                    )
                  ],
                );
              },
            ),
          ),
        ),
        // Consumer(
        //     builder: (context, ref, child) => Column(
        //           mainAxisAlignment: MainAxisAlignment.center,
        //           children: [
        //             const SizedBox(
        //               height: 27,
        //             ),
        //             CircleAvatar(
        //               radius: ref.watch(shopProvider).isSearchEnabled ? 0 : 20,
        //               backgroundColor: Colors.grey.shade200,
        //               child: Icon(
        //                 Icons.menu,
        //                 color: Colors.black,
        //                 size: ref.watch(shopProvider).isSearchEnabled ? 0 : 23,
        //               ),
        //             ),
        //           ],
        //         )),
      ],
    ),
  );
}

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
          Colors.grey.shade50.withOpacity(.3),
          Colors.grey.shade50.withOpacity(.2),
          Colors.grey.shade50.withOpacity(.1),
        ]);
    Paint paint = Paint()..shader = lg.createShader(rect);
    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(FadingEffect oldDelegate) => false;
}
