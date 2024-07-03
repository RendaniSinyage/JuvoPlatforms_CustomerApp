import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpodtemp/application/shop/shop_provider.dart';
import 'package:riverpodtemp/presentation/pages/shop/widgets/make_tab_bar.dart';
import '../../../application/shop/shop_notifier.dart';
import '../../../infrastructure/models/models.dart';
import 'widgets/product_list.dart';

class ShopProductsScreen extends ConsumerStatefulWidget {
  final bool isPopularProduct;
  final int currentIndex;
  final String shopId;
  final String? cartId;
  final List<CategoryData>? listCategory;

  const ShopProductsScreen({
    super.key,
    required this.isPopularProduct,
    required this.listCategory,
    required this.currentIndex,
    required this.shopId,
    this.cartId,
  });

  @override
  ConsumerState<ShopProductsScreen> createState() => _ShopProductsScreenState();
}

class _ShopProductsScreenState extends ConsumerState<ShopProductsScreen>
    with TickerProviderStateMixin {
  TabController? tabController;
  late ShopNotifier event;

  @override
  void initState() {
    if (widget.isPopularProduct) {
      tabController = TabController(length: 2, vsync: this)
        ..addListener(() {
          if (tabController?.indexIsChanging ?? false) {
            ref.read(shopProvider.notifier).changeIndex(tabController!.index);
          }
        });
    } else {
      tabController = TabController(length: 1, vsync: this)
        ..addListener(() {
          if (tabController?.indexIsChanging ?? false) {
            ref.read(shopProvider.notifier).changeIndex(tabController!.index);
          }
        });
    }
    super.initState();
  }

  @override
  void didChangeDependencies() {
    event = ref.read(shopProvider.notifier);
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant ShopProductsScreen oldWidget) {
    if (oldWidget.isPopularProduct != widget.isPopularProduct ||
        oldWidget.listCategory?.length != widget.listCategory?.length) {
      if (widget.isPopularProduct) {
        tabController = TabController(length: 2, vsync: this)
          ..addListener(() {
            ref.read(shopProvider.notifier).changeIndex(tabController!.index);
          });
      } else {
        tabController = TabController(length: 1, vsync: this)
          ..addListener(() {
            ref.read(shopProvider.notifier).changeIndex(tabController!.index);
          });
      }
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        makeTabBarHeader(
            category: true,
            context: context,
            tabController: tabController,
            onTab: (val) {
              event.changeIndex(val);
            },
            index: widget.currentIndex,
            isPopularProduct: ref.watch(shopProvider).isPopularProduct,
            list: widget.listCategory,
            shopId: widget.shopId,
            cartId: widget.cartId),
        Expanded(
            child: ref.watch(shopProvider).isPopularProduct
                ? TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                controller: tabController,
                children: [
                  ProductsList(
                    shopId: widget.shopId,
                    index: 1,
                    cartId: widget.cartId,
                  ),
                  ProductsList(
                    shopId: widget.shopId,
                    index: 0,
                    cartId: widget.cartId,
                  ),
                ])
                : TabBarView(
              controller: tabController,
              children: [
                ProductsList(
                  shopId: widget.shopId,
                  index: 0,
                  cartId: widget.cartId,
                ),
              ],
            )),
      ],
    );
  }
}
