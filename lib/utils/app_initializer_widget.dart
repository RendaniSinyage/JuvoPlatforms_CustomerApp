
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_initializer.dart';

class AppInitializerWidget extends StatefulWidget {
  final Widget child;

  const AppInitializerWidget({super.key, required this.child});

  @override
  _AppInitializerWidgetState createState() => _AppInitializerWidgetState();
}

class _AppInitializerWidgetState extends State<AppInitializerWidget> {
  bool _isInitialized = false;
  late ProviderContainer _providerContainer;

  @override
  void initState() {
    super.initState();
    _providerContainer = ProviderContainer();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    final appInitializer = AppInitializer(providerContainer: _providerContainer);
    await appInitializer.initializeRemoteConfigWithoutAPICall();
    setState(() {
      _isInitialized = true;
    });

    // Add a small delay before checking the API status
    await Future.delayed(Duration(milliseconds: 100));

    await appInitializer.checkAppStatusFromAPI();
  }

  @override
  void dispose() {
    _providerContainer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return MaterialApp(  // Wrap in MaterialApp to ensure proper context
        home: Scaffold(
          body: Center(
            child: Image.asset(
              'assets/images/splash.png',
              fit: BoxFit.fill,
            ),
          ),
        ),
      );
    }

    return UncontrolledProviderScope(
      container: _providerContainer,
      child: widget.child,
    );
  }
}
