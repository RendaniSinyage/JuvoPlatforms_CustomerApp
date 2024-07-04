import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpodtemp/infrastructure/services/app_constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final aboutProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  try {
    final response = await http.get(Uri.parse('${AppConstants.baseUrl}/api/v1/rest/pages/about'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final translation = data['data']['translation'];
      
      // Include the image URL in the returned data
      final imgUrl = data['data']['img'] != null ? data['data']['img'] : null;


      return {
        'title': translation['title'],
        'description': translation['description'],
        'img': imgUrl, // Include the image URL
      };
    } else {
      throw Exception('Failed to fetch about data');
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
