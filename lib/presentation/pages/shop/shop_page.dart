// ignore_for_file: unused_result, deprecated_member_use

import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:riverpodtemp/application/shop/shop_notifier.dart';
import 'package:riverpodtemp/infrastructure/models/data/shop_data.dart';
import 'package:riverpodtemp/infrastructure/services/app_helpers.dart';
import 'package:riverpodtemp/infrastructure/services/tr_keys.dart';
import 'package:riverpodtemp/presentation/components/buttons/custom_button.dart';
import 'package:riverpodtemp/presentation/components/buttons/pop_button.dart';
import 'package:riverpodtemp/presentation/components/loading.dart';
import 'package:riverpodtemp/application/like/like_notifier.dart';
import 'package:riverpodtemp/application/like/like_provider.dart';
import 'package:riverpodtemp/presentation/components/text_fields/outline_bordered_text_field.dart';
import 'package:riverpodtemp/presentation/pages/product/product_page.dart';
import 'package:riverpodtemp/presentation/pages/shop/shop_products_screen.dart';
import 'package:riverpodtemp/presentation/theme/theme.dart';

import '../../../../application/shop/shop_provider.dart';
import '../../../application/shop_order/shop_order_provider.dart';
import '../../../infrastructure/services/local_storage.dart';

import '../../components/buttons/animation_button_effect.dart';
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
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // scrollController.addListener(() {
    //   if (scrollController.offset >
    //       (144 +
    //           300.r +
    //           ((ref
    //                           .watch(shopProvider)
    //                           .shopData
    //                           ?.translation
    //                           ?.description
    //                           ?.length ??
    //                       0) >
    //                   40
    //               ? 30
    //               : 0) +
    //           (AppHelpers.getGroupOrder() ? 60.r : 0.r) +
    //           (ref.watch(shopProvider).shopData?.bonus == null ? 0 : 46.r) +
    //           (ref.watch(shopProvider).endTodayTime.hour > TimeOfDay.now().hour
    //               ? 0
    //               : 70.r))+20) {
    //     ref.read(shopProvider.notifier).enableNestedScroll();
    //   }
    // });

    ref.refresh(shopProvider);
    name = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (LocalStorage.getUserId() != widget.ownerId && widget.cartId != null) {
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
        );
      });
    });
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
              LocalStorage.getUserId() !=
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
              : NestedScrollView(
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) {
                    return [
                      SliverAppBar(
                        // bottom: PreferredSize(preferredSize: Size(300, 100), child: Container(
                        //   height: 40,
                        //   color: Colors.red,
                        // )),
                        backgroundColor: AppStyle.white,
                        automaticallyImplyLeading: false,
                        toolbarHeight: (144 +
                            300.r +
                            ((state.shopData?.translation?.description
                                            ?.length ??
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
                        flexibleSpace: FlexibleSpaceBar(
                          background: ShopPageAvatar(
                            workTime: state.endTodayTime.hour >
                                    TimeOfDay.now().hour
                                ? "${state.startTodayTime.hour.toString().padLeft(2, '0')}:${state.startTodayTime.minute.toString().padLeft(2, '0')} - ${state.endTodayTime.hour.toString().padLeft(2, '0')}:${state.endTodayTime.minute.toString().padLeft(2, '0')}"
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
                    ];
                  },physics:  const AlwaysScrollableScrollPhysics(),
                  controller: scrollController,
                  body: ShopProductsScreen(
                    nestedScrollCon: scrollController,
                    isPopularProduct: state.isPopularProduct,
                    listCategory: state.category,
                    currentIndex: state.currentIndex,
                    shopId: widget.shopId,

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
        ),
      ),
    );
  }
}
