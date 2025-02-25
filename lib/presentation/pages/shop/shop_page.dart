import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
import 'package:remixicon/remixicon.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'package:foodyman/application/shop/shop_provider.dart';
import 'package:foodyman/application/shop_order/shop_order_provider.dart';
import 'package:foodyman/infrastructure/models/response/all_products_response.dart';
import 'package:foodyman/infrastructure/services/local_storage.dart';

import 'package:foodyman/presentation/components/buttons/animation_button_effect.dart';
import 'package:foodyman/presentation/components/blur_wrap.dart';
import '../../../app_constants.dart';
import '../../../application/home/home_provider.dart';
import '../../../infrastructure/models/data/cart_data.dart';
import 'cart/cart_order_page.dart';
import 'widgets/shop_page_avatar.dart';
import 'package:foodyman/presentation/routes/app_router.dart';

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
    _tabController.dispose();
    super.dispose();
  }

  // Calculate dynamic app bar height based on search state and content
  double calculateAppBarHeight(dynamic state) {
    // If search is enabled, return minimal or zero height
    if (state.isSearchEnabled) {
      return 0.r; // Hide completely when search is active
    }

    // Base height for essential shop information
    double height = 140.r;

    // Add height for shop name, ratings section
    height += 58.r;

    // Add height for group order if present
    if (AppHelpers.getGroupOrder()) {
      height += 65.r;
    }

    // Add height for bonus info if present
    if (state.shopData?.bonus != null) {
      height += 46.r;
    }

    // Add height for closed status message if shop is closed
    if (state.endTodayTime.hour <= TimeOfDay.now().hour) {
      height += 70.r;
    }

    return height;
  }

  @override
  Widget build(BuildContext context) {
    final bool isLtr = LocalStorage.getLangLtr();
    final state = ref.watch(shopProvider);
    final orders = ref.watch(shopOrderProvider).cart;

    final bool isCartEmpty = orders == null ||
        (orders.userCarts?.isEmpty ?? true) ||
        ((orders.userCarts?.isEmpty ?? true)
            ? true
            : (orders.userCarts?.first.cartDetails?.isEmpty ?? true)) ||
        orders.ownerId != LocalStorage.getUser()?.id;

    // Check if fixed navigation is enabled
    final bool isFixed = AppConstants.fixed;

    return Directionality(
      textDirection: isLtr ? TextDirection.ltr : TextDirection.rtl,
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
              toolbarHeight: calculateAppBarHeight(state),
              elevation: 0.0,
              leading: const SizedBox.shrink(),
              flexibleSpace: FlexibleSpaceBar(
                background: state.isSearchEnabled
                    ? const SizedBox.shrink() // Hide when search is active
                    : ShopPageAvatar(
                  workTime: state.endTodayTime.hour > TimeOfDay.now().hour
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
              padding: EdgeInsets.only(bottom: 80.h),
              sliver: SliverToBoxAdapter(
                child: contentList(),
              ),
            )
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: _buildBottomNavWithCart(state, isCartEmpty, context),
      ),
    );
  }

  Widget _buildBottomNavWithCart(dynamic state, bool isCartEmpty, BuildContext context) {
    final bool isFixed = AppConstants.fixed;
    final cart = ref.watch(shopOrderProvider).cart;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Cart info bar - only show when fixed is true and cart has items
        if (isFixed && !isCartEmpty)
          GestureDetector(
            onTap: () {
              if (LocalStorage.getToken().isEmpty) {
                context.pushRoute(LoginRoute());
                return;
              }
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
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                // Main container
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  margin: EdgeInsets.only(bottom: 16.h), // Extra margin for the tooltip pointer
                  padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
                  decoration: BoxDecoration(
                    color: AppStyle.primary.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${AppHelpers.getTranslation(TrKeys.shopping)} ${_getCartShopName(cart, ref)}',
                          style: AppStyle.interRegular(
                            size: 14,
                            color: AppStyle.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Consumer(
                        builder: (context, ref, child) {
                          // Check if currency is loaded
                          final isLoading = ref.watch(shopOrderProvider).isLoading;
                          final totalPrice = ref.watch(shopOrderProvider).cart?.totalPrice;
                          final currency = LocalStorage.getSelectedCurrency();

                          if (isLoading) {
                            return CupertinoActivityIndicator(
                              color: AppStyle.white,
                              radius: 10.r,
                            );
                          } else if (currency == null) {
                            // If currency is not loaded yet, show a placeholder
                            return Text(
                              AppHelpers.numberFormat(number: totalPrice),
                              style: AppStyle.interSemi(
                                size: 16,
                                color: AppStyle.white,
                              ),
                            );
                          } else {
                            // Currency is loaded, format properly
                            return Text(
                              AppHelpers.numberFormat(number: totalPrice),
                              style: AppStyle.interSemi(
                                size: 16,
                                color: AppStyle.white,
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),

                // Tooltip pointer (triangle)
                Positioned(
                  bottom: 6.h,
                  right: 12.w, // Position near the cart icon
                  child: ClipPath(
                    clipper: TriangleClipper(),
                    child: Container(
                      width: 16.h,
                      height: 10.h,
                      color: AppStyle.primary.withOpacity(0.8),
                    ),
                  ),
                ),
              ],
            ),
          ),

        // Full navigation bar
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Main nav bar with PopButton as first item
            BlurWrap(
              radius: BorderRadius.circular(100.r),
              child: Container(
                height: 60.r,
                decoration: BoxDecoration(
                  color: AppStyle.bottomNavigationBarColor.withOpacity(0.3),
                  borderRadius: BorderRadius.all(Radius.circular(100.r)),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.r),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // Back button (using PopButton instead of custom implementation)
                      SizedBox(
                        height: 60.r,
                        child: Center(
                          child: PopButton(),
                        ),
                      ),

                      // Categories button
                      GestureDetector(
                        onTap: () {
                          // Open shop categories
                          if (_tabController.length > 0) {
                            showModalBottomSheet(
                              context: context,
                              backgroundColor: AppStyle.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
                              ),
                              builder: (context) => Container(
                                padding: EdgeInsets.all(16.r),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: state.allData.length,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      title: Text(
                                        state.allData[index].translation?.title ?? "",
                                        style: AppStyle.interNoSemi(
                                          size: 14,
                                          color: AppStyle.black,
                                        ),
                                      ),
                                      onTap: () {
                                        _tabController.animateTo(index);
                                        Navigator.pop(context);
                                        // Scroll to the category
                                        if (state.allData[index].key != null) {
                                          Scrollable.ensureVisible(
                                            state.allData[index].key!.currentContext!,
                                            duration: const Duration(milliseconds: 300),
                                          );
                                        }
                                      },
                                    );
                                  },
                                ),
                              ),
                            );
                          }
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Remix.menu_line,
                                size: 24.r,
                                color: AppStyle.white,
                              ),
                              Text(
                                AppHelpers.getTranslation(TrKeys.categories),
                                style: TextStyle(
                                  color: AppStyle.white,
                                  fontSize: 9.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Search button
                      GestureDetector(
                        onTap: () {
                          // Toggle search mode
                          event.enableSearch();
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                state.isSearchEnabled ? Remix.search_fill : Remix.search_line,
                                size: 24.r,
                                color: AppStyle.white,
                              ),
                              Text(
                                AppHelpers.getTranslation(TrKeys.search),
                                style: TextStyle(
                                  color: AppStyle.white,
                                  fontSize: 9.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Cart button
            AnimationButtonEffect(
              child: GestureDetector(
                onTap: () {
                  if (LocalStorage.getToken().isEmpty) {
                    context.pushRoute(LoginRoute());
                    return;
                  }

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
                child: Container(
                  margin: EdgeInsets.only(left: 8.w),
                  width: 56.r,
                  height: 56.r,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromRGBO(0, 0, 0, 0.8),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      const Icon(
                        Remix.shopping_basket_2_fill,
                        color: AppStyle.white,
                      ),
                      Positioned(
                        top: 9,
                        right: 8,
                        child: Badge(
                          label: Text(
                            isCartEmpty
                                ? "0"
                                : (ref.watch(shopOrderProvider).cart?.userCarts?.first.cartDetails?.length ?? 0)
                                .toString(),
                            style: const TextStyle(color: AppStyle.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
  Widget contentList() {
    final state = ref.watch(shopProvider);
    return SingleChildScrollView(
      child: (state.isProductLoading || state.isBrandsLoading)
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

String _getCartShopName(Cart? cart, WidgetRef ref) {
  if (cart == null) return "";

  final int? shopId = cart.shopId;
  if (shopId == null) return "";

  final homeState = ref.read(homeProvider);

  // Look for the shop in any of the loaded shop lists
  ShopData? foundShop;

  // Check in shops list
  foundShop = homeState.shops.firstWhere(
        (shop) => shop.id == shopId,
    orElse: () => ShopData(), // Empty shop data
  );

  if (foundShop.id != null) return foundShop.translation?.title ?? "";

  // Check in restaurant list
  foundShop = homeState.restaurant.firstWhere(
        (shop) => shop.id == shopId,
    orElse: () => ShopData(), // Empty shop data
  );

  if (foundShop.id != null) return foundShop.translation?.title ?? "";

  // Check in newRestaurant list
  foundShop = homeState.newRestaurant.firstWhere(
        (shop) => shop.id == shopId,
    orElse: () => ShopData(), // Empty shop data
  );

  if (foundShop.id != null) return foundShop.translation?.title ?? "";

  // Check in shopsRecommend list
  foundShop = homeState.shopsRecommend.firstWhere(
        (shop) => shop.id == shopId,
    orElse: () => ShopData(), // Empty shop data
  );

  if (foundShop.id != null) return foundShop.translation?.title ?? "";

  // Check in filterShops list
  foundShop = homeState.filterShops.firstWhere(
        (shop) => shop.id == shopId,
    orElse: () => ShopData(), // Empty shop data
  );

  return foundShop.translation?.title ?? "";
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

// Custom clipper for creating the triangle pointer
class TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(size.width / 2, size.height);
    path.lineTo(0, 0);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(TriangleClipper oldClipper) => false;
}