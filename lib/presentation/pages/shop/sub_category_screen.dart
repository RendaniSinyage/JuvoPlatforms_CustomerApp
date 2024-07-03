import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:riverpodtemp/application/shop/shop_notifier.dart';
import 'package:riverpodtemp/application/shop/shop_provider.dart';
import 'package:riverpodtemp/application/shop_order/shop_order_provider.dart';
import 'package:riverpodtemp/infrastructure/services/app_helpers.dart';
import 'package:riverpodtemp/infrastructure/services/local_storage.dart';
import 'package:riverpodtemp/infrastructure/services/tr_keys.dart';
import 'package:riverpodtemp/presentation/components/buttons/animation_button_effect.dart';
import 'package:riverpodtemp/presentation/components/buttons/custom_button.dart';
import 'package:riverpodtemp/presentation/components/buttons/pop_button.dart';
import 'package:riverpodtemp/presentation/pages/shop/cart/cart_order_page.dart';
import 'package:riverpodtemp/presentation/pages/shop/widgets/make_tab_bar.dart';
import 'package:riverpodtemp/presentation/theme/app_style.dart';

import '../../../infrastructure/models/models.dart';
import 'product_filter.dart';
import 'widgets/product_list.dart';


@RoutePage()
class SubCategoryPage extends ConsumerStatefulWidget {
  final CategoryData? category;
  final String shopId;
  final String? cartId;

  const SubCategoryPage({
    super.key,
    required this.category,
    required this.shopId,
    required this.cartId,
  });

  @override
  ConsumerState<SubCategoryPage> createState() => _SubCategoryPageState();
}

class _SubCategoryPageState extends ConsumerState<SubCategoryPage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  late ShopNotifier event;
  List<String> sorts = [
    TrKeys.standard,
    TrKeys.leastExpensive,
    TrKeys.expensive,
  ];

  @override
  void initState() {
    tabController = TabController(
        length: (widget.category?.children?.length ?? 0) + 1, vsync: this)
      ..addListener(() {
        ref.read(shopProvider.notifier)
          ..clear()
          ..changeSubIndex(tabController.index)
          ..fetchProductsByCategory(
              context,
              widget.shopId,
              tabController.index == 0
                  ? (widget.category?.id ?? 0)
                  : (widget.category?.children?[tabController.index - 1].id ??
                      0))
          ..fetchBrands(
              context,
              tabController.index == 0
                  ? (widget.category?.id ?? 0)
                  : (widget.category?.children?[tabController.index - 1].id ??
                      0));
      });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(shopProvider.notifier)
        ..changeSubIndex(0)
        ..fetchProductsByCategory(
            context, widget.shopId, widget.category?.id ?? 0)
        ..fetchBrands(context, widget.category?.id ?? 0);
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    event = ref.read(shopProvider.notifier);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(shopProvider);
    return Directionality(
        textDirection:
            LocalStorage.getLangLtr() ? TextDirection.ltr : TextDirection.rtl,
        child: Scaffold(
          backgroundColor: AppStyle.bgGrey,
          body: SafeArea(
            bottom: false,
            child: Column(
              children: [
                16.verticalSpace,
                Row(
                  children: [
                    SizedBox(
                      width: 32.r,
                    ),
                    const Spacer(),
                    Text(
                      widget.category?.translation?.title ?? "",
                      style: AppStyle.interNormal(),
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () {
                        AppHelpers.showCustomModalBottomSheet(
                            paddingTop: MediaQuery.sizeOf(context).height / 3,
                            context: context,
                            modal: ProductFilter(
                              shopId: widget.shopId,
                              categoryId: tabController.index == 0
                                  ? (widget.category?.id ?? 0)
                                  : (widget
                                          .category
                                          ?.children?[tabController.index - 1]
                                          .id ??
                                      0),
                              sort: sorts,
                            ),
                            isDarkMode: false);
                      },
                      child: Padding(
                        padding: EdgeInsets.only(right: 16.r),
                        child: SvgPicture.asset("assets/svgs/filter.svg"),
                      ),
                    )
                  ],
                ),
                makeTabBarHeader(
                    index: state.subCategoryIndex,
                    shopId: widget.shopId,
                    context: context,
                    isPopularProduct: false,
                    list: widget.category?.children ?? [],
                    tabController: tabController,
                    onTab: (index) {
                      event.changeSubIndex(index);
                    },
                    cartId: widget.cartId),
                Expanded(
                    child: TabBarView(
                  controller: tabController,
                  children: [
                    ProductsList(
                      shopId: widget.shopId,
                      categoryData: widget.category,
                      cartId: widget.cartId,
                    ),
                    ...widget.category?.children?.map(
                          (e) => ProductsList(
                            shopId: widget.shopId,
                            categoryData: e,
                            cartId: widget.cartId,
                          ),
                        ) ??
                        []
                  ],
                )),
              ],
            ),
          ),
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
                        LocalStorage.getUserId() !=
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
                              color: AppStyle.brandGreen,
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
        ));
  }
}
