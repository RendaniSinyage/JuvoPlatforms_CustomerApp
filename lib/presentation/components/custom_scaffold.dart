import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodyman/presentation/pages/initial/no_connection/no_connection_page.dart';
import 'package:foodyman/presentation/theme/app_style.dart';
import 'keyboard_dismisser.dart';

class CustomScaffold extends ConsumerStatefulWidget {
  final Widget body;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final Widget? drawer;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final PreferredSizeWidget? appBar;
  final Color? backgroundColor;

  const CustomScaffold(
      {super.key,
      required this.body,
      this.appBar,
      this.floatingActionButton,
      this.floatingActionButtonLocation,
      this.backgroundColor,
      this.bottomNavigationBar,
      this.drawer});

  @override
  ConsumerState<CustomScaffold> createState() => _CustomScaffoldState();
}

class _CustomScaffoldState extends ConsumerState<CustomScaffold>
    with WidgetsBindingObserver {
  StreamSubscription? connectivitySubscription;
  ValueNotifier<bool> isNetworkDisabled = ValueNotifier(false);

  void _checkCurrentNetworkState() {
    Connectivity().checkConnectivity().then((connectivityResult) {
      isNetworkDisabled.value = connectivityResult.contains(ConnectivityResult.none);
    });
  }

  initStateFunc() {
    _checkCurrentNetworkState();
    connectivitySubscription = Connectivity().onConnectivityChanged.listen(
      (result) {
        isNetworkDisabled.value = result.contains(ConnectivityResult.none);
      },
    );
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    initStateFunc();
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      _checkCurrentNetworkState();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    connectivitySubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ValueListenableBuilder(
            valueListenable: isNetworkDisabled,
            builder: (_, bool networkDisabled, __) => Visibility(
                  visible: !networkDisabled,
                  child: KeyboardDismisser(
                    child: Scaffold(
                      resizeToAvoidBottomInset: false,
                      appBar: widget.appBar,
                      backgroundColor:
                          widget.backgroundColor ?? AppStyle.bgGrey,
                      body: widget.body,
                      drawer: widget.drawer,
                      floatingActionButton: widget.floatingActionButton,
                      floatingActionButtonLocation:
                          widget.floatingActionButtonLocation,
                      bottomNavigationBar: widget.bottomNavigationBar,
                    ),
                  ),
                )),
        ValueListenableBuilder(
          valueListenable: isNetworkDisabled,
          builder: (_, bool networkDisabled, __) => Visibility(
            visible: networkDisabled,
            child: const NoConnectionPage(),
          ),
        ),
      ],
    );
  }
}
