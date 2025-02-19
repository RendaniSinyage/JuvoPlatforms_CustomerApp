// ignore_for_file: unused_result, deprecated_member_use

import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodyman/application/shop/shop_notifier.dart';
import 'package:foodyman/infrastructure/models/data/shop_data.dart';
import 'package:foodyman/infrastructure/services/app_helpers.dart';
import 'package:foodyman/infrastructure/services/time_service.dart';
import 'package:foodyman/infrastructure/services/tr_keys.dart';
import 'package:foodyman/presentation/components/buttons/custom_button.dart';
import 'package:foodyman/presentation/components/buttons/pop_button.dart';
import 'package:foodyman/presentation/components/loading.dart';
import 'package:foodyman/application/like/like_notifier.dart';
import 'package:foodyman/application/like/like_provider.dart';
import 'package:foodyman/presentation/components/text_fields/outline_bordered_text_field.dart';
import 'package:foodyman/presentation/pages/product/product_page.dart';
import 'package:foodyman/presentation/pages/shop/widgets/category_tab_bar.widget.dart';
import 'package:foodyman/presentation/pages/shop/widgets/product_list.dart';
import 'package:foodyman/presentation/pages/shop/widgets/shimmer_product_list.dart';
import 'package:foodyman/presentation/theme/theme.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'package:foodyman/application/shop/shop_provider.dart';
import 'package:foodyman/application/shop_order/shop_order_provider.dart';
import 'package:foodyman/infrastructure/models/response/all_products_response.dart';
import 'package:foodyman/infrastructure/services/local_storage.dart';

import 'package:foodyman/presentation/components/buttons/animation_button_effect.dart';
import 'cart/cart_order_page.dart';
import 'widgets/shop_page_avatar.dart';

@RoutePage()
class ShopPage extends ConsumerStatefulWidget {
  final ShopData? shop;
  final String shopId;
  final String? cartId;
  final int? ownerId;
  final String? productId;

  const ShopPage({
    super.key,
    required this.shopId,
    this.productId,
    this.cartId,
    this.shop,
    this.ownerId,
  });

