import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodyman/application/shop/shop_provider.dart';
import 'package:foodyman/infrastructure/services/app_helpers.dart';
import 'package:foodyman/infrastructure/services/tr_keys.dart';
import 'package:foodyman/presentation/theme/app_style.dart';

import 'category_tab_bar.widget.dart';

class TabSearch extends StatelessWidget {
  final TextEditingController? controller;

  const TabSearch({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return AnimatedContainer(
          margin: EdgeInsets.only(
              top: ref.watch(shopProvider).isSearchEnabled ? 20 : 25),
          duration: const Duration(milliseconds: 400),
          width: ref.watch(shopProvider).isSearchEnabled
              ? MediaQuery.sizeOf(context).width - 24
              : 40.r,
          padding: REdgeInsets.only(right: 12, top: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (ref.watch(shopProvider).isSearchEnabled)
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      AppHelpers.getTranslation(TrKeys.searchTheMenu),
                      style: AppStyle.interNoSemi(size: 12),
                      maxLines: 1,
                      overflow: TextOverflow.fade,
                    ),
                    4.verticalSpace,
                  ],
                )
              else
                4.verticalSpace,
              TextField(
                controller: controller,
                cursorColor: AppStyle.primary,
                readOnly: !ref.watch(shopProvider).isSearchEnabled,
                onChanged: (value) {
                  timer?.cancel();
                  Timer(const Duration(seconds: 1), () {
                    ref.read(shopProvider.notifier).changeSearchText(value);
                  });
                },
                decoration: InputDecoration(
                  contentPadding:
                      REdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  suffixIcon: ref.watch(shopProvider).isSearchEnabled
                      ? GestureDetector(
                          onTap: () {
                            controller?.clear();
                            ref
                                .read(shopProvider.notifier)
                                .changeSearchText('');
                            ref.read(shopProvider.notifier).enableSearch();
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
                          borderSide:
                              const BorderSide(color: Colors.black, width: .5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                  enabledBorder: !ref.watch(shopProvider).isSearchEnabled
                      ? InputBorder.none
                      : OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.black, width: .5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                  focusedBorder: !ref.watch(shopProvider).isSearchEnabled
                      ? InputBorder.none
                      : OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.black, width: .5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                  disabledBorder: !ref.watch(shopProvider).isSearchEnabled
                      ? InputBorder.none
                      : OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.black, width: .5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
