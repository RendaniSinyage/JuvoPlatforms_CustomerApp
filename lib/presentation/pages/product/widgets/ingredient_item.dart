import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:riverpodtemp/infrastructure/models/data/addons_data.dart';
import 'package:riverpodtemp/infrastructure/services/app_helpers.dart';
import 'package:riverpodtemp/presentation/theme/theme.dart';

import '../../../components/custom_checkbox.dart';

class IngredientItem extends ConsumerWidget {
  final VoidCallback onTap;
  final VoidCallback add;
  final VoidCallback remove;
  final Addons addon;

  const IngredientItem({
    required this.add,
    required this.remove,
    super.key,
    required this.onTap,
    required this.addon,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        onTap();
        Vibrate.feedback(FeedbackType.selection);
      },
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(vertical: 10.r),
        decoration: BoxDecoration(
            color: AppStyle.white,
            borderRadius: BorderRadius.all(Radius.circular(10.r))),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomCheckbox(
                  isActive: addon.active ?? false,
                  onTap: onTap,
                ),
                10.horizontalSpace,
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          addon.product?.translation?.title ?? "",
                          style: AppStyle.interNormal(
                            size: 16,
                            color: AppStyle.black,
                          ),
                        ),
                      ),
                      4.horizontalSpace,
                      Text(
                        "+${AppHelpers.numberFormat(number: addon.product?.stock?.totalPrice)}",
                        style: AppStyle.interNoSemi(
                          size: 14,
                          color: AppStyle.textGrey,
                        ),
                      )
                    ],
                  ),
                ),
                (addon.active ?? false)
                    ? Row(
                        children: [
                          IconButton(
                            onPressed: remove,
                            icon: Icon(
                              Icons.remove,
                              color: (addon.quantity ?? 1) == 1
                                  ? AppStyle.outlineButtonBorder
                                  : AppStyle.black,
                            ),
                          ),
                          Text(
                            "${addon.quantity ?? 1}",
                            style: AppStyle.interNormal(
                              size: 16.sp,
                            ),
                          ),
                          IconButton(
                            onPressed: add,
                            icon: const Icon(Icons.add),
                          ),
                        ],
                      )
                    : const SizedBox.shrink()
              ],
            ),
            Divider(
              color: AppStyle.textGrey.withOpacity(0.2),
            )
          ],
        ),
      ),
    );
  }
}