  @override
  ConsumerState<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends ConsumerState<ShopPage>
    with TickerProviderStateMixin {
  late ShopNotifier event;
  late LikeNotifier eventLike;
  late TextEditingController name;
  late TextEditingController search;
  ScrollController scrollController = ScrollController();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    ref.refresh(shopProvider);
    name = TextEditingController();
    search = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (LocalStorage.getUser()?.id != widget.ownerId &&
          widget.cartId != null) {
        AppHelpers.showAlertDialog(
          context: context,
          radius: 16,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppHelpers.getTranslation(TrKeys.joinOrder),
                style: AppStyle.interNoSemi(
                  size: 24.r,
                ),
              ),
              8.verticalSpace,
              Text(
                AppHelpers.getTranslation(TrKeys.youCanOnly),
                style: AppStyle.interNormal(color: AppStyle.textGrey),
              ),
              16.verticalSpace,
              OutlinedBorderTextField(
                textController: name,
                label: AppHelpers.getTranslation(TrKeys.firstname),
              ),
              24.verticalSpace,
              Consumer(builder: (contextt, ref, child) {
                return CustomButton(
                    isLoading: ref.watch(shopProvider).isJoinOrder,
                    title: AppHelpers.getTranslation(TrKeys.join),
                    onPressed: () {
                      event.joinOrder(context, widget.shopId,
                          widget.cartId ?? "", name.text, () {
                        Navigator.pop(context);
                        ref
                            .read(shopOrderProvider.notifier)
                            .joinGroupOrder(context);
                      });
                    });
              })
            ],
          ),
        );
      }
      if (widget.shop == null) {
        ref.read(shopProvider.notifier)
          ..fetchShop(context, widget.shopId)
          ..leaveGroup();
      } else {
        ref.read(shopProvider.notifier)
          ..setShop(widget.shop!)
          ..leaveGroup();
      }
      ref.read(shopProvider.notifier)
        ..checkProductsPopular(context, widget.shopId)
        // ..fetchCategory(context, widget.shopId)
        ..changeIndex(0);
      if (LocalStorage.getToken().isNotEmpty) {
        ref.read(shopOrderProvider.notifier).getCart(context, () {},
            userUuid: ref.watch(shopProvider).userUuid,
            shopId: widget.shopId,
            cartId: widget.cartId);
      }
      if (widget.productId != null) {
        AppHelpers.showCustomModalBottomDragSheet(
          context: context,
          modal: (c) => ProductScreen(
            productId: widget.productId,
            controller: c,
          ),
          isDarkMode: false,
          isDrag: true,
          radius: 16,
        );
      }
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(shopProvider.notifier).fetchProducts(
          context,
          widget.shopId,
          (i) {
            _tabController = TabController(length: i, vsync: this);
          },
        );
      });
    });
    _tabController = TabController(length: 0, vsync: this);
  }

  @override
  void didChangeDependencies() {
    event = ref.read(shopProvider.notifier);
    eventLike = ref.read(likeProvider.notifier);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    name.dispose();
    search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isLtr = LocalStorage.getLangLtr();
    final state = ref.watch(shopProvider);
    return Directionality(
      textDirection: isLtr ? TextDirection.ltr : TextDirection.rtl,
      child: WillPopScope(
        onWillPop: () {
          if ((ref.watch(shopOrderProvider).cart?.group ?? false) &&
              LocalStorage.getUser()?.id !=
                  ref.watch(shopOrderProvider).cart?.ownerId) {
            AppHelpers.showAlertDialog(
                context: context,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      AppHelpers.getTranslation(TrKeys.doYouLeaveGroup),
                      style: AppStyle.interNoSemi(),
                      textAlign: TextAlign.center,
                    ),
                    16.verticalSpace,
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                              borderColor: AppStyle.black,
                              background: AppStyle.transparent,
                              title: AppHelpers.getTranslation(TrKeys.cancel),
                              onPressed: () {
                                Navigator.pop(context);
                              }),
                        ),
                        20.horizontalSpace,
                        Expanded(
                          child: CustomButton(
                              title:
                                  AppHelpers.getTranslation(TrKeys.leaveGroup),
                              onPressed: () {
                                ref.read(shopOrderProvider.notifier).deleteUser(
                                    context, 0,
                                    userId: state.userUuid);
                                event.leaveGroup();
                                Navigator.pop(context);
                                Navigator.pop(context);
                              }),
                        ),
                      ],
                    )
                  ],
                ));
          } else {
            Navigator.pop(context);
          }

          return Future.value(false);
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: AppStyle.bgGrey,
          body: state.isLoading
              ? const Loading()
              : CustomScrollView(
                  controller: scrollController,
                  slivers: [
                    SliverAppBar(
                      backgroundColor: AppStyle.white,
                      toolbarHeight: (140 +
                          300.r +
                          ((state.shopData?.translation?.description?.length ??
                                      0) >
                                  40
                              ? 30
                              : 0) +
                          (AppHelpers.getGroupOrder() ? 60.r : 0.r) +
                          (state.shopData?.bonus == null ? 0 : 46.r) +
                          (state.endTodayTime.hour > TimeOfDay.now().hour
                              ? 0
                              : 70.r)),
                      elevation: 0.0,
                      leading: SizedBox.shrink(),
                      flexibleSpace: FlexibleSpaceBar(
                        background: ShopPageAvatar(
                          workTime: state.endTodayTime.hour >
                                  TimeOfDay.now().hour
                              ? "${TimeService.timeFormatTime(state.startTodayTime.format(context))} - ${TimeService.timeFormatTime(state.endTodayTime.format(context))}"
                              : AppHelpers.getTranslation(TrKeys.close),
                          onLike: () {
                            event.onLike();
                            eventLike.fetchLikeShop(context);
                          },
                          isLike: state.isLike,
                          shop: state.shopData ?? ShopData(),
                          onShare: event.onShare,
                          bonus: state.shopData?.bonus,
                          cartId: widget.cartId,
                          userUuid: state.userUuid,
                        ),
                      ),
                    ),
                    SliverPersistentHeader(
                      delegate: _CategoryTabBarDelegate(
                        controller: _tabController,
                        data: state.allData,
                        textController: search,
                        isLoading: state.isProductLoading,
                      ),
                      pinned: true,
                    ),
                    SliverPadding(
                      padding: EdgeInsets.zero,
                      sliver: SliverToBoxAdapter(
                        child: contentList(),
                      ),
                    )
                  ],
                ),
          // NestedScrollView(
          //         headerSliverBuilder:
          //             (BuildContext context, bool innerBoxIsScrolled) {
          //           return [
          //             SliverAppBar(
          //               // bottom: PreferredSize(preferredSize: Size(300, 100), child: Container(
          //               //   height: 40,
          //               //   color: Colors.red,
          //               // )),
          //               backgroundColor: AppStyle.white,
          //               automaticallyImplyLeading: false,
          //               toolbarHeight: (144 +
          //                   300.r +
          //                   ((state.shopData?.translation?.description
          //                                   ?.length ??
          //                               0) >
          //                           40
          //                       ? 30
          //                       : 0) +
          //                   (AppHelpers.getGroupOrder() ? 60.r : 0.r) +
          //                   (state.shopData?.bonus == null ? 0 : 46.r) +
          //                   (state.endTodayTime.hour > TimeOfDay.now().hour
          //                       ? 0
          //                       : 70.r)),
          //               elevation: 0.0,
          //               flexibleSpace: FlexibleSpaceBar(
          //                 background: ShopPageAvatar(
          //                   workTime: state.endTodayTime.hour >
          //                           TimeOfDay.now().hour
          //                       ? "${state.startTodayTime.hour.toString().padLeft(2, '0')}:${state.startTodayTime.minute.toString().padLeft(2, '0')} - ${state.endTodayTime.hour.toString().padLeft(2, '0')}:${state.endTodayTime.minute.toString().padLeft(2, '0')}"
          //                       : AppHelpers.getTranslation(TrKeys.close),
          //                   onLike: () {
          //                     event.onLike();
          //                     eventLike.fetchLikeShop(context);
          //                   },
          //                   isLike: state.isLike,
          //                   shop: state.shopData ?? ShopData(),
          //                   onShare: event.onShare,
          //                   bonus: state.shopData?.bonus,
          //                   cartId: widget.cartId,
          //                   userUuid: state.userUuid,
          //                 ),
          //               ),
          //             ),
          //           ];
          //         },physics:  const AlwaysScrollableScrollPhysics(),
          //         controller: scrollController,
          //         body: ShopProductsScreen(
          //           nestedScrollCon: scrollController,
          //           isPopularProduct: state.isPopularProduct,
          //           listCategory: state.category,
          //           currentIndex: state.currentIndex,
          //           shopId: widget.shopId,
          //
          //         ),
          //       ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: Padding(
            padding: EdgeInsets.all(16.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                PopButton(
                  onTap: () {
                    if ((ref.watch(shopOrderProvider).cart?.group ?? false) &&
                        LocalStorage.getUser()?.id !=
                            ref.watch(shopOrderProvider).cart?.ownerId) {
                      AppHelpers.showAlertDialog(
                          context: context,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                AppHelpers.getTranslation(
                                    TrKeys.doYouLeaveGroup),
                                style: AppStyle.interNoSemi(),
                                textAlign: TextAlign.center,
                              ),
                              16.verticalSpace,
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomButton(
                                        borderColor: AppStyle.black,
                                        background: AppStyle.transparent,
                                        title: AppHelpers.getTranslation(
                                            TrKeys.cancel),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        }),
                                  ),
                                  20.horizontalSpace,
                                  Expanded(
                                    child: CustomButton(
                                        title: AppHelpers.getTranslation(
                                            TrKeys.leaveGroup),
                                        onPressed: () {
                                          ref
                                              .read(shopOrderProvider.notifier)
                                              .deleteUser(context, 0,
                                                  userId: state.userUuid);
                                          event.leaveGroup();
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        }),
                                  ),
                                ],
                              )
                            ],
                          ));
                    } else {
                      Navigator.pop(context);
                    }
                  },
                ),
                LocalStorage.getToken().isNotEmpty
                    ? GestureDetector(
                        onTap: () {
                          AppHelpers.showCustomModalBottomDragSheet(
                            context: context,
                            maxChildSize: 0.8,
                            modal: (c) => CartOrderPage(
                              controller: c,
                              isGroupOrder: state.isGroupOrder,
                              cartId: widget.cartId,
                              shopId: widget.shopId,
                            ),
                            isDarkMode: false,
                            isDrag: true,
                            radius: 12,
                          );
                        },
                        child: AnimationButtonEffect(
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppStyle.primary,
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.r),
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 8.h, horizontal: 10.w),
                            child: Row(
                              children: [
                                const Icon(
                                  FlutterRemix.shopping_bag_3_line,
                                  color: AppStyle.black,
                                ),
                                12.horizontalSpace,
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 8.h, horizontal: 14.w),
                                  decoration: BoxDecoration(
                                    color: AppStyle.black,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(18.r),
                                    ),
                                  ),
                                  child:
                                      Consumer(builder: (context, ref, child) {
                                    return ref
                                            .watch(shopOrderProvider)
                                            .isLoading
                                        ? CupertinoActivityIndicator(
                                            color: AppStyle.white,
                                            radius: 10.r,
                                          )
                                        : Text(
                                            AppHelpers.numberFormat(
                                                number: ref
                                                    .watch(shopOrderProvider)
                                                    .cart
                                                    ?.totalPrice),
                                            style: AppStyle.interSemi(
                                              size: 16,
                                              color: AppStyle.white,
                                            ),
                                          );
                                  }),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget contentList() {
    final state = ref.watch(shopProvider);
    return SingleChildScrollView(
      child: state.isProductLoading
          ? const ShimmerProductList()
          : Column(
              children: List.generate(state.allData.length, (index) {
                var item = state.allData[index];
                return VisibilityDetector(
                  key: item.key!,
                  onVisibilityChanged: (VisibilityInfo info) {
                    double screenHeight = MediaQuery.sizeOf(context).height;
                    double visibleAreaOnScreen =
                        info.visibleBounds.bottom - info.visibleBounds.top;

                    if (info.visibleFraction > 0.5 ||
                        visibleAreaOnScreen > screenHeight * 0.5) {
                      _tabController.animateTo(index);
                    }
                  },
                  child: ProductsList(
                    shopId: int.tryParse(widget.shopId),
                    cartId: widget.cartId,
                    all: item,
                  ),
                );
              }),
            ),
    );
  }
}

class _CategoryTabBarDelegate extends SliverPersistentHeaderDelegate {
  _CategoryTabBarDelegate({
    required this.controller,
    required this.textController,
    required this.data,
    required this.isLoading,
  });

  final TabController controller;
  final TextEditingController textController;
  final List<All> data;
  final bool isLoading;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return SizedBox.expand(
      child: CategoryTabBar(
        controller: controller,
        data: data,
        overlapsContent: shrinkOffset / maxExtent > 0,
        textController: textController,
        isLoading: isLoading,
      ),
    );
  }

  @override
  double get maxExtent => 116;

  @override
  double get minExtent => 116;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
