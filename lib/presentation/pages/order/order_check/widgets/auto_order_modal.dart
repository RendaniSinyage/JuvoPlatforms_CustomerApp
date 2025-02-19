import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodyman/app_constants.dart';
import 'package:foodyman/infrastructure/services/time_service.dart';
import 'package:jiffy/jiffy.dart';
import 'package:foodyman/application/auto_order/auto_order_provider.dart';
import 'package:foodyman/application/order/order_provider.dart';
import 'package:foodyman/infrastructure/models/data/repeat_data.dart';
import 'package:foodyman/infrastructure/services/app_helpers.dart';
import 'package:foodyman/infrastructure/services/tr_keys.dart';
import 'package:foodyman/presentation/components/title_icon.dart';
import 'package:foodyman/presentation/theme/app_style.dart';

import 'package:foodyman/presentation/components/buttons/custom_button.dart';

class AutoOrderModal extends ConsumerStatefulWidget {
  final int orderId;
  final String time;
  final RepeatData? repeatData;

  const AutoOrderModal({
    super.key,
    required this.repeatData,
    required this.orderId,
    required this.time,
  });

  @override
  ConsumerState<AutoOrderModal> createState() => _AutoOrderModalState();
}

class _AutoOrderModalState extends ConsumerState<AutoOrderModal> {
  Timer? timer;

  @override
  void initState() {
    if (widget.repeatData != null) {
      timer = Timer(const Duration(milliseconds: 100), init);
    }
    super.initState();
  }

