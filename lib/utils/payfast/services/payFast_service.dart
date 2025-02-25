import 'dart:convert';
import 'package:crypto/crypto.dart' as crypto;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodyman/app_constants.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../application/webview/preloaded_webview_provider.dart';
import '../../../domain/di/dependency_manager.dart';
import '../../../domain/handlers/handlers.dart';
import '../../../infrastructure/models/data/saved_card.dart';
import '../../../infrastructure/models/models.dart';
import '../../../infrastructure/services/app_helpers.dart';

/// PayFast integration service
class PayFastService {
  /// Generates a PayFast payment URL with proper signature
  static String generatePaymentUrl({
    required String merchantId,
    required String merchantKey,
    required String passphrase,
    required bool production,
    required String amount,
    required String itemName,
    String? notifyUrl,
    String? returnUrl,
    String? cancelUrl,
    String? paymentId,
    String? email,
    String? phone,
    String? firstName,
    String? lastName,
    String? paymentMethod,
    String? subscriptionType,
  }) {
    // Create the parameters map in the correct order as per PayFast docs
    // 1. Merchant details
    final Map<String, String> params = {
      'merchant_id': merchantId,
      'merchant_key': merchantKey,
    };

    if (returnUrl != null && returnUrl.isNotEmpty) {
      params['return_url'] = returnUrl;
    }

    if (cancelUrl != null && cancelUrl.isNotEmpty) {
      params['cancel_url'] = cancelUrl;
    }

    if (notifyUrl != null && notifyUrl.isNotEmpty) {
      params['notify_url'] = notifyUrl;
    }

    // 2. Customer details
    if (firstName != null && firstName.isNotEmpty) {
      params['name_first'] = firstName;
    }

    if (lastName != null && lastName.isNotEmpty) {
      params['name_last'] = lastName;
    }

    if (email != null && email.isNotEmpty) {
      params['email_address'] = email;
    }

    if (phone != null && phone.isNotEmpty) {
      params['cell_number'] = phone;
    }

    // 3. Transaction details
    if (paymentId != null && paymentId.isNotEmpty) {
      params['m_payment_id'] = paymentId;
    }

    params['amount'] = amount;
    params['item_name'] = itemName;

    // Only add payment_method if specified
    if (paymentMethod != null && paymentMethod.isNotEmpty) {
      params['payment_method'] = paymentMethod;
    }

    // Add subscription_type for tokenization if specified
    if (subscriptionType != null && subscriptionType.isNotEmpty) {
      params['subscription_type'] = subscriptionType;
    }

    // Calculate signature according to PayFast documentation
    final signature = _createSignaturePerDocumentation(params, passphrase);
    params['signature'] = signature;

    // Debug
    debugPrint('PayFast params: ${jsonEncode(params)}');

    // Build the URL
    final host = production ? 'www.payfast.co.za' : 'sandbox.payfast.co.za';
    final queryString = _buildQueryString(params);

    return 'https://$host/eng/process?$queryString';
  }

  /// Preloads a PayFast WebView for faster checkout experience
  static void preloadPayFastWebView(BuildContext context, String paymentUrl) {
    try {
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
                  url: paymentUrl,
                  isReady: true,
                );
          },
          onNavigationRequest: (NavigationRequest request) {
            // Allow all navigation during preload
            return NavigationDecision.navigate;
          },
        ),
      );

      // Set initial state with the controller
      ProviderScope.containerOf(context).read(preloadedWebViewProvider.notifier).state =
          PreloadedWebViewState(
            controller: webController,
            url: paymentUrl,
            isReady: false,
          );

      // Load the URL last
      webController.loadRequest(Uri.parse(paymentUrl));
    } catch (e) {
      debugPrint('==> PayFast WebView preload error: $e');
    }
  }

  /// Process a payment for an order using a saved card token
  static Future<ApiResult<String>> processTokenPayment({
    required OrderBodyData orderData,
    required String token,
    required BuildContext context,
  }) async {
    try {
      final client = ordersRepository;

      return await client.processTokenPayment(orderData, token);
    } catch (e) {
      debugPrint('==> token payment failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  /// Get all saved cards for the current user
  static Future<ApiResult<List<SavedCardModel>>> getSavedCards() async {
    try {
      final client = ordersRepository;
      return await client.getSavedCards();
    } catch (e) {
      debugPrint('==> get saved cards failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  /// Delete a saved card by its ID
  static Future<ApiResult<bool>> deleteCard(String cardId) async {
    try {
      final client = ordersRepository;
      return await client.deleteCard(cardId);
    } catch (e) {
      debugPrint('==> delete card failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  /// Helper method to enhance payments
  static String enhancedPayment({
    required String passphrase,
    required String merchantId,
    required String merchantKey,
    required String amount,
    required String itemName,
    required bool production,
    String? notifyUrl,
    String? returnUrl,
    String? cancelUrl,
    String? paymentId,
    String? email,
    String? phone,
    String? firstName,
    String? lastName,
    bool forceCardPayment = false,
    bool enableTokenization = false,
  }) {
    return generatePaymentUrl(
      merchantId: merchantId,
      merchantKey: merchantKey,
      passphrase: passphrase,
      production: production,
      amount: amount,
      itemName: itemName,
      notifyUrl: notifyUrl,
      returnUrl: returnUrl,
      cancelUrl: cancelUrl,
      paymentId: paymentId,
      email: email,
      phone: phone,
      firstName: firstName,
      lastName: lastName,
      paymentMethod: forceCardPayment ? 'cc' : null,
      subscriptionType: enableTokenization ? '2' : null,
    );
  }

  /// Creates a query string from parameters
  static String _buildQueryString(Map<String, String> params) {
    final queryParts = <String>[];
    params.forEach((key, value) {
      queryParts.add('$key=${Uri.encodeComponent(value)}');
    });
    return queryParts.join('&');
  }

  /// Creates a signature exactly as specified in PayFast documentation
  static String _createSignaturePerDocumentation(Map<String, String> params, String passphrase) {
    // 1. Concatenate all non-blank variables in specified order with & separator
    final StringBuffer pfOutput = StringBuffer();

    params.forEach((key, value) {
      if (value.isNotEmpty) {
        // Use custom URL encoding to match PayFast's requirements
        pfOutput.write('$key=${_customUrlEncode(value)}&');
      }
    });

    // Remove last & and add passphrase
    String getString = pfOutput.toString();
    if (getString.endsWith('&')) {
      getString = getString.substring(0, getString.length - 1);
    }

    if (passphrase.isNotEmpty) {
      getString += '&passphrase=${_customUrlEncode(passphrase)}';
    }

    // Debug
    debugPrint('PayFast signature string: $getString');

    // Calculate MD5 hash
    final signature = crypto.md5.convert(utf8.encode(getString)).toString();
    debugPrint('PayFast generated signature: $signature');

    return signature;
  }

  /// Custom URL encode function to match PayFast's requirements:
  /// - Uppercase hexadecimal values
  /// - Spaces as +
  static String _customUrlEncode(String value) {
    // First do standard encoding
    String encoded = Uri.encodeComponent(value);

    // Replace lowercase hex with uppercase
    encoded = encoded.replaceAllMapped(RegExp(r'%[0-9a-f]{2}'), (match) {
      return match.group(0)!.toUpperCase();
    });

    // Replace %20 with +
    encoded = encoded.replaceAll('%20', '+');

    return encoded;
  }
}