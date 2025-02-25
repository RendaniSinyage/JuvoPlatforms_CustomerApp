import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodyman/app_constants.dart';
import 'package:foodyman/domain/di/dependency_manager.dart';
import 'package:foodyman/domain/interface/orders.dart';
import 'package:foodyman/infrastructure/models/data/order_active_model.dart';
import 'package:foodyman/infrastructure/models/data/refund_data.dart';
import 'package:foodyman/infrastructure/models/models.dart';
import 'package:foodyman/infrastructure/services/app_helpers.dart';
import 'package:foodyman/infrastructure/services/enums.dart';
import 'package:foodyman/infrastructure/services/local_storage.dart';
import 'package:foodyman/domain/handlers/handlers.dart';
import 'package:payfast/payfast.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../application/webview/preloaded_webview_provider.dart';
import '../../utils/payfast/payfast_webview.dart';
import '../models/data/get_calculate_data.dart';
import '../models/data/saved_card.dart';

class OrdersRepository implements OrdersRepositoryFacade {
  @override
  Future<ApiResult<OrderActiveModel>> createOrder(
      OrderBodyData orderBody) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.post(
        '/api/v1/dashboard/user/orders',
        data: orderBody.toJson(),
      );
      return ApiResult.success(
        data: OrderActiveModel.fromJson(response.data),
      );
    } catch (e) {
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult> createAutoOrder(String from, String to, int orderId) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      await client.post(
        '/api/v1/dashboard/user/orders/$orderId/repeat',
        data: {"from": from, "to": to},
      );
      return const ApiResult.success(data: true);
    } catch (e) {
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult> deleteAutoOrder(int orderId) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      await client.delete(
        '/api/v1/dashboard/user/orders/$orderId/delete-repeat',
      );
      return const ApiResult.success(data: true);
    } catch (e) {
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<OrderPaginateResponse>> getCompletedOrders(int page) async {
    final data = {
      if (LocalStorage.getSelectedCurrency() != null)
        'currency_id': LocalStorage.getSelectedCurrency()?.id,
      'lang': LocalStorage.getLanguage()?.locale,
      'page': page,
      'status': 'completed',
    };
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.get(
        '/api/v1/dashboard/user/orders/paginate',
        queryParameters: data,
      );
      return ApiResult.success(
        data: OrderPaginateResponse.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> get completed orders failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<OrderPaginateResponse>> getActiveOrders(int page) async {
    final data = {
      if (LocalStorage.getSelectedCurrency() != null)
        'currency_id': LocalStorage.getSelectedCurrency()?.id,
      'lang': LocalStorage.getLanguage()?.locale,
      'page': page,
      'statuses[0]': "new",
      "statuses[1]": "accepted",
      "statuses[2]": "cooking",
      "statuses[3]": "ready",
      "statuses[4]": "on_a_way",
      "order_statuses": true,
      "perPage": 10
    };
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.get(
        '/api/v1/dashboard/user/orders/paginate',
        queryParameters: data,
      );
      return ApiResult.success(
        data: OrderPaginateResponse.fromJson(response.data),
      );
    } catch (e, s) {
      debugPrint('==> get open orders failure: $e, $s');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<OrderPaginateResponse>> getHistoryOrders(int page) async {
    final data = {
      if (LocalStorage.getSelectedCurrency() != null)
        'currency_id': LocalStorage.getSelectedCurrency()?.id,
      'lang': LocalStorage.getLanguage()?.locale,
      'statuses[0]': "delivered",
      "statuses[1]": "canceled",
      "order_statuses": true,
      "perPage": 10,
      "page": page
    };
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.get(
        '/api/v1/dashboard/user/orders/paginate',
        queryParameters: data,
      );
      return ApiResult.success(
        data: OrderPaginateResponse.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> get canceled orders failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<OrderActiveModel>> getSingleOrder(num orderId) async {
    final data = {
      if (LocalStorage.getSelectedCurrency() != null)
        'currency_id': LocalStorage.getSelectedCurrency()?.id,
      'lang': LocalStorage.getLanguage()?.locale
    };
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.get(
        '/api/v1/dashboard/user/orders/$orderId',
        queryParameters: data,
      );
      return ApiResult.success(
        data: OrderActiveModel.fromJson(response.data),
      );
    } catch (e, s) {
      debugPrint('==> get single order failure: $e,$s');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<void>> addReview(
      num orderId, {
        required double rating,
        required String comment,
      }) async {
    final data = {'rating': rating, if (comment != "") 'comment': comment};
    try {
      final client = dioHttp.client(requireAuth: true);
      await client.post(
        '/api/v1/dashboard/user/orders/review/$orderId',
        data: data,
      );
      return const ApiResult.success(data: null);
    } catch (e) {
      debugPrint('==> add order review failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<String>> process(
      dynamic orderBody, String name, {
        BuildContext? context,
        bool forceCardPayment = false,
        bool enableTokenization = false
      }) async {
    try {
      // Process the orderBody into the format expected by the API
      Map<String, dynamic> data;
      if (orderBody is OrderBodyData) {
        data = Map<String, dynamic>.from(orderBody.toJson());
      } else if (orderBody is Map) {
        data = Map<String, dynamic>.from(orderBody);
      } else {
        data = {'amount': orderBody};
      }

      debugPrint('==> order process request: ${jsonEncode(data)}');
      final client = dioHttp.client(requireAuth: true);
      var res = await client.get(
        '/api/v1/dashboard/user/order-$name-process',
        data: data,
      );

      if (name == "pay-fast") {
        final apiData = res.data["data"]["data"];

        // Get user information from data or other sources
        final user = LocalStorage.getUser();
        final String? email = data['email'] ?? user?.email;
        final String? phone = data['phone'];
        final String? firstName = user?.firstname;
        final String? lastName = user?.lastname;

        // Use PayFastService for enhanced payment
        final paymentUrl = Payfast.enhancedPayment(
          passphrase: AppConstants.passphrase,
          merchantId: AppConstants.merchantId,
          merchantKey: AppConstants.merchantKey,
          production: apiData["sandbox"] != 1,
          amount: apiData["amount"].toString(),
          itemName: apiData["item_name"] ?? 'Order',
          notifyUrl: apiData["notify_url"],
          cancelUrl: apiData["cancel_url"],
          returnUrl: apiData["return_url"],
          paymentId: res.data["data"]["id"].toString(),
          email: email,
          phone: phone,
          firstName: firstName,
          lastName: lastName,
          forceCardPayment: forceCardPayment,
          enableTokenization: enableTokenization,
        );

        // Start preloading the WebView if context is available
        if (context != null) {
          try {
            PayFastWebViewPreloader.preloadPayFastWebView(context, paymentUrl);
          } catch (e) {
            // If we can't preload, we'll just skip it
            debugPrint('==> Unable to preload PayFast WebView: $e');
          }
        }

        return ApiResult.success(data: paymentUrl);
      }

      return ApiResult.success(data: res.data["data"]["data"]["url"]);
    } catch (e, s) {
      debugPrint('==> order process failure: $e, $s');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<String>> processWalletTopUp(
      double amount, {
        BuildContext? context,
        bool forceCardPayment = false,
        bool enableTokenization = true,
      }) async {
    try {
      // Get the user's wallet ID
      final user = LocalStorage.getUser();
      final walletId = user?.wallet?.id;

      if (walletId == null) {
        return ApiResult.failure(
          error: "Wallet not found",
          statusCode: 404,
        );
      }

      // Create the payload for wallet top-up
      final data = {
        'wallet_id': walletId,
        'total_price': amount,
        'currency_id': LocalStorage.getSelectedCurrency()?.id ?? 1,
      };

      debugPrint('==> wallet top-up request: ${jsonEncode(data)}');
      final client = dioHttp.client(requireAuth: true);

      // Process PayFast top-up
      var res = await client.get(
        '/api/v1/dashboard/user/order-pay-fast-process',
        data: data,
      );

      // Debug the response
      debugPrint('==> wallet response: ${jsonEncode(res.data)}');

      final apiData = res.data?["data"]?["data"] ?? {};

      // Get user information
      final email = user?.email;
      final phone = user?.phone;
      final firstName = user?.firstname;
      final lastName = user?.lastname;

      // Use PayFastService for payment
      final paymentUrl = Payfast.enhancedPayment(
        passphrase: AppConstants.passphrase,
        merchantId: AppConstants.merchantId,
        merchantKey: AppConstants.merchantKey,
        production: apiData["sandbox"] != 1,
        amount: (apiData["amount"] ?? amount).toString(),
        itemName: 'Wallet Top-up',
        notifyUrl: apiData["notify_url"] ?? "",
        cancelUrl: apiData["cancel_url"] ?? "",
        returnUrl: apiData["return_url"] ?? "",
        paymentId: res.data?["data"]?["id"]?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString(),
        email: email,
        phone: phone,
        firstName: firstName,
        lastName: lastName,
        forceCardPayment: forceCardPayment,
        enableTokenization: enableTokenization,
      );

      // Preload the WebView if context is available
      if (context != null) {
        try {
          PayFastWebViewPreloader.preloadPayFastWebView(context, paymentUrl);
        } catch (e) {
          debugPrint('==> Unable to preload PayFast WebView: $e');
        }
      }

      return ApiResult.success(data: paymentUrl);
    } catch (e, s) {
      debugPrint('==> wallet top-up failure: $e, $s');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }


  // Process token payment for wallet top-up
  @override
  Future<ApiResult<String>> processWalletTokenPayment(
      double amount,
      String token,
      ) async {
    try {
      // Get the user's wallet ID
      final user = LocalStorage.getUser();
      final walletId = user?.wallet?.id;

      if (walletId == null) {
        return ApiResult.failure(
          error: "Wallet not found",
          statusCode: 404,
        );
      }

      final client = dioHttp.client(requireAuth: true);
      final data = {
        'wallet_id': walletId,
        'total_price': amount,
        'currency_id': LocalStorage.getSelectedCurrency()?.id ?? 1,
        'token': token,
      };

      final response = await client.post(
        '/api/v1/dashboard/user/pay-fast-token-wallet',
        data: data,
      );

      // Return success with transaction ID
      return ApiResult.success(
        data: response.data['transaction_id'] ?? '',
      );
    } catch (e) {
      debugPrint('==> wallet token payment failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  // Process token payment using a saved card
  @override
  Future<ApiResult<String>> processTokenPayment(
      OrderBodyData orderData,
      String token,
      ) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      final Map data = orderData.toJson();
      data['token'] = token;

      final response = await client.post(
        '/api/v1/dashboard/user/pay-fast-token',
        data: data,
      );

      // Return success with transaction ID
      return ApiResult.success(
        data: response.data['transaction_id'] ?? '',
      );
    } catch (e) {
      debugPrint('==> token payment failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }
  // Get saved cards for the current user
  @override
  Future<ApiResult<List<SavedCardModel>>> getSavedCards() async {
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.get('/api/v1/dashboard/user/saved-cards');

      // Debug log the response
      debugPrint('Saved cards response: ${jsonEncode(response.data)}');

      // Fix the nested data structure issue
      List<dynamic> cardsJson;

      if (response.data['data'] is Map && response.data['data'].containsKey('data')) {
        // Handle nested structure: {"data": {"data": [...]}}
        cardsJson = response.data['data']['data'] as List;
      } else if (response.data['data'] is List) {
        // Handle flat structure: {"data": [...]}
        cardsJson = response.data['data'] as List;
      } else {
        // If structure is unexpected, return empty list
        cardsJson = [];
      }

      // Convert JSON to SavedCardModel objects
      final cards = cardsJson.map((json) => SavedCardModel.fromJson(json)).toList();

      return ApiResult.success(data: cards);
    } catch (e) {
      debugPrint('==> get saved cards failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  // Delete a saved card
  @override
  Future<ApiResult<bool>> deleteCard(String cardId) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      await client.delete('/api/v1/dashboard/user/saved-cards/$cardId');

      return const ApiResult.success(data: true);
    } catch (e) {
      debugPrint('==> delete card failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  // Set a card as default
  @override
  Future<ApiResult<bool>> setDefaultCard(String cardId) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      await client.post('/api/v1/dashboard/user/saved-cards/$cardId/set-default');

      return const ApiResult.success(data: true);
    } catch (e) {
      debugPrint('==> set default card failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  /// Tokenize a card
  @override
  Future<ApiResult<String>> tokenizeCard({
    required String cardNumber,
    required String cardName,
    required String expiryDate,
    required String cvc,
  }) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.post(
        '/api/v1/dashboard/user/tokenize-card',
        data: {
          'card_number': cardNumber,
          'card_holder': cardName,
          'expiry_date': expiryDate,
          'cvc': cvc,
        },
      );

      // Return the token from PayFast
      return ApiResult.success(data: response.data['token']);
    } catch (e) {
      debugPrint('==> tokenize card failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }


  @override
  // Process a payment with direct card input (no WebView)
  Future<ApiResult<String>> processDirectCardPayment(
      OrderBodyData orderBody,
      String cardNumber,
      String cardName,
      String expiryDate,
      String cvc,
      ) async {
    try {
      final client = dioHttp.client(requireAuth: true);

      // Add card details to the order data
      final data = orderBody.toJson();
      data['card_number'] = cardNumber;
      data['card_holder'] = cardName;
      data['expiry_date'] = expiryDate;
      data['cvc'] = cvc;

      final response = await client.post(
        '/api/v1/dashboard/user/pay-fast-direct',
        data: data,
      );

      return ApiResult.success(
        data: response.data['transaction_id'],
      );
    } catch (e) {
      debugPrint('==> direct card payment failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

// Tokenize a card after successful payment
  @override
  Future<ApiResult<String>> tokenizeAfterPayment(
      String cardNumber,
      String cardName,
      String expiryDate,
      String cvc,
      [String? token,
        String? lastFour,
        String? cardType]
      ) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      final data = {
        'card_number': cardNumber,
        'card_holder': cardName,
        'expiry_date': expiryDate,
        'cvc': cvc,
      };

      // Add optional parameters if they're provided
      if (token != null) data['token'] = token;
      if (lastFour != null) data['last_four'] = lastFour;
      if (cardType != null) data['card_type'] = cardType;

      final response = await client.post(
        '/api/v1/dashboard/user/tokenize-card',
        data: data,
      );

      return ApiResult.success(data: response.data['token'] ?? token ?? '');
    } catch (e) {
      debugPrint('==> tokenize card failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }
  // Helper method to preload PayFast WebView
  void _preloadPayFastWebView(String url, BuildContext context) {
    try {
      // Create the controller with navigation delegate that doesn't reference the controller itself
      final WebViewController webController = WebViewController();

      // Configure the controller
      webController.setJavaScriptMode(JavaScriptMode.unrestricted);
      webController.setBackgroundColor(Theme.of(context).scaffoldBackgroundColor);

      // Set the navigation delegate after controller is fully created
      webController.setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String loadedUrl) {
            // Update the state when page is loaded
            ProviderScope.containerOf(context).read(preloadedWebViewProvider.notifier).state =
                PreloadedWebViewState(
                  controller: webController,
                  url: url,
                  isReady: true,
                );
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith(AppConstants.baseUrl)) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      );

      // Set initial state with the controller
      ProviderScope.containerOf(context).read(preloadedWebViewProvider.notifier).state =
          PreloadedWebViewState(
            controller: webController,
            url: url,
            isReady: false,
          );

      // Load the URL last
      webController.loadRequest(Uri.parse(url));
    } catch (e) {
      debugPrint('==> PayFast WebView preload error: $e');
    }
  }

  @override
  Future<ApiResult<String>> tipProcess(
      int? orderId,
      String paymentName,
      int? paymentId,
      num? tips,
      ) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      if (paymentName.toLowerCase() == 'wallet') {
        var res = await client.post(
          '/api/v1/payments/order/$orderId/transactions',
          data: {
            "tips": tips,
            "payment_sys_id": paymentId,
          },
        );
        return ApiResult.success(data: res.data["data"].toString());
      } else {
        var res = await client.get(
          '/api/v1/dashboard/user/order-${paymentName.toLowerCase()}-process',
          queryParameters: {
            "order_id": orderId,
            "tips": tips,
          },
        );
        return ApiResult.success(data: res.data["data"]["data"]["url"]);
      }
    } catch (e) {
      debugPrint('==> tip order failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<CouponResponse>> checkCoupon({
    required String coupon,
    required int shopId,
  }) async {
    final data = {
      'coupon': coupon,
      'shop_id': shopId,
    };
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.post(
        '/api/v1/rest/coupons/check',
        data: data,
      );
      return ApiResult.success(data: CouponResponse.fromJson(response.data));
    } catch (e) {
      debugPrint('==> check coupon failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<CashbackResponse>> checkCashback(
      {required double amount, required int shopId}) async {
    final data = {'amount': amount, "shop_id": shopId};
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.post(
        '/api/v1/rest/cashback/check',
        data: data,
      );
      return ApiResult.success(data: CashbackResponse.fromJson(response.data));
    } catch (e) {
      debugPrint('==> check cashback failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<GetCalculateModel>> getCalculate(
      {required int cartId,
        required double lat,
        required double long,
        required DeliveryTypeEnum type,
        String? coupon}) async {
    final data = {
      'address[latitude]': lat,
      'address[longitude]': long,
      if (LocalStorage.getSelectedCurrency() != null)
        'currency_id': LocalStorage.getSelectedCurrency()?.id,
      "type": type == DeliveryTypeEnum.delivery ? "delivery" : "pickup",
      "coupon": coupon,
    };
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.post(
        '/api/v1/dashboard/user/cart/calculate/$cartId',
        queryParameters: data,
      );
      return ApiResult.success(
          data: GetCalculateModel.fromJson(response.data["data"]));
    } catch (e) {
      debugPrint('==> check cashback failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<void>> cancelOrder(num orderId) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      await client.post(
        '/api/v1/dashboard/user/orders/$orderId/status/change?status=canceled',
      );
      return const ApiResult.success(data: null);
    } catch (e) {
      debugPrint('==> get cancel order failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<void>> refundOrder(num orderId, String title) async {
    try {
      final data = {
        "order_id": orderId,
        "cause": title,
      };
      final client = dioHttp.client(requireAuth: true);
      await client.post('/api/v1/dashboard/user/order-refunds', data: data);
      return const ApiResult.success(
        data: null,
      );
    } catch (e) {
      debugPrint('==> get cancel order failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<RefundOrdersModel>> getRefundOrders(int page) async {
    final data = {
      if (LocalStorage.getSelectedCurrency() != null)
        'currency_id': LocalStorage.getSelectedCurrency()?.id,
      'lang': LocalStorage.getLanguage()?.locale,
      "perPage": 10,
      "page": page
    };
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.get(
        '/api/v1/dashboard/user/order-refunds/paginate',
        queryParameters: data,
      );
      return ApiResult.success(
        data: RefundOrdersModel.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> get canceled orders failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }


  @override
  Future<ApiResult<LocalLocation>> getDriverLocation(int deliveryId) async {
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.get(
        '/api/v1/rest/orders/deliveryman/$deliveryId',
      );
      return ApiResult.success(
        data: LocalLocation.fromJson(
          response.data["data"]["delivery_man_setting"]["location"],
        ),
      );
    } catch (e) {
      debugPrint('==> get driver location failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }
}