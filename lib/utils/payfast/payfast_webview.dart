import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../app_constants.dart';
import '../../domain/di/dependency_manager.dart';
import '../../infrastructure/services/app_helpers.dart';
import '../../infrastructure/services/tr_keys.dart';
import '../../presentation/components/buttons/custom_button.dart';
import '../../presentation/routes/app_router.dart';
import '../../presentation/theme/theme.dart';

// Provider for preloaded WebView state
final payFastWebViewProvider = StateProvider<PayFastWebViewState?>((ref) => null);

// State class for tracking preloaded WebView
class PayFastWebViewState {
  final WebViewController controller;
  final String url;
  final bool isReady;

  PayFastWebViewState({
    required this.controller,
    required this.url,
    this.isReady = false,
  });

  PayFastWebViewState copyWith({
    WebViewController? controller,
    String? url,
    bool? isReady,
  }) {
    return PayFastWebViewState(
      controller: controller ?? this.controller,
      url: url ?? this.url,
      isReady: isReady ?? this.isReady,
    );
  }
}

/// Enhanced WebView specifically for PayFast payments with token capture
class PayFastWebView extends StatefulWidget {
  final String url;
  final Function(bool)? onComplete;
  final Function(String, Map<String, String>)? onTokenCaptured;
  final WebViewController? preloadedController;

  const PayFastWebView({
    super.key,
    required this.url,
    this.onComplete,
    this.onTokenCaptured,
    this.preloadedController,
  });

  @override
  State<PayFastWebView> createState() => _PayFastWebViewState();
}

class _PayFastWebViewState extends State<PayFastWebView> {
  late WebViewController controller;
  bool isLoading = true;
  bool isPaymentComplete = false;
  bool _isControllerInitialized = false;

  @override
  void initState() {
    super.initState();

    // Only initialize non-theme dependent aspects of the controller
    if (widget.preloadedController != null) {
      controller = widget.preloadedController!;
      _isControllerInitialized = true;

      // Check if already loaded
      controller.currentUrl().then((currentUrl) {
        if (currentUrl == widget.url) {
          setState(() {
            isLoading = false;
          });
        } else {
          // Load the URL if it's different
          controller.loadRequest(Uri.parse(widget.url));
        }
      });

      // Setup navigation delegate
      _setupNavigationDelegate();

    } else {
      // Initialize with non-theme dependent settings
      controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted);

      // Rest of initialization will happen in didChangeDependencies
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Don't re-initialize if already done (avoid infinite loops)
    if (!_isControllerInitialized) {
      // Now we can safely access Theme
      controller.setBackgroundColor(Theme.of(context).scaffoldBackgroundColor);

      // Setup navigation delegate
      _setupNavigationDelegate();

      // Load the URL
      controller.loadRequest(Uri.parse(widget.url));

      _isControllerInitialized = true;
    }
  }

  void _setupNavigationDelegate() {
    controller.setNavigationDelegate(
      NavigationDelegate(
        onPageStarted: (String url) {
          debugPrint('PayFast WebView started loading: $url');
        },
        onPageFinished: (String url) {
          if (mounted) {
            setState(() {
              isLoading = false;
            });
          }
          debugPrint('PayFast WebView finished loading: $url');

          // Check for success or return URLs
          _checkForPaymentCompletion(url);
        },
        onWebResourceError: (WebResourceError error) {
          debugPrint('PayFast WebView error: ${error.description}');

          // Show error message for serious errors
          if (error.errorCode >= 400) {
            AppHelpers.showCheckTopSnackBarInfo(
              context,
              'Payment error: ${error.description}',
            );
          }
        },
        onNavigationRequest: (NavigationRequest request) {
          debugPrint('PayFast WebView navigation: ${request.url}');

          // Check for success or cancel URLs
          if (_checkForPaymentCompletion(request.url)) {
            return NavigationDecision.prevent;
          }

          // Allow normal navigation
          return NavigationDecision.navigate;
        },
      ),
    );
  }

