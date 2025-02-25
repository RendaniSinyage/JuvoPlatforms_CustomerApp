import 'dart:async';
import 'package:flutter/material.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:remixicon/remixicon.dart';

import 'presentation/theme/theme.dart';

class CustomStatusBar extends StatefulWidget {
  final Widget child;

  const CustomStatusBar({super.key, required this.child});

  @override
  State<CustomStatusBar> createState() => _CustomStatusBarState();
}

class _CustomStatusBarState extends State<CustomStatusBar> {
  bool _showStatusBar = false;
  String _formattedTime = '';
  Timer? _timer;

  // Battery management
  final Battery _battery = Battery();
  int _batteryLevel = 100;
  BatteryState _batteryState = BatteryState.full;
  StreamSubscription<BatteryState>? _batteryStateSubscription;

  // Network connectivity
  final Connectivity _connectivity = Connectivity();
  List<ConnectivityResult> _connectionStatus = [];
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  bool _isWifiEnabled = false;
  bool _isMobileEnabled = false;
  bool _isHotspotEnabled = false;

  @override
  void initState() {
    super.initState();
    _updateTime();
    _timer = Timer.periodic(const Duration(minutes: 1), (_) => _updateTime());

    // Initialize battery and connectivity
    _initBattery();
    _initConnectivity();

    // Delayed initialization to avoid render issues
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _showStatusBar = true;
        });
      }
    });
  }

  Future<void> _initBattery() async {
    try {
      // Get initial battery level
      _batteryLevel = await _battery.batteryLevel;
      _batteryState = await _battery.batteryState;

      // Listen for battery changes
      _batteryStateSubscription = _battery.onBatteryStateChanged.listen((BatteryState state) async {
        if (mounted) {
          setState(() {
            _batteryState = state;
          });
          try {
            final level = await _battery.batteryLevel;
            if (mounted) {
              setState(() {
                _batteryLevel = level;
              });
            }
          } catch (e) {
            // Continue with existing battery level
          }
        }
      });
    } catch (e) {
      // Keep using default values
    }
  }

  Future<void> _initConnectivity() async {
    try {
      // Get initial connectivity state
      _connectionStatus = await _connectivity.checkConnectivity();
      _updateNetworkStatus();

      // Listen for connectivity changes
      _connectivitySubscription = _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> results) {
        if (mounted) {
          setState(() {
            _connectionStatus = results;
          });
          _updateNetworkStatus();
        }
      });
    } catch (e) {
      // Keep using default values
    }
  }

  void _updateNetworkStatus() {
    if (!mounted) return;

    bool isWifiEnabled = _connectionStatus.contains(ConnectivityResult.wifi);
    bool isMobileEnabled = _connectionStatus.contains(ConnectivityResult.mobile);

    setState(() {
      _isWifiEnabled = isWifiEnabled;
      _isMobileEnabled = isMobileEnabled;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _batteryStateSubscription?.cancel();
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  void _updateTime() {
    final now = DateTime.now();
    if (mounted) {
      setState(() {
        _formattedTime = '${now.hour}:${now.minute.toString().padLeft(2, '0')}';
      });
    }
  }

  Color _getBatteryColor() {
    if (_batteryState == BatteryState.charging || _batteryState == BatteryState.full) {
      return Colors.green;
    } else if (_batteryLevel <= 15) {
      return AppStyle.red;
    } else if (_batteryLevel <= 30) {
      return Colors.orange;
    } else {
      return AppStyle.white; // Always use white for normal battery level
    }
  }

  @override
  Widget build(BuildContext context) {
    // During initial build, just return the child without any modifications
    if (!_showStatusBar) {
      return widget.child;
    }

    // Always use white text
    const Color textColor = AppStyle.white;

    // Add Directionality widget to fix the error
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Stack(
        children: [
          // Main content
          widget.child,

          // Status bar overlay with no background
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 24,
              color: AppStyle.transparent,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Time on left
                  Text(
                    _formattedTime,
                      style: AppStyle.logoFontBold(color: textColor, size: 16.sp)
                  ),

                  // Network and Battery on right
                  Row(
                    children: [
                      // WiFi icon if enabled - showing icon instead of text
                      if (_isWifiEnabled)
                        const Icon(Remix.wifi_line, size: 14, color: textColor),

                      // Hotspot icon if enabled
                      if (_isHotspotEnabled)
                        const Padding(
                          padding: EdgeInsets.only(left: 4),
                          child: Icon(Remix.wifi_fill, size: 14, color: textColor),
                        ),

                      const SizedBox(width: 8),

                      // Battery icon using Remix icons
                      Icon(
                        _getBatteryIcon(),
                        size: 16,
                        color: _getBatteryColor(),
                      ),

                      // Battery percentage
                      const SizedBox(width: 4),
                      Text(
                        "$_batteryLevel%",
                        style: const TextStyle(
                          fontSize: 10,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getBatteryIcon() {
    if (_batteryState == BatteryState.charging) {
      return Remix.battery_charge_line;
    }

    if (_batteryLevel >= 95) return Remix.battery_fill;
    if (_batteryLevel >= 75) return Remix.battery_2_fill;
    if (_batteryLevel >= 50) return Remix.battery_2_line;
    if (_batteryLevel >= 25) return Remix.battery_low_line;
    return Remix.battery_low_fill;
  }
}