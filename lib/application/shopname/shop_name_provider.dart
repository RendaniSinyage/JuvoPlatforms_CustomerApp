import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:foodyman/infrastructure/models/data/product_data.dart';

import '../../app_constants.dart';

final shopNameProvider = FutureProvider.family<String, String>((ref, shopId) async {
  final response = await http.get(Uri.parse('${AppConstants.baseUrl}/api/v1/rest/shops?shops[0]=$shopId'));

  if (response.statusCode == 200) {
    final responseData = jsonDecode(response.body);
    final shopTranslation = responseData['data'][0]['translation']['title'];
    return shopTranslation;
  } else {
    throw Exception('Failed to load shop details');
  }
});