  init() async {
    if (widget.repeatData != null) {
      ref
          .read(autoOrderProvider.notifier)
          .pickTo(DateTime.parse(widget.repeatData?.to ?? ''));
      ref
          .read(autoOrderProvider.notifier)
          .pickFrom(DateTime.parse(widget.repeatData?.from ?? ''));
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(autoOrderProvider);
    final event = ref.read(autoOrderProvider.notifier);
    return Container(
      margin: MediaQuery.of(context).viewInsets,
      decoration: BoxDecoration(
          color: AppStyle.bgGrey.withOpacity(0.96),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12.r),
            topRight: Radius.circular(12.r),
          )),
      width: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
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
                          borderRadius:
                              BorderRadius.all(Radius.circular(40.r))),
                    ),
                  ),
                  14.verticalSpace,
                  TitleAndIcon(
                    title: AppHelpers.getTranslation(TrKeys.autoOrder),
                    paddingHorizontalSize: 0,
                    rightTitle: (widget.repeatData?.updatedAt?.isNotEmpty ??
                            false)
                        ? "${AppHelpers.getTranslation(TrKeys.started)} ${Jiffy.parseFromDateTime(DateTime.parse(widget.repeatData?.updatedAt ?? '')).from(Jiffy.now())}"
                        : "",
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Wrap(
                      runSpacing: 15,
                      spacing: 20,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              AppHelpers.getTranslation(TrKeys.from),
                              style: const TextStyle(fontSize: 18),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                              onTap: () {
                                AppHelpers.showCustomModalBottomSheet(
                                    context: context,
                                    modal: Container(
                                      height: 250.h,
                                      padding: const EdgeInsets.only(top: 6.0),
                                      margin: EdgeInsets.only(
                                        bottom: MediaQuery.viewInsetsOf(context)
                                            .bottom,
                                      ),
                                      color: CupertinoColors.systemBackground
                                          .resolveFrom(context),
                                      child: SafeArea(
                                        top: false,
                                        child: CupertinoDatePicker(
                                          initialDateTime: state.from
                                                  .toLocal()
                                                  .isAfter(DateTime(
                                                      DateTime.now().year,
                                                      DateTime.now().month,
                                                      DateTime.now().day))
                                              ? state.from.toLocal()
                                              : state.from.toLocal().add(
                                                    state.from
                                                        .toLocal()
                                                        .difference(
                                                          DateTime(
                                                              DateTime.now()
                                                                  .year,
                                                              DateTime.now()
                                                                  .month,
                                                              DateTime.now()
                                                                  .day),
                                                        ),
                                                  ),
                                          mode: CupertinoDatePickerMode.date,
                                          use24hFormat:
                                              AppConstants.use24Format,
                                          onDateTimeChanged:
                                              (DateTime newDate) {
                                            event.pickFrom(newDate);
                                          },
                                        ),
                                      ),
                                    ),
                                    isDarkMode: false);
                              },
                              child: Row(
                                children: [
                                  Text(
                                    TimeService.dateFormatYMD(state.from),
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                  const SizedBox(
                                    width: 3,
                                  ),
                                  const Icon(
                                    CupertinoIcons.chevron_up_chevron_down,
                                    size: 20,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              AppHelpers.getTranslation(TrKeys.to),
                              style: const TextStyle(fontSize: 18),
                            ),
                            10.horizontalSpace,
                            GestureDetector(
                              onTap: () {
                                AppHelpers.showCustomModalBottomSheet(
                                    context: context,
                                    modal: Container(
                                      height: 250.h,
                                      padding: const EdgeInsets.only(top: 6.0),
                                      margin: EdgeInsets.only(
                                        bottom: MediaQuery.viewInsetsOf(context)
                                            .bottom,
                                      ),
                                      color: CupertinoColors.systemBackground
                                          .resolveFrom(context),
                                      child: SafeArea(
                                        top: false,
                                        child: CupertinoDatePicker(
                                          initialDateTime: state.to
                                                  .toLocal()
                                                  .isAfter(DateTime(
                                                      DateTime.now().year,
                                                      DateTime.now().month,
                                                      DateTime.now().day))
                                              ? state.to.toLocal()
                                              : state.to.toLocal().add(
                                                    state.to
                                                        .toLocal()
                                                        .difference(
                                                          DateTime(
                                                              DateTime.now()
                                                                  .year,
                                                              DateTime.now()
                                                                  .month,
                                                              DateTime.now()
                                                                  .day),
                                                        ),
                                                  ),
                                          mode: CupertinoDatePickerMode.date,
                                          use24hFormat:
                                              AppConstants.use24Format,
                                          onDateTimeChanged:
                                              (DateTime newDate) {
                                            event.pickTo(newDate);
                                          },
                                        ),
                                      ),
                                    ),
                                    isDarkMode: false);
                              },
                              child: Row(
                                children: [
                                  Text(
                                    TimeService.dateFormatYMD(state.to),
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                  const SizedBox(width: 3),
                                  const Icon(
                                    CupertinoIcons.chevron_up_chevron_down,
                                    size: 20,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (state.isError)
                    Text(
                      "*${AppHelpers.getTranslation(TrKeys.notValidDate)}",
                      style: const TextStyle(color: Colors.red),
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Text(
                      "*${AppHelpers.getTranslation(TrKeys.autoOrderInfo)}",
                      style: const TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.paddingOf(context).bottom + 4.h,
                    ),
                    child: Column(
                      children: [
                        if (!(timer?.isActive ?? false) &&
                            event.isTimeChanged(widget.repeatData))
                          Consumer(builder: (context, ref, child) {
                            return CustomButton(
                              isLoading:
                                  ref.watch(orderProvider).isButtonLoading,
                              title: AppHelpers.getTranslation(TrKeys.save),
                              onPressed: () {
                                if (event.isValidDates()) {
                                  event.startAutoOrder(
                                    onSuccess: () {
                                      ref
                                          .read(orderProvider.notifier)
                                          .showOrder(
                                              context, widget.orderId, true);
                                    },
                                    orderId: widget.orderId,
                                    context: context,
                                  );
                                }
                              },
                            );
                          }),
                        const SizedBox(
                          height: 10,
                        ),
                        if (widget.repeatData != null)
                          Consumer(builder: (context, ref, child) {
                            return CustomButton(
                              isLoading:
                                  ref.watch(orderProvider).isButtonLoading,
                              textColor: Colors.white,
                              background: Colors.red,
                              title: AppHelpers.getTranslation(
                                  TrKeys.removeAutoOrder),
                              onPressed: () {
                                ref
                                    .read(orderProvider.notifier)
                                    .showOrder(context, widget.orderId, true);
                                event.deleteAutoOrder(
                                    orderId: widget.repeatData?.id ?? 0,
                                    context: context);
                              },
                            );
                          }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
