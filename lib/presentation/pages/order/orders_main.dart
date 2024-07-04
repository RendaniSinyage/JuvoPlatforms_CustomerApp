import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:riverpodtemp/application/orders_list/orders_list_notifier.dart';
import 'package:riverpodtemp/application/orders_list/orders_list_provider.dart';
import 'package:riverpodtemp/application/parcels_list/parcel_list_notifier.dart';
import 'package:riverpodtemp/application/parcels_list/parcel_list_provider.dart';
import 'package:riverpodtemp/infrastructure/services/app_helpers.dart';
import 'package:riverpodtemp/infrastructure/services/local_storage.dart';
import 'package:riverpodtemp/infrastructure/services/tr_keys.dart';
import 'package:riverpodtemp/presentation/components/app_bars/common_app_bar2.dart';
//import 'package:riverpodtemp/presentation/components/buttons/pop_button.dart';
import 'package:riverpodtemp/presentation/components/custom_tab_bar.dart';
import 'package:riverpodtemp/presentation/components/loading.dart';
import 'package:riverpodtemp/presentation/theme/theme.dart';
import 'widgets/orders_item.dart';
import 'package:riverpodtemp/presentation/pages/parcel/parcel_item.dart';
import 'package:riverpodtemp/presentation/components/badges/empty_badge.dart';
 
@RoutePage()
class OrdersMainPage extends ConsumerStatefulWidget {
  const OrdersMainPage({super.key});

  @override
  ConsumerState<OrdersMainPage> createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<OrdersMainPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _tabs = [
    Tab(text: AppHelpers.getTranslation(TrKeys.order)),
    Tab(text: AppHelpers.getTranslation(TrKeys.parcels)),
  ];

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = LocalStorage.getAppThemeMode();
    final bool isLtr = LocalStorage.getLangLtr();
    return Directionality(
      textDirection: isLtr ? TextDirection.ltr : TextDirection.rtl,
      child: Scaffold(
        backgroundColor: isDarkMode ? AppStyle.mainBackDark : AppStyle.bgGrey,
        body: Column(
          children: [
            CommonAppBar2(
              bgColor: AppStyle.brandGreen.withOpacity(0.28), // Set the background color here
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 42), // Assuming 40.verticalSpace is a constant or a function that returns a height value
                  TabBar(
                    controller: _tabController,
                    tabs: _tabs.map((Tab tab) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: tab,
                      );
                    }).toList(),
                    isScrollable: true,
                    labelColor: AppStyle.white, // Change the label color
                    unselectedLabelColor: AppStyle.black, // Change the unselected label color
                    indicator: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0), // Adjust the border radius as needed
                      ),
                      color: AppStyle.black, // Set the background color of the indicator
                    ), // Remove the indicator
                  ),
                ],
              ),
            ),

            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  OrdersList(),
                  ParcelListTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class OrdersList extends ConsumerStatefulWidget {
  final bool isBackButton;

  const OrdersList({
    super.key,
    this.isBackButton = true,
  });

  @override
  ConsumerState<OrdersList> createState() => _OrderPageState();
}

class _OrderPageState extends ConsumerState<OrdersList> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late RefreshController activeRefreshController;
  late RefreshController historyRefreshController;
  late RefreshController refundRefreshController;
  late OrdersListNotifier event;

  final _tabs = [
    Tab(text: AppHelpers.getTranslation(TrKeys.activeOrders)),
    Tab(text: AppHelpers.getTranslation(TrKeys.orderHistory)),
    Tab(text: AppHelpers.getTranslation(TrKeys.reFound)),
  ];

  @override
  void initState() {
    activeRefreshController = RefreshController();
    historyRefreshController = RefreshController();
    refundRefreshController = RefreshController();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(ordersListProvider.notifier).fetchActiveOrders(context);
      ref.read(ordersListProvider.notifier).fetchHistoryOrders(context);
      ref.read(ordersListProvider.notifier).fetchRefundOrders(context);
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    event = ref.read(ordersListProvider.notifier);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _tabController.dispose();
    activeRefreshController.dispose();
    historyRefreshController.dispose();
    refundRefreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = LocalStorage.getAppThemeMode();
    final bool isLtr = LocalStorage.getLangLtr();
    final state = ref.watch(ordersListProvider);
    return Directionality(
      textDirection: isLtr ? TextDirection.ltr : TextDirection.rtl,
      child: Scaffold(
        backgroundColor: isDarkMode ? AppStyle.mainBackDark : AppStyle.bgGrey,
        body: Column(
          children: [

            16.verticalSpace,
            CustomTabBar(
              isScrollable: true,
              tabController: _tabController,
              tabs: _tabs,
            ),
            Expanded(
              child: TabBarView(controller: _tabController, children: [
                state.isActiveLoading
                    ? const Loading()
                    : SmartRefresher(
                  controller: activeRefreshController,
                  enablePullDown: true,
                  enablePullUp: true,
                  onRefresh: () {
                    event.fetchActiveOrdersPage(context, activeRefreshController, isRefresh: true);
                    activeRefreshController.refreshCompleted();
                  },
                  onLoading: () {
                    event.fetchActiveOrdersPage(context, activeRefreshController);
                  },
                  child: state.activeOrders.isNotEmpty
                      ? ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.only(top: 24.h),
                    itemCount: state.activeOrders.length,
                    itemBuilder: (context, index) {
                      return OrdersItem(
                        order: state.activeOrders[index],
                        isActive: true,
                      );
                    },
                  )
                      : _resultEmpty(),
                ),
                state.isHistoryLoading
                    ? const Loading()
                    : SmartRefresher(
                  controller: historyRefreshController,
                  enablePullDown: true,
                  enablePullUp: true,
                  onRefresh: () {
                    event.fetchHistoryOrdersPage(context, historyRefreshController, isRefresh: true);
                    historyRefreshController.refreshCompleted();
                  },
                  onLoading: () {
                    event.fetchHistoryOrdersPage(context, historyRefreshController);
                  },
                  child: ListView.builder(
                    padding: EdgeInsets.only(top: 24.h),
                    itemCount: state.historyOrders.length,
                    itemBuilder: (context, index) {
                      return OrdersItem(
                        order: state.historyOrders[index],
                        isActive: false,
                      );
                    },
                  ),
                ),
                state.isRefundLoading
                    ? const Loading()
                    : SmartRefresher(
                  controller: refundRefreshController,
                  enablePullDown: true,
                  enablePullUp: true,
                  onRefresh: () {
                    event.fetchRefundOrdersPage(context, refundRefreshController, isRefresh: true);
                    refundRefreshController.refreshCompleted();
                  },
                  onLoading: () {
                    event.fetchRefundOrdersPage(context, refundRefreshController);
                  },
                  child: ListView.builder(
                    padding: EdgeInsets.only(top: 24.h),
                    itemCount: state.refundOrders.length,
                    itemBuilder: (context, index) {
                      return OrdersItem(
                        isRefund: true,
                        isActive: false,
                        refund: state.refundOrders[index],
                      );
                    },
                  ),
                ),
              ]),
            ),
          ],
        ),

      ),
    );
  }
}

