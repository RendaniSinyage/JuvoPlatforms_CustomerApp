import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:foodyman/app_constants.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:foodyman/presentation/theme/theme.dart';
import '../../application/webview/preloaded_webview_provider.dart';

import '../routes/app_router.dart';

class WebViewPage extends StatefulWidget {
  final String url;
  final WebViewController? preloadedController;
  final PreloadedWebViewState? preloadedState;

  const WebViewPage({
    super.key,
    required this.url,
    this.preloadedController,
    this.preloadedState,
  });

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late WebViewController controller;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    // Use preloaded controller if available, otherwise create a new one
    if (widget.preloadedController != null) {
      controller = widget.preloadedController!;

      // Use the isReady flag from the preloaded state if available
      if (widget.preloadedState?.isReady == true) {
        // If we know it's ready from the preloaded state
        isLoading = false;
      } else {
        // Set up a new navigation delegate to catch when it finishes
        controller.setNavigationDelegate(
          NavigationDelegate(
            onPageFinished: (String url) {
              if (mounted) {
                setState(() {
                  isLoading = false;
                });
              }
            },
            onNavigationRequest: (NavigationRequest request) {
              if (request.url.startsWith(AppConstants.baseUrl)) {
                context.replaceRoute(const MainRoute());
                return NavigationDecision.prevent;
              }
              return NavigationDecision.navigate;
            },
          ),
        );
      }
    } else {
      // Initialize controller without theme-dependent properties first
      controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageStarted: (String url) {},
            onPageFinished: (String url) {
              if (mounted) {
                setState(() {
                  isLoading = false;
                });
              }
            },
            onWebResourceError: (WebResourceError error) {},
            onNavigationRequest: (NavigationRequest request) {
              if (request.url.startsWith(AppConstants.baseUrl)) {
                context.replaceRoute(const MainRoute());
                return NavigationDecision.prevent;
              }
              return NavigationDecision.navigate;
            },
          ),
        );

      // Don't load URL yet - we'll do this in didChangeDependencies
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Now it's safe to access Theme
    if (widget.preloadedController == null) {
      // Set background color and load URL here
      controller.setBackgroundColor(Theme.of(context).scaffoldBackgroundColor);
      controller.loadRequest(Uri.parse(widget.url));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Use the app's theme background color for the scaffold
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          // The WebView is always present but initially invisible while loading
          AnimatedOpacity(
            opacity: isLoading ? 0.0 : 1.0,
            duration: const Duration(milliseconds: 300),
            child: WebViewWidget(controller: controller),
          ),
          // Loading indicator shows while content is loading
          if (isLoading)
            Center(
              child: CircularProgressIndicator(
                color: AppStyle.primary,
              ),
            ),
        ],
      ),
    );
  }
}