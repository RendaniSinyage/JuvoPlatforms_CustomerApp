import 'package:flutter/material.dart';
import 'package:foodyman/infrastructure/models/data/order_active_model.dart';
import 'package:foodyman/infrastructure/models/data/refund_data.dart';
import 'package:foodyman/infrastructure/models/models.dart';
import 'package:foodyman/infrastructure/services/enums.dart';

import 'package:foodyman/domain/handlers/handlers.dart';
import 'package:foodyman/infrastructure/models/data/get_calculate_data.dart';

import '../../infrastructure/models/data/saved_card.dart';

abstract class OrdersRepositoryFacade {
  Future<ApiResult<GetCalculateModel>> getCalculate(
      {required int cartId,
      required double lat,
      required double long,
      required DeliveryTypeEnum type,
      String? coupon});

  Future<ApiResult<OrderActiveModel>> createOrder(OrderBodyData orderBody);

  Future<ApiResult> createAutoOrder(String from, String to, int orderId);

  Future<ApiResult> deleteAutoOrder(int orderId);

  Future<ApiResult<OrderPaginateResponse>> getCompletedOrders(int page);

  Future<ApiResult<OrderPaginateResponse>> getActiveOrders(int page);

  Future<ApiResult<OrderPaginateResponse>> getHistoryOrders(int page);

  Future<ApiResult<RefundOrdersModel>> getRefundOrders(int page);

  Future<ApiResult<OrderActiveModel>> getSingleOrder(num orderId);

  Future<ApiResult<LocalLocation>> getDriverLocation(int deliveryId);

  Future<ApiResult<void>> cancelOrder(num orderId);

  Future<ApiResult<void>> refundOrder(num orderId, String title);

  Future<ApiResult<void>> addReview(
    num orderId, {
    required double rating,
    required String comment,
  });

  // Added optional BuildContext parameter
  Future<ApiResult<String>> process(
      OrderBodyData orderBody,
      String name,
      {BuildContext? context, bool forceCardPayment = false, bool enableTokenization = false}
      );


  Future<ApiResult<String>> tipProcess(
      int? orderId, String paymentName, int? paymentId, num? tips);

  Future<ApiResult<CouponResponse>> checkCoupon({
    required String coupon,
    required int shopId,
  });

  Future<ApiResult<CashbackResponse>> checkCashback(
      {required double amount, required int shopId});

  Future<ApiResult<List<SavedCardModel>>> getSavedCards();

  /// Process payment with direct card input (no WebView)
  Future<ApiResult<String>> processDirectCardPayment(
      OrderBodyData orderBody,
      String cardNumber,
      String cardName,
      String expiryDate,
      String cvc,
      );

  /// Tokenizes a card for later use
  Future<ApiResult<String>> tokenizeCard({
    required String cardNumber,
    required String cardName,
    required String expiryDate,
    required String cvc,
  });

  /// Tokenizes a card after successful payment
  Future<ApiResult<String>> tokenizeAfterPayment(
      String cardNumber,
      String cardName,
      String expiryDate,
      String cvc,
      [String? token,
        String? lastFour,
        String? cardType]
      );

  /// Process payment using a saved card token
  Future<ApiResult<String>> processTokenPayment(
      OrderBodyData orderBody,
      String token,
      );

  Future<ApiResult<bool>> deleteCard(String cardId);

  /// Set a card as the default payment method
  Future<ApiResult<bool>> setDefaultCard(String cardId);

  ///Wallet
  Future<ApiResult<String>> processWalletTopUp(
      double amount, {
        BuildContext? context,
        bool forceCardPayment = false,
        bool enableTokenization = true,
      });

  Future<ApiResult<String>> processWalletTokenPayment(
      double amount,
      String token,
      );



}