  // Check if the URL indicates payment completion (success or failure)
  bool _checkForPaymentCompletion(String url) {
    // Don't process if already detected payment completion
    if (isPaymentComplete) return false;

    debugPrint('PayFast URL check: $url');

    // Parse URL to check for token and other parameters
    final uri = Uri.parse(url);
    final params = uri.queryParameters;

    // Log all parameters to help with debugging
    debugPrint('PayFast URL parameters: $params');

    // Specifically log all custom_str fields
    debugPrint('PayFast custom_str1: ${params['custom_str1']}');
    debugPrint('PayFast custom_str2: ${params['custom_str2']}');
    debugPrint('PayFast custom_str3: ${params['custom_str3']}');
    debugPrint('PayFast custom_str4: ${params['custom_str4']}');
    debugPrint('PayFast custom_str5: ${params['custom_str5']}');

    // Log token parameter
    debugPrint('PayFast token value: ${params['token']}');

    // Match patterns for success
    bool isSuccess = url.contains('order-stripe-success') ||
        url.contains('payment-success') ||
        url.contains('redirect-success') ||
        url.contains(AppConstants.baseUrl);

    // Match patterns for cancellation or failure
    bool isFailure = url.contains('payment-cancel') ||
        url.contains('payment-failed') ||
        url.contains('redirect-cancel');

    // Check if the URL contains success indicators
    if (isSuccess) {
      isPaymentComplete = true;

      // Check for token in various potential places
      final token = params['token'] ?? params['pf_token'] ?? params['payfast_token'];

      // Extract card details
      final cardData = {
        'last_four': params['card_last_digits'] ?? params['last_four'] ?? params['cardlastfour'] ??  '••••',
        'card_type': params['card_brand'] ?? params['card_type'] ?? 'Card',
        'expiry_date': params['card_expiry'] ?? params['expiry'] ?? '',
        'card_holder_name': params['card_holder'] ?? '',
      };

      debugPrint('PayFast card details found: $cardData');

      // If token exists, capture it along with card details
      if (token != null && token.isNotEmpty) {
        debugPrint('PayFast token found: $token');

        // Notify about token capture using callback
        if (widget.onTokenCaptured != null) {
          // Pass both token and card details to the callback
          widget.onTokenCaptured!(token, cardData);
        } else {
          // If no callback is provided, save directly
          _saveToken(token, cardData);
        }
      } else {
        debugPrint('No token found in return URL');
      }

      // Show success message
      AppHelpers.showCheckTopSnackBarDone(
        context,
        AppHelpers.getTranslation(TrKeys.paymentSuccessful),
      );

      // Perform success actions
      if (widget.onComplete != null) {
        widget.onComplete!(true);
      }

      // Navigate back to main route
      Future.delayed(const Duration(milliseconds: 500), () {
        context.replaceRoute(const MainRoute());
      });

      return true;
    }
    // Check if the URL contains cancel/failure indicators
    else if (isFailure) {
      isPaymentComplete = true;

      // Show error message
      AppHelpers.showCheckTopSnackBarInfo(
        context,
        AppHelpers.getTranslation(TrKeys.paymentRejected),
      );

      // Inform parent about failure
      if (widget.onComplete != null) {
        widget.onComplete!(false);
      }

      // Navigate back
      Navigator.pop(context);

      return true;
    }

    // Not a completion URL
    return false;
  }
  // Method to save token
  void _saveToken(String token, Map<String, String> cardData) async {
    try {
      // Use OrderRepository to save the token with card details
      await ordersRepository.tokenizeAfterPayment(
          '', // Empty card number since we're using token
          cardData['card_holder_name'] ?? '',
          cardData['expiry_date'] ?? '',
          '', // Empty CVC since we're using token
          token, // Pass the token
          cardData['last_four'] ?? '••••',
          cardData['card_type'] ?? 'Card'
      );

      debugPrint('PayFast token and card details saved successfully');
    } catch (e) {
      debugPrint('Failed to save PayFast token and card details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppStyle.white,
        elevation: 0,
        title: Text(
          AppHelpers.getTranslation(TrKeys.checkout),
          style: AppStyle.interNormal(),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppStyle.black),
          onPressed: () {
            // Confirm before closing the payment
            AppHelpers.showAlertDialog(
              context: context,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    AppHelpers.getTranslation(TrKeys.areYouSure),
                    style: AppStyle.interSemi(size: 16.sp),
                    textAlign: TextAlign.center,
                  ),
                  24.verticalSpace,
                  CustomButton(
                    background: AppStyle.red,
                    textColor: AppStyle.white,
                    title: AppHelpers.getTranslation(TrKeys.cancel),
                    onPressed: () {
                      Navigator.pop(context); // Close dialog
                      Navigator.pop(context); // Close WebView

                      // Inform parent about cancellation
                      if (widget.onComplete != null) {
                        widget.onComplete!(false);
                      }
                    },
                  ),
                  16.verticalSpace,
                  CustomButton(
                    borderColor: AppStyle.black,
                    background: AppStyle.transparent,
                    title: AppHelpers.getTranslation(TrKeys.stay),
                    onPressed: () {
                      Navigator.pop(context); // Just close the dialog
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
      body: Stack(
        children: [
          // The WebView
          AnimatedOpacity(
            opacity: isLoading ? 0.0 : 1.0,
            duration: const Duration(milliseconds: 300),
            child: WebViewWidget(controller: controller),
          ),

          // Loading indicator
          if (isLoading)
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                    color: AppStyle.primary,
                  ),
                  16.verticalSpace,
                  Text(
                    AppHelpers.getTranslation(TrKeys.loading),
                    style: AppStyle.interSemi(size: 14.sp),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// Utility class for preloading PayFast WebView
class PayFastWebViewPreloader {
  /// Preloads a WebView with the given PayFast URL
  static void preloadPayFastWebView(BuildContext context, String url) {
    try {
      // Create the controller first
      final controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted);

      // Set initial state
      ProviderScope.containerOf(context).read(payFastWebViewProvider.notifier).state =
          PayFastWebViewState(
            controller: controller,
            url: url,
            isReady: false,
          );

      // Now set theme-dependent properties
      controller.setBackgroundColor(Theme.of(context).scaffoldBackgroundColor);

      controller.setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String loadedUrl) {
            // Update provider state when load is complete
            ProviderScope.containerOf(context).read(payFastWebViewProvider.notifier).state =
                PayFastWebViewState(
                  controller: controller,
                  url: url,
                  isReady: true,
                );
            debugPrint('PayFast WebView preloaded: $url');
          },
          onNavigationRequest: (NavigationRequest request) {
            // Allow all navigation during preloading
            return NavigationDecision.navigate;
          },
        ),
      );

      // Load the URL
      controller.loadRequest(Uri.parse(url));
      debugPrint('Started preloading PayFast WebView: $url');
    } catch (e) {
      debugPrint('PayFast WebView preload error: $e');
    }
  }

  /// Get the preloaded WebView controller if available and matching the URL
  static WebViewController? getPreloadedController(WidgetRef ref, String url) {
    final preloadedState = ref.read(payFastWebViewProvider);
    if (preloadedState != null && preloadedState.url == url && preloadedState.isReady) {
      return preloadedState.controller;
    }
    return null;
  }
}