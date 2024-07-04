import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:riverpodtemp/infrastructure/models/models.dart';
import 'package:riverpodtemp/infrastructure/services/app_helpers.dart';
import 'package:riverpodtemp/infrastructure/services/tr_keys.dart';
import 'package:riverpodtemp/presentation/components/title_icon.dart';

import '../../../../application/shop/shop_provider.dart';
import '../../../../application/shop/shop_state.dart';
import '../../../../infrastructure/models/response/all_products_response.dart';
import '../../product/product_page.dart';
import 'shimmer_product_list.dart';
import 'shop_product_item.dart';

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
}

class ProductsList extends ConsumerStatefulWidget {
  final CategoryData? categoryData;
  final String shopId;
  final int? index;
  final String? cartId;

  const ProductsList({
    Key? key,
    this.categoryData,
    this.index,
    this.cartId,
    required this.shopId,
  }) : super(key: key);

  @override
  ConsumerState<ProductsList> createState() => _ProductsListState();
}

class _ProductsListState extends ConsumerState<ProductsList> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(shopProvider);
    final productList = _buildProductList(state);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_shouldShowTitle(state)) ...[
          5.verticalSpace,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: TitleAndIcon(
              title: _getTitleText(state),
            ),
          ),
        ],
        if (productList != null) ...[
          12.verticalSpace,
          SizedBox(
            height: 250.r,
            child: state.isProductLoading
                ? const ShimmerProductList()
                : productList,
          ),
        ],
      ],
    );
  }

  bool _shouldShowTitle(ShopState state) {
    return (widget.index == null && state.searchText.isEmpty && state.popularProducts.isNotEmpty) ||
        ((state.products.where((element) => element.categoryId == widget.categoryData?.id)).isNotEmpty &&
            state.products.where((element) => element.categoryId == widget.categoryData?.id).search(state).isNotEmpty);
  }

  String _getTitleText(ShopState state) {
    return widget.index == null && state.searchText.isEmpty
        ? AppHelpers.getTranslation(TrKeys.popular)
        : widget.categoryData?.translation?.title ?? "";
  }

  Widget? _buildProductList(ShopState state) {
    final products = _getProductList(state);

    if (products.isEmpty) {
      return null;
    }

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(right: 12.w),
          child: SizedBox(
            width: 150.r,
            child: GestureDetector(
              onTap: () => _onProductTap(context, products[index]),
              child: ShopProductItem(
                product: products[index],
              ),
            ),
          ),
        );
      },
    );
  }

  List<Product> _getProductList(ShopState state) {
    return widget.index == null && state.searchText.isEmpty
        ? state.popularProducts
        : state.products
        .where((element) => element.categoryId == widget.categoryData?.id)
        .search(state)
        .toList();
  }

  void _onProductTap(BuildContext context, Product product) {
    AppHelpers.showCustomModalBottomDragSheet(
      context: context,
      modal: (c) => ProductScreen(
        cartId: widget.cartId,
        data: ProductData.fromJson(product.toJson()),
        controller: c,
      ),
      isDarkMode: false,
      isDrag: true,
      radius: 16,
    );
  }
}