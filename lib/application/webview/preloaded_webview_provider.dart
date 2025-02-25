import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:foodyman/app_constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../presentation/routes/app_router.dart';
import '../../presentation/theme/theme.dart';

final preloadedWebViewProvider = StateProvider<PreloadedWebViewState?>((ref) => null);

class PreloadedWebViewState {
  final WebViewController controller;
  final String url;
  final bool isReady;

  PreloadedWebViewState({
    required this.controller,
    required this.url,
    this.isReady = false,
  });

  PreloadedWebViewState copyWith({
    WebViewController? controller,
    String? url,
    bool? isReady,
  }) {
    return PreloadedWebViewState(
      controller: controller ?? this.controller,
      url: url ?? this.url,
      isReady: isReady ?? this.isReady,
    );
  }
}

class PreloadedWebViewService {
  static void preloadWebView(WidgetRef ref, String url, BuildContext context) {
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Theme.of(context).scaffoldBackgroundColor)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            ref.read(preloadedWebViewProvider.notifier).state =
                ref.read(preloadedWebViewProvider)?.copyWith(isReady: true);
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith(AppConstants.baseUrl)) {
              context.replaceRoute(const MainRoute());
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(url));

    ref.read(preloadedWebViewProvider.notifier).state = PreloadedWebViewState(
      controller: controller,
      url: url,
    );
  }
}

class WebViewPage extends ConsumerStatefulWidget {
  final String url;

  const WebViewPage({super.key, required this.url});

  @override
  ConsumerState<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends ConsumerState<WebViewPage> {
  late WebViewController controller;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    final preloadedState = ref.read(preloadedWebViewProvider);

    // Check if we have a preloaded webview for this URL
    if (preloadedState != null && preloadedState.url == widget.url) {
      controller = preloadedState.controller;
      isLoading = !preloadedState.isReady;
    } else {
      // If not preloaded or URL doesn't match, initialize a new controller
      controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(Theme.of(context).scaffoldBackgroundColor)
        ..setNavigationDelegate(
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
        )
        ..loadRequest(Uri.parse(widget.url));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          // The WebView is always present but initially invisible if still loading
          Opacity(
            opacity: isLoading ? 0.0 : 1.0,
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