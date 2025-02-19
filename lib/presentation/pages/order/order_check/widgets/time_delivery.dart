import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodyman/infrastructure/services/extension.dart';
import 'package:foodyman/infrastructure/services/time_service.dart';
import 'package:intl/intl.dart';
import 'package:foodyman/application/order/order_provider.dart';
import 'package:foodyman/application/order/order_state.dart';
import 'package:foodyman/application/order_time/time_state.dart';
import 'package:foodyman/infrastructure/services/app_helpers.dart';
import 'package:foodyman/infrastructure/services/tr_keys.dart';
import 'package:foodyman/presentation/components/custom_tab_bar.dart';
import 'package:foodyman/presentation/components/select_item.dart';
import 'package:foodyman/presentation/components/title_icon.dart';
import 'package:foodyman/presentation/theme/theme.dart';

import 'package:foodyman/application/order_time/time_notifier.dart';
import 'package:foodyman/application/order_time/time_provider.dart';

class TimeDelivery extends ConsumerStatefulWidget {
  const TimeDelivery({super.key});

  @override
  ConsumerState<TimeDelivery> createState() => _TimeDeliveryState();
}

class _TimeDeliveryState extends ConsumerState<TimeDelivery>
    with TickerProviderStateMixin {
  late TimeNotifier event;
  late TimeState state;

  late OrderState stateOrder;
  late TabController _tabController;
  final _tabs = [
    Tab(text: AppHelpers.getTranslation(TrKeys.today)),
    Tab(text: AppHelpers.getTranslation(TrKeys.tomorrow)),
  ];

  Iterable list = [];

  isCheckCloseDay(String? dateFormat) {
    DateTime date = DateFormat("EEEE, MMM dd").parse(dateFormat ?? "");
    return ref
        .read(orderProvider)
        .shopData
        ?.shopClosedDate
        ?.map((e) => e.day!.day)
        .contains(date.day);
  }

  @override
  void initState() {
    for (int i = 0; i < 5; i++) {
      _tabs.add(
        Tab(
          text: AppHelpers.getTranslation(
            TimeService.dateFormatEMD(
                DateTime.now().add(Duration(days: i + 2))),
          ),
        ),
      );
    }
    _tabController = TabController(
        length: 7,
        vsync: this,
        initialIndex: ref
            .read(orderProvider)
            .todayTimes
            .isNotEmpty ? 0 : 1);
    list = [
      "${AppHelpers.getTranslation(TrKeys.today)} — ${ref
          .read(orderProvider)
          .shopData
          ?.deliveryTime
          ?.to ?? 40} ${AppHelpers.getTranslation(TrKeys.min)}",
      AppHelpers.getTranslation(TrKeys.other)
    ];
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(timeProvider.notifier).reset();
      ref.read(orderProvider.notifier).checkWorkingDay();
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    event = ref.read(timeProvider.notifier);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    stateOrder = ref.watch(orderProvider);
    state = ref.watch(timeProvider);
    return Container(
      decoration: BoxDecoration(
          color: AppStyle.bgGrey.withOpacity(0.96),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12.r),
            topRight: Radius.circular(12.r),
          )),
      width: double.infinity,
      child: Padding(
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
                  borderRadius: BorderRadius.all(
                    Radius.circular(40.r),
                  ),
                ),
              ),
            ),
            14.verticalSpace,
            TitleAndIcon(
              title: state.currentIndexOne == 0
                  ? AppHelpers.getTranslation(TrKeys.deliveryTime)
                  : AppHelpers.getTranslation(TrKeys.timeSchedule),
              paddingHorizontalSize: 0,
              rightTitle: state.currentIndexOne == 0
                  ? ""
                  : AppHelpers.getTranslation(TrKeys.clear),
              rightTitleColor: AppStyle.red,
              onRightTap:
              state.currentIndexOne == 0 ? () {} : () => event.changeOne(0),
            ),
            24.verticalSpace,
            state.currentIndexOne == 0 && stateOrder.todayTimes.isNotEmpty
                ? ListView.builder(
                shrinkWrap: true,
                itemCount: 2,
                itemBuilder: (context, index) {
                  return SelectItem(
                    onTap: () => event.changeOne(index),
                    isActive: state.currentIndexOne == index,
                    title: list.elementAt(index),
                  );
                })
                : Expanded(
              child: Column(
                children: [
                  CustomTabBar(
                    isScrollable: true,
                    tabController: _tabController,
                    tabs: _tabs,
                  ),
                  Expanded(
                    child:
                    TabBarView(controller: _tabController, children: [
                      stateOrder.todayTimes.isNotEmpty
                          ? ListView.builder(
                        padding: EdgeInsets.only(
                            top: 24.h, bottom: 16.h),
                        itemCount: stateOrder.todayTimes.length,
                        itemBuilder: (context, index) {
                          return SelectItem(
                            onTap: () {
                              event.selectIndex(index);
                              ref
                                  .read(orderProvider.notifier)
                                  .setTimeAndDay(
                                  stateOrder.todayTimes[index]
                                      .toNextTime,
                                  DateTime.now());
                            },
                            isActive: state.selectIndex == index,
                            title: stateOrder.todayTimes
                                .elementAt(index)
                                .toTime,
                          );
                        },
                      )
                          : Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 32.r, vertical: 48.r),
                        child: Text(
                          AppHelpers.getTranslation(
                              TrKeys.notWorkToday),
                          style: AppStyle.interNormal(size: 20),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      ...List.generate(stateOrder.dailyTimes.length,
                              (indexTab) {
                            return stateOrder.dailyTimes[indexTab].isEmpty
                                ? Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 32.r, vertical: 48.r),
                              child: Text(
                                "${AppHelpers.getTranslation(
                                    TrKeys.notWork)} ${_tabs[indexTab + 1]
                                    .text}",
                                style: AppStyle.interNormal(size: 20),
                                textAlign: TextAlign.center,
                              ),
                            )
                                : ListView.builder(
                              padding: EdgeInsets.only(
                                  top: 24.h, bottom: 16.h),
                              itemCount: stateOrder
                                  .dailyTimes[indexTab].length,
                              itemBuilder: (context, index) {
                                return SelectItem(
                                  onTap: () {
                                    DateTime day = indexTab == 0
                                        ? DateTime.now()
                                        .add(Duration(days: 1))
                                        : DateFormat("EEEE, MMM dd")
                                        .parse(_tabs[indexTab + 1]
                                        .text ??
                                        "");
                                    event.selectIndex(index);
                                    ref
                                        .read(orderProvider.notifier)
                                        .setTimeAndDay(
                                        stateOrder
                                            .dailyTimes[indexTab]
                                        [index]
                                            .toNextTime,
                                        day);
                                  },
                                  isActive: state.selectIndex == index,
                                  title: stateOrder.dailyTimes[indexTab]
                                      .elementAt(index)
                                      .toTime,
                                );
                              },
                            );
                          }),
                    ]),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
