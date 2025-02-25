import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../app_constants.dart';

final deliveryProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  try {
    final response = await http.get(Uri.parse('${AppConstants.baseUrl}/api/v1/rest/pages/delivery'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final translation = data['data']['translation'];
      return {
        'title': translation['title'],
        'description': translation['description'],
      };
    } else {
      throw Exception('Failed to fetch delivery data');
    }
  } catch (e) {
    // Handle network exceptions here
    if (e.toString().contains('SocketException')) {
      // Return null to indicate network error
      return null;
    } else {
      rethrow;
    }
  }
});