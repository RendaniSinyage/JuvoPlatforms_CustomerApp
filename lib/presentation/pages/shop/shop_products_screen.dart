import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:riverpodtemp/application/shop/shop_provider.dart';
import 'package:riverpodtemp/presentation/pages/shop/widgets/make_tab_bar.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../../application/shop/shop_notifier.dart';
import '../../../infrastructure/models/models.dart';
import '../../../infrastructure/services/app_helpers.dart';
import '../../../infrastructure/services/tr_keys.dart';
import '../../theme/app_style.dart';
import 'widgets/product_list.dart';

class ShopProductsScreen extends ConsumerStatefulWidget {
  final bool isPopularProduct;
  final int currentIndex;
  final String shopId;
  final String? cartId;
  final List<CategoryData>? listCategory;
  final ScrollController? nestedScrollCon;

  const ShopProductsScreen({
    super.key,
    this.nestedScrollCon,
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
  TextEditingController controller = TextEditingController();
  ScrollController scrollController = ScrollController();

  List<GlobalKey> keys = [];

  final headerKey = GlobalKey();
  Map<String, double> visbilities = {};

  addKeys() {
    keys.clear();
    keys.add(GlobalKey(debugLabel: 'popular'));
    widget.listCategory?.forEach((e) {
      keys.add(GlobalKey(debugLabel: e.uuid));
    });
    setState(() {});
  }

  @override
  void initState() {
    tabController = TabController(
        length: (widget.listCategory?.length ?? 0) +
            (ref.read(shopProvider).popularProducts.isNotEmpty ? 1 : 0),
        vsync: this)
      ..addListener(() {
        if (tabController?.indexIsChanging ?? false) {
          event.changeIndex(tabController!.index);
        }
      });
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
      addKeys();
      tabController = TabController(
          length: (widget.listCategory?.length ?? 0) +
              (ref.read(shopProvider).popularProducts.isNotEmpty ? 1 : 0),
          vsync: this)
        ..addListener(() {
          event.changeIndex(tabController!.index);
        });
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          key: headerKey,
          child: makeTabBarHeader(
            controller: controller,
            category: true,
            context: context,
            tabController: tabController,
            onTab: (val) async {
              event.changeIndex(val);
              widget.nestedScrollCon?.jumpTo(
                  widget.nestedScrollCon?.position.maxScrollExtent ?? 0);
              Scrollable.ensureVisible(keys[val].currentContext!,
                  duration: const Duration(milliseconds: 300));
            },
            index: widget.currentIndex,
            isPopularProduct: ref.watch(shopProvider).isPopularProduct,
            list: widget.listCategory,
            shopId: widget.shopId,
            cartId: widget.cartId,
          ),
        ),
        Expanded(
            child: SingleChildScrollView(
          child: (!ref.watch(shopProvider).isProductLoading &&
                  ref.watch(shopProvider).products.isEmpty)
              ?  _resultEmpty():Column(
                  children: [
                    VisibilityDetector(
                      key: keys.isNotEmpty ? keys[0] : const Key('popular'),
                      onVisibilityChanged: (VisibilityInfo info) {
                        {
                          final visibleRegion = (info.visibleBounds.bottom -
                                      info.visibleBounds.top)
                                  .abs() /
                              info.size.height;
                          if (visbilities['popular'] != null) {
                            visbilities.update(
                                "popular", (value) => visibleRegion);
                          } else {
                            visbilities.putIfAbsent(
                                "popular", () => visibleRegion);
                          }
                          // List<double> list = visbilities.values.toList();
                          // list.sort();
                          // final pinKey = visbilities.keys
                          //     .firstWhere((k) => visbilities[k] == list.last);

                          event.changeIndex(0);
                          tabController?.animateTo(0,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut);
                        }
                      },
                      child: ProductsList(
                        shopId: widget.shopId,
                        index: null,
                        cartId: widget.cartId,
                      ),
                    ),
                    ...List.generate(widget.listCategory?.length ?? 0, (index) {
                      final currentCategory = widget.listCategory?[index];
                      return VisibilityDetector(
                        key: keys.length > 1
                            ? keys[index + 1]
                            : Key(index.toString()),
                        onVisibilityChanged: (VisibilityInfo info) {
                          {
                            final visibleRegion = (info.visibleBounds.bottom -
                                        info.visibleBounds.top)
                                    .abs() /
                                info.size.height;
                            if (visbilities[currentCategory?.uuid ?? ''] !=
                                null) {
                              visbilities.update(currentCategory?.uuid ?? '',
                                  (value) => visibleRegion);
                            } else {
                              visbilities.putIfAbsent(
                                  currentCategory?.uuid ?? '',
                                  () => visibleRegion);
                            }
                            List<double> list = visbilities.values.toList();
                            list.sort();
                            final pinKey = visbilities.keys
                                .firstWhere((k) => visbilities[k] == list.last);
                            try {
                              event.changeIndex(
                                  (widget.listCategory?.indexWhere(
                                              (e) => e.uuid == pinKey) ??
                                          0) +
                                      1);
                              tabController?.animateTo(
                                  (widget.listCategory?.indexWhere(
                                              (e) => e.uuid == pinKey) ??
                                          0) +
                                      1,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut);
                            } catch (e) {
                              debugPrint("$e");
                            }
                          }
                        },
                        child: ProductsList(
                          shopId: widget.shopId,
                          index: 0,
                          cartId: widget.cartId,
                          categoryData: currentCategory,
                        ),
                      );
                    })
                  ],
                ),
        )),
      ],
    );
  }

  Widget _resultEmpty() {
    return Column(
      children: [
        Lottie.asset("assets/lottie/empty-box.json"),
        Text(
          AppHelpers.getTranslation(TrKeys.nothingFound),
          style: AppStyle.interSemi(size: 18.sp),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.w),
          child: Text(
            AppHelpers.getTranslation(TrKeys.trySearchingAgain),
            style: AppStyle.interRegular(size: 14.sp),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
