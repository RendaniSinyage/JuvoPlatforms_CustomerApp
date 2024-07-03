import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:riverpodtemp/application/product/product_notifier.dart';
import 'package:riverpodtemp/application/product/product_state.dart';
import 'package:riverpodtemp/application/shop_order/shop_order_notifier.dart';
import 'package:riverpodtemp/application/shop_order/shop_order_state.dart';
import 'package:riverpodtemp/infrastructure/services/app_helpers.dart';
import 'package:riverpodtemp/infrastructure/services/local_storage.dart';
import 'package:riverpodtemp/infrastructure/services/tr_keys.dart';
import 'package:riverpodtemp/presentation/components/buttons/custom_button.dart';
import 'package:riverpodtemp/presentation/routes/app_router.dart';
import '../../../theme/app_style.dart';

class ProductMainButton extends StatelessWidget {
  final ShopOrderNotifier eventOrderShop;
  final ShopOrderState stateOrderShop;
  final ProductState state;
  final ProductNotifier event;
  final String? shopId;
  final String? cartId;
  final String? userUuid;

  const ProductMainButton(
      {super.key,
      required this.state,
      required this.event,
      required this.stateOrderShop,
      required this.eventOrderShop,
      this.shopId,
      this.cartId,
      this.userUuid});

  @override
  Widget build(BuildContext context) {
    num sumTotalPrice = 0;
    state.selectedStock?.addons?.forEach((element) {
      if (element.active ?? false) {
        sumTotalPrice += ((element.product?.stock?.totalPrice ?? 0) *
            (element.quantity ?? 1));
      }
    });
    sumTotalPrice =
        (sumTotalPrice + (state.selectedStock?.totalPrice ?? 0) * state.count);
    return Container(
      height: 130.h,
      color: AppStyle.white,
      padding: EdgeInsets.only(right: 16.w, left: 16.w),
      child: Column(
        children: [
          16.verticalSpace,
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 50.h,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.r)),
                    border: Border.all(color: AppStyle.textGrey)),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        event.disCount(context);
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 8.h, horizontal: 10.w),
                        child: const Icon(Icons.remove),
                      ),
                    ),
                    RichText(
                        text: TextSpan(
                            text:
                                "${state.count * (state.productData?.interval ?? 1)}",
                            style: AppStyle.interSemi(
                              size: 14,
                              color: AppStyle.black,
                            ),
                            children: [
                          TextSpan(
                            text:
                                " ${state.productData?.unit?.translation?.title ?? ""}",
                            style: AppStyle.interSemi(
                              size: 14,
                              color: AppStyle.textGrey,
                            ),
                          )
                        ])),
                    GestureDetector(
                      onTap: () {
                        event.addCount(context);
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 8.h, horizontal: 10.w),
                        child: const Icon(Icons.add),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: 120.w,
                child: CustomButton(
                  isLoading: state.isAddLoading,
                  title: AppHelpers.getTranslation(TrKeys.add),
                  onPressed: () {
                    if (LocalStorage.getToken().isNotEmpty) {
                      event.createCart(
                          context,
                          stateOrderShop.cart?.shopId ??
                              (state.productData!.shopId ?? 0), () {
                        Navigator.pop(context);
                        eventOrderShop.getCart(context, () {},
                            shopId: shopId, userUuid: userUuid, cartId: cartId);
                      },
                          isGroupOrder: userUuid?.isNotEmpty ?? false,
                          cartId: cartId,
                          userUuid: userUuid);
                    } else {
                      context.pushRoute(const LoginRoute());
                    }
                  },
                ),
              ),
            ],
          ),
          16.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppHelpers.getTranslation(TrKeys.total),
                style: AppStyle.interNormal(
                  size: 14,
                  color: AppStyle.black,
                ),
              ),
              Text(
                AppHelpers.numberFormat(number: sumTotalPrice),
                style: AppStyle.interNoSemi(
                  size: 20,
                  color: AppStyle.black,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
