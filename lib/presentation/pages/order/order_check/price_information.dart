import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:riverpodtemp/application/order/order_state.dart';
import 'package:riverpodtemp/infrastructure/services/app_helpers.dart';
import 'package:riverpodtemp/infrastructure/services/tr_keys.dart';
import 'package:riverpodtemp/presentation/theme/app_style.dart';
import 'widgets/title_price.dart';

class PriceInformation extends StatelessWidget {
  final bool isOrder;

  final OrderState state;

  const PriceInformation(
      {super.key,
      required this.isOrder,

      required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        30.verticalSpace,
        TitleAndPrice(
          title: AppHelpers.getTranslation(TrKeys.subtotal),
          rightTitle: AppHelpers.numberFormat(
              isOrder: isOrder,
              symbol: (state.orderData?.currencyModel?.symbol),
              number: isOrder
                  ? state.orderData?.originPrice
                  : state.calculateData?.price ?? 0),
          textStyle: AppStyle.interRegular(
            size: 16,
            color: AppStyle.black,
          ),
        ),
        16.verticalSpace,
        TitleAndPrice(
          title: AppHelpers.getTranslation(TrKeys.deliveryPrice),
          rightTitle: AppHelpers.numberFormat(
            symbol: state.orderData?.currencyModel?.symbol,
            isOrder: isOrder,
            number: isOrder
                ? (state.orderData?.deliveryFee ?? 0)
                : (state.calculateData?.deliveryFee ?? 0),
          ),
          textStyle: AppStyle.interRegular(
            size: 16,
            color: AppStyle.black,
          ),
        ),
        16.verticalSpace,
        TitleAndPrice(
          title: AppHelpers.getTranslation(TrKeys.tax),
          rightTitle: AppHelpers.numberFormat(
              isOrder: isOrder,
              symbol: state.orderData?.currencyModel?.symbol,
              number: isOrder
                  ? ((state.orderData?.tax ?? 0))
                  : (state.calculateData?.totalTax ?? 0)),
          textStyle: AppStyle.interRegular(
            size: 16,
            color: AppStyle.black,
          ),
        ),
        16.verticalSpace,
        TitleAndPrice(
          title: AppHelpers.getTranslation(TrKeys.serviceFee),
          rightTitle: AppHelpers.numberFormat(
              isOrder: isOrder,
              symbol: state.orderData?.currencyModel?.symbol,
              number: isOrder
                  ? ((state.orderData?.serviceFee ?? 0))
                  : (state.calculateData?.serviceFee ?? 0)),
          textStyle: AppStyle.interRegular(
            size: 16,
            color: AppStyle.black,
          ),
        ),
        16.verticalSpace,
        TitleAndPrice(
          title: AppHelpers.getTranslation(TrKeys.deliveryTip),
          rightTitle: AppHelpers.numberFormat(
              isOrder: isOrder,
              symbol: state.orderData?.currencyModel?.symbol,
              number: state.orderData?.tips??0,),
          textStyle: AppStyle.interRegular(
            size: 16,
            color: AppStyle.black,
          ),
        ),
        16.verticalSpace,
        if( isOrder ? state.orderData?.totalDiscount != null : state.calculateData?.totalDiscount != null)
        TitleAndPrice(
          title: AppHelpers.getTranslation(TrKeys.discount),
          rightTitle:
              "-${AppHelpers.numberFormat(isOrder: isOrder, symbol: state.orderData?.currencyModel?.symbol, number: isOrder ? (state.orderData?.totalDiscount ?? 0) : (state.calculateData?.totalDiscount ?? 0))}",
          textStyle: AppStyle.interRegular(
            size: 16,
            color: AppStyle.red,
          ),
        ),
        16.verticalSpace,
        if( isOrder ? state.orderData?.coupon != null : state.calculateData?.couponPrice != null)
        TitleAndPrice(
          title: AppHelpers.getTranslation(TrKeys.promoCode),
          rightTitle:
              "-${AppHelpers.numberFormat(isOrder: isOrder, symbol: state.orderData?.currencyModel?.symbol, number: isOrder ? (state.orderData?.coupon ?? 0) : state.calculateData?.couponPrice)}",
          textStyle: AppStyle.interRegular(
            size: 16,
            color: AppStyle.red,
          ),
        ),
        16.verticalSpace,
        const Divider(
          color: AppStyle.textGrey,
        ),
        16.verticalSpace,
        TitleAndPrice(
          title: AppHelpers.getTranslation(TrKeys.total),
          rightTitle: AppHelpers.numberFormat(
            isOrder: isOrder,
            symbol: state.orderData?.currencyModel?.symbol,
            number: isOrder
                ? (state.orderData?.totalPrice?.isNegative ?? true)
                    ? 0
                    : state.orderData?.totalPrice
                : state.calculateData?.totalPrice,
          ),
          textStyle: AppStyle.interSemi(
            size: 20,
            color: AppStyle.black,
          ),
        ),
      ],
    );
  }
}
