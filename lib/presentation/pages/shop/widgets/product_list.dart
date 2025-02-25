import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:foodyman/infrastructure/models/models.dart';
import 'package:foodyman/infrastructure/services/app_helpers.dart';
import 'package:foodyman/infrastructure/services/tr_keys.dart';
import 'package:foodyman/presentation/components/title_icon.dart';
import 'package:foodyman/application/shop/shop_provider.dart';
import 'package:foodyman/application/shop/shop_state.dart';
import 'package:foodyman/application/shop_order/shop_order_provider.dart';
import 'package:foodyman/infrastructure/models/response/all_products_response.dart';
import '../../../../utils/products/product_card.dart';
import '../../../../utils/products/product_utils.dart';
import '../../product/product_page.dart';

extension MyExtension1 on Iterable<Product> {
  List<Product> search(ShopState state) {
    return where((element) {
      if (state.searchText.isNotEmpty) {
        bool isOk = false;
        int level = 0;
        state.searchText.split(' ').forEach(
              (e) {
            isOk = (element.translation?.title
                ?.toLowerCase()
                .contains(e.toLowerCase()) ??
                false) ||
                (element.translation?.description
                    ?.toLowerCase()
                    .contains(e.toLowerCase()) ??
                    false);
            if (isOk) {
              level++;
            }
          },
        );
        return level == state.searchText.split(' ').length;
      }
      return true;
    }).toList();
  }

  List<Product> category(int id) {
    return where((element) {
      return element.categoryId == id;
    }).toList();
  }
}

class ProductsList extends ConsumerStatefulWidget {
  final All? all;
  final int? shopId;
  final String? cartId;

  const ProductsList({
    super.key,
    this.cartId,
    this.all,
    required this.shopId,
  });

  @override
  ConsumerState<ProductsList> createState() => _ProductsListState();
}

class _ProductsListState extends ConsumerState<ProductsList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // This is just a fallback in case shop brands weren't loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final shopState = ref.read(shopProvider);

      // Only request brands if they haven't been loaded at all
      if ((shopState.brands == null || shopState.brands!.isEmpty) &&
          widget.shopId != null) {
        // Use shop ID to get all brands at once instead of by category
        ref.read(shopProvider.notifier).fetchBrands(context, widget.shopId!);
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    final state = ref.watch(shopProvider);
    final shopOrderState = ref.watch(shopOrderProvider);

    // Check if there are products to display
    final bool hasProducts =
        (widget.all?.products
            ?.search(state)
            .isNotEmpty ?? false) &&
            (widget.all?.products?.isNotEmpty ?? false);

    // Hide if it's the popular section with search text
    final bool shouldHidePopular =
        (widget.all?.products
            ?.search(state)
            .isNotEmpty ?? false) &&
            widget.all?.translation?.title ==
                AppHelpers.getTranslation(TrKeys.popular) &&
            state.searchText.isNotEmpty;

    if (shouldHidePopular) {
      return const SizedBox.shrink();
    }

    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        children: [
          // Section title
          if (hasProducts)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                12.verticalSpace,
                TitleAndIcon(title: widget.all?.translation?.title ?? ""),
                12.verticalSpace,
              ],
            ),

          // Products list
          if (hasProducts)
            Container(
              height: 200.h, // Fixed height for the horizontal list
              alignment: Alignment.topLeft, // Force left alignment
              child: AnimationLimiter(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.only(left: 16.w, right: 16.w),
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: widget.all?.products
                      ?.search(state)
                      .length ?? 0,
                  itemBuilder: (context, index) {
                    final product = (widget.all?.products?.search(state) ?? [])
                        .toList()[index];
                    final String imageUrl = product.img ?? "";
                    final bool isTransparentFormat = ProductUtils
                        .hasTransparentBackground(imageUrl);

                    // Get cart quantity
                    int cartQuantity = 0;
                    if (shopOrderState.cart != null) {
                      for (var userCart in shopOrderState.cart!.userCarts ??
                          []) {
                        if (userCart.cartDetails != null) {
                          for (var cartDetail in userCart.cartDetails!) {
                            if (cartDetail.stock?.id == product.stock?.id) {
                              final qtyInt = int.tryParse(
                                  cartDetail.quantity.toString()) ?? 0;
                              cartQuantity += qtyInt;
                            }
                          }
                        }
                      }
                    }

                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 375),
                      child: SlideAnimation(
                        horizontalOffset: 50.0,
                        child: FadeInAnimation(
                          child: Container(
                            width: 150.w, // Fixed width for each item
                            margin: EdgeInsets.only(right: 12.w),
                            child: GestureDetector(
                              onTap: () {
                                AppHelpers.showCustomModalBottomDragSheet(
                                  context: context,
                                  modal: (c) =>
                                      ProductScreen(
                                        cartId: widget.cartId,
                                        data: ProductData.fromJson(
                                            product.toJson()),
                                        controller: c,
                                      ),
                                  isDarkMode: false,
                                  isDrag: true,
                                  radius: 16,
                                );
                              },
                              child: ProductCard(
                                product: product,
                                hasTransparentBg: isTransparentFormat,
                                cartQuantity: cartQuantity,
                                cartId: widget.cartId,
                                onTap: () {
                                  AppHelpers.showCustomModalBottomDragSheet(
                                    context: context,
                                    modal: (c) =>
                                        ProductScreen(
                                          cartId: widget.cartId,
                                          data: ProductData.fromJson(
                                              product.toJson()),
                                          controller: c,
                                        ),
                                    isDarkMode: false,
                                    isDrag: true,
                                    radius: 16,
                                  );
                                },
                                showShopName: false,
                                // Don't show shop name in ProductsList
                                canAddDirectly: _hasSimpleExtrasAddons(product),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

          16.verticalSpace, // Add space between categories
        ],
      ),
    );
  }

  // Function to check if a product has simple options,
  // now only used to pass to ProductCard for canAddDirectly property

  // Check if product has simple extras/addons
  bool _hasSimpleExtrasAddons(Product product) {
    try {
      final productData = ProductData.fromJson(product.toJson());

      // Check if there are stocks
      if (productData.stocks == null || productData.stocks!.isEmpty) {
        return true; // No stocks means it's simple (default)
      }

      // If there are multiple stocks, it's complex
      if (productData.stocks!.length > 1) {
        return false;
      }

      // Get the first stock
      final stock = productData.stocks!.first;

      // Check for extras
      if (stock.extras != null && stock.extras!.isNotEmpty) {
        // If any extras exist, it's complex
        return false;
      }

      // Check for addons
      if (stock.addons != null && stock.addons!.isNotEmpty) {
        // If any addons exist, it's complex
        return false;
      }

      // No extras or addons means it's simple
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error checking extras/addons: $e');
      }
      // Default to false (safer) if there's an error
      return false;
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}