// Similar changes for ParcelList

//@RoutePage()
class ParcelListTab extends ConsumerStatefulWidget {
  const ParcelListTab({super.key});

  @override
  ConsumerState<ParcelListTab> createState() => _ParcelListTabState();
}

class _ParcelListTabState extends ConsumerState<ParcelListTab> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late RefreshController activeRefreshController;
  late RefreshController historyRefreshController;
  late ParcelListNotifier event;

  final _tabs = [
    Tab(text: AppHelpers.getTranslation(TrKeys.activeParcel)),
    Tab(text: AppHelpers.getTranslation(TrKeys.parcelHistory)),
  ];

  @override
  void initState() {
    activeRefreshController = RefreshController();
    historyRefreshController = RefreshController();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(parcelListProvider.notifier).fetchActiveOrders(context);
      ref.read(parcelListProvider.notifier).fetchHistoryOrders(context);
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    event = ref.read(parcelListProvider.notifier);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _tabController.dispose();
    activeRefreshController.dispose();
    historyRefreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = LocalStorage.getAppThemeMode();
    final bool isLtr = LocalStorage.getLangLtr();
    final state = ref.watch(parcelListProvider);
    return Directionality(
      textDirection: isLtr ? TextDirection.ltr : TextDirection.rtl,
      child: Scaffold(
        backgroundColor: isDarkMode ? AppStyle.mainBackDark : AppStyle.bgGrey,
        body: Column(
          children: [

            16.verticalSpace,
            CustomTabBar(
              isScrollable: false,
              tabController: _tabController,
              tabs: _tabs,
            ),
            Expanded(
              child: TabBarView(controller: _tabController, children: [
                state.isActiveLoading
                    ? const Loading()
                    : SmartRefresher(
                  controller: activeRefreshController,
                  enablePullDown: true,
                  enablePullUp: true,
                  onRefresh: () {
                    event.fetchActiveOrdersPage(context, activeRefreshController, isRefresh: true);
                    activeRefreshController.refreshCompleted();
                  },
                  onLoading: () {
                    event.fetchActiveOrdersPage(context, activeRefreshController);
                  },
                  child: state.activeOrders.isNotEmpty
                      ? ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.only(top: 24.h),
                    itemCount: state.activeOrders.length,
                    itemBuilder: (context, index) {
                      return ParcelItem(
                        parcel: state.activeOrders[index],
                        isActive: true,
                      );
                    },
                  )
                      : _resultEmpty(),
                ),
                state.isHistoryLoading
                    ? const Loading()
                    : SmartRefresher(
                  controller: historyRefreshController,
                  enablePullDown: true,
                  enablePullUp: true,
                  onRefresh: () {
                    event.fetchHistoryOrdersPage(context, historyRefreshController, isRefresh: true);
                    historyRefreshController.refreshCompleted();
                  },
                  onLoading: () {
                    event.fetchHistoryOrdersPage(context, historyRefreshController);
                  },
                  child: ListView.builder(
                    padding: EdgeInsets.only(top: 24.h),
                    itemCount: state.historyOrders.length,
                    itemBuilder: (context, index) {
                      return ParcelItem(
                        parcel: state.historyOrders[index],
                        isActive: false,
                      );
                    },
                  ),
                ),
              ]),
            ),
          ],
        ),

      ),
    );
  }
}

// Common Empty Result Widget

Widget _resultEmpty() {
  return EmptyBadge();
}
