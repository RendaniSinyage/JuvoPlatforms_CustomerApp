// lib/infrastructure/services/app_usage_service.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:foodyman/infrastructure/services/local_storage.dart';
import 'package:foodyman/app_constants.dart';

class AppUsageService {
  static Future<Map<String, dynamic>> recordAppUsage() async {
    try {
      // Check if user is logged in
      final token = LocalStorage.getToken();
      if (token.isEmpty) {
        debugPrint('AppUsageService: Not recording - user is not logged in');
        return {'days_in_app_this_year': 0};
      }

      // Check if we already recorded today
      final prefs = await SharedPreferences.getInstance();
      final String? lastRecorded = prefs.getString('last_usage_recorded');
      final today = DateTime.now().toIso8601String().split('T')[0];

      // Only record once per day
      if (lastRecorded != today) {
        // Get app version info
        final packageInfo = await PackageInfo.fromPlatform();
        final appVersion = packageInfo.version;
        final buildNumber = packageInfo.buildNumber;

        debugPrint('AppUsageService: Recording app usage for today: $today');
        final response = await http.post(
          Uri.parse('${AppConstants.baseUrl}/api/v1/rest/app-usage/record'),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'platform': Platform.isAndroid ? 'Android' : 'iOS',
            'app_version': appVersion,
            'build_number': buildNumber,
          }),
        );

        if (response.statusCode == 200) {
          // Save that we've recorded today
          await prefs.setString('last_usage_recorded', today);
          final responseData = jsonDecode(response.body);

          // Cache the stats
          await _cacheStats(responseData['data'] ?? {'days_in_app_this_year': 0});

          debugPrint('AppUsageService: Successfully recorded - days in app: ${responseData['data']?['days_in_app_this_year']}');
          return responseData['data'] ?? {'days_in_app_this_year': 0};
        } else {
          debugPrint('AppUsageService: Failed to record - status code: ${response.statusCode}');
          // Try to get cached stats if the request fails
          return await _getCachedStats();
        }
      } else {
        debugPrint('AppUsageService: Already recorded today, fetching stats');
        // If already recorded today, just get stats
        return await getAppUsageStats();
      }
    } catch (e) {
      debugPrint('AppUsageService: Error recording app usage: $e');
      return await _getCachedStats();
    }
  }

  // Get app usage statistics from API
  static Future<Map<String, dynamic>> getAppUsageStats() async {
    try {
      final token = LocalStorage.getToken();

      if (token.isEmpty) {
        return {'days_in_app_this_year': 0}; // Not logged in
      }

      final response = await http.get(
        Uri.parse('${AppConstants.baseUrl}/api/v1/rest/app-usage/stats'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final stats = responseData['data'] ?? {'days_in_app_this_year': 0};

        // Cache the stats
        await _cacheStats(stats);

        return stats;
      } else {
        return await _getCachedStats();
      }
    } catch (e) {
      debugPrint('AppUsageService: Error getting app usage stats: $e');
      return await _getCachedStats();
    }
  }

  // Cache stats locally for offline use
  static Future<void> _cacheStats(Map<String, dynamic> stats) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('app_usage_stats', jsonEncode(stats));
  }

  // Get cached stats when offline
  static Future<Map<String, dynamic>> _getCachedStats() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getString('app_usage_stats');

    if (cachedData != null) {
      try {
        return jsonDecode(cachedData);
      } catch (e) {
        return {'days_in_app_this_year': 0};
      }
    }

    return {'days_in_app_this_year': 0};
  }
}