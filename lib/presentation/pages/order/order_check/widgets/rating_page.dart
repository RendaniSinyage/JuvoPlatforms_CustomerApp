import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:riverpodtemp/application/order/order_provider.dart';
import 'package:riverpodtemp/application/parcel/parcel_provider.dart';
import 'package:riverpodtemp/application/select/select_provider.dart';
import 'package:riverpodtemp/infrastructure/services/app_helpers.dart';
import 'package:riverpodtemp/infrastructure/services/input_formatter.dart';
import 'package:riverpodtemp/infrastructure/services/tr_keys.dart';
import 'package:riverpodtemp/presentation/components/buttons/custom_button.dart';
import 'package:riverpodtemp/presentation/components/text_fields/outline_bordered_text_field.dart';
import 'package:riverpodtemp/presentation/components/title_icon.dart';
import 'package:riverpodtemp/presentation/components/web_view.dart';
import 'package:riverpodtemp/presentation/pages/order/order_check/widgets/payment_method.dart';
import 'package:riverpodtemp/presentation/routes/app_router.dart';
import 'package:riverpodtemp/presentation/theme/theme.dart';

class RatingPage extends ConsumerStatefulWidget {
  final bool parcel;
  final num? totalPrice;

  const RatingPage({super.key, this.parcel = false, required this.totalPrice});

  @override
  ConsumerState<RatingPage> createState() => _RatingPageState();
}

class _RatingPageState extends ConsumerState<RatingPage> {
  late TextEditingController textEditingController;
  late TextEditingController priceController;

  double rating = 0;
  double price = 0;

  List<num> tips = [5, 10, 15, -1];

  @override
  void initState() {
    priceController = TextEditingController();
    textEditingController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(selectProvider.notifier).selectIndex(-1);
    });
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(selectProvider);
    final notifier = ref.read(selectProvider.notifier);
    return Container(
      margin: MediaQuery.of(context).viewInsets,
      decoration: BoxDecoration(
          color: AppStyle.bgGrey.withOpacity(0.96),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.r),
            topRight: Radius.circular(16.r),
          )),
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      width: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            8.verticalSpace,
            Center(
              child: Container(
                height: 4.h,
                width: 48.w,
                decoration: BoxDecoration(
                  color: AppStyle.dragElement,
                  borderRadius: BorderRadius.circular(40.r),
                ),
              ),
            ),
            24.verticalSpace,
            TitleAndIcon(
              title: AppHelpers.getTranslation(TrKeys.ratingCourier),
              paddingHorizontalSize: 0,
              titleSize: 16,
            ),
            12.verticalSpace,
            OutlinedBorderTextField(
              textController: textEditingController,
              label: AppHelpers.getTranslation(TrKeys.comment).toUpperCase(),
            ),
            24.verticalSpace,
            RatingBar.builder(
              itemBuilder: (context, index) => const Icon(
                FlutterRemix.star_smile_fill,
                color: AppStyle.brandGreen,
              ),
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 14.h),
              direction: Axis.horizontal,
              onRatingUpdate: (double value) {
                rating = value;
              },
              glow: false,
            ),
            24.verticalSpace,
            TitleAndIcon(
              title: AppHelpers.getTranslation(TrKeys.tips),
              paddingHorizontalSize: 0,
              titleSize: 16,
            ),
            12.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ...tips.mapIndexed(
                  (e, i) => GestureDetector(
                    onTap: () {
                      if (state.selectedIndex == i) {
                        notifier.selectIndex(-1);
                        return;
                      }
                      notifier.selectIndex(i);
                      if (i == 3) {
                        price = 0;
                      } else {
                        price = ((widget.totalPrice ?? 0) / 100) * e;
                      }
                    },
                    child: Container(
                      width: 80.r,
                      height: 80.r,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          width: state.selectedIndex == i ? 2 : 1,
                          color: state.selectedIndex == i
                              ? AppStyle.brandGreen
                              : AppStyle.textGrey,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: i != 3
                            ? [
                                Text(
                                  "$e%",
                                  style: AppStyle.interNormal(
                                    size: 14,
                                    color: state.selectedIndex == i
                                        ? AppStyle.brandGreen
                                        : AppStyle.black,
                                  ),
                                ),
                                6.verticalSpace,
                                Text(
                                  AppHelpers.numberFormat(
                                      number:
                                          ((widget.totalPrice ?? 0) / 100) * e),
                                  style: AppStyle.interNormal(
                                    size: 14,
                                    color: state.selectedIndex == i
                                        ? AppStyle.brandGreen
                                        : AppStyle.black,
                                  ),
                                ),
                              ]
                            : [
                                Icon(
                                  FlutterRemix.edit_2_line,
                                  color: state.selectedIndex == i
                                      ? AppStyle.brandGreen
                                      : AppStyle.black,
                                ),
                                Text(
                                  AppHelpers.getTranslation(TrKeys.custom),
                                  style: AppStyle.interNormal(
                                    size: 14,
                                    color: state.selectedIndex == i
                                        ? AppStyle.brandGreen
                                        : AppStyle.black,
                                  ),
                                ),
                                6.verticalSpace,
                              ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (state.selectedIndex == 3)
              Padding(
                padding: REdgeInsets.only(top: 12),
                child: OutlinedBorderTextField(
                  textController: priceController,
                  label:
                      AppHelpers.getTranslation(TrKeys.customTip).toUpperCase(),
                  inputFormatters: [InputFormatter.currency],
                  onChanged: (s) {
                    price = double.tryParse(s) ?? 0;
                  },
                ),
              ),
            40.verticalSpace,
            Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom + 36.h),
              child: Consumer(builder: (context, ref, child) {
                return CustomButton(
                  isLoading: widget.parcel
                      ? ref.watch(parcelProvider).isButtonLoading
                      : ref.watch(orderProvider).isButtonLoading,
                  background: AppStyle.brandGreen,
                  textColor: AppStyle.black,
                  title: AppHelpers.getTranslation(TrKeys.save),
                  onPressed: () {
                    if (state.selectedIndex != -1) {
                      AppHelpers.showCustomModalBottomSheet(
                        context: context,
                        modal: PaymentMethods(
                          tipPrice: price,
                          tips: (payment, price) {
                            ref.read(orderProvider.notifier).sendTips(
                                  context: context,
                                  payment: payment,
                                  price: price,
                                  onWebview: (s) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => WebViewPage(url: s)),
                                    ).whenComplete(() {
                                      if (widget.parcel) {
                                        ref
                                            .read(parcelProvider.notifier)
                                            .addReview(
                                                context,
                                                textEditingController.text,
                                                rating);
                                      } else {
                                        ref
                                            .read(orderProvider.notifier)
                                            .addReview(
                                                context,
                                                textEditingController.text,
                                                rating);
                                      }
                                      context.replaceRoute(
                                          const OrdersListRoute());
                                    });
                                  },
                                  onSuccess: () {
                                    Navigator.maybePop(context);
                                  },
                                );
                          },
                        ),
                        isDarkMode: false,
                      );
                    } else {
                      if (widget.parcel) {
                        ref.read(parcelProvider.notifier).addReview(
                            context, textEditingController.text, rating);
                      } else {
                        ref.read(orderProvider.notifier).addReview(
                            context, textEditingController.text, rating);
                      }

                      context.replaceRoute(const OrdersListRoute());
                    }
                  },
                );
              }),
            )
          ],
        ),
      ),
    );
  }
}
