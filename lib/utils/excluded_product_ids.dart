// excluded_product_ids.dart

import 'package:firebase_remote_config/firebase_remote_config.dart';

List<int> excludedProductIds = [];
List<int> excludedCategoryIds = [];

Future<void> initializeExcludedProductIds() async {
  final remoteConfig = FirebaseRemoteConfig.instance;

  // Set the default value for excludedProductIds
  await remoteConfig.setDefaults(<String, dynamic>{
    'excludedProductIds': '', // Default value is an empty string
  });

  // Fetch the latest value for excludedProductIds
  await remoteConfig.fetchAndActivate();

  // Update excludedProductIds with the fetched value from Remote Config
  final excludedProductIdsFromRemoteConfig = remoteConfig.getString('excludedProductIds')
      .split(',')
      .map((id) => int.tryParse(id.trim()))
      .where((id) => id != null)
      .cast<int>()
      .toList();

  excludedProductIds = excludedProductIdsFromRemoteConfig;
  print('Excluded Product IDs: $excludedProductIds');
}
Future<void> initializeExcludedCategoryIds() async {
  final remoteConfig = FirebaseRemoteConfig.instance;

  // Set the default value for excludedCategoryIds
  await remoteConfig.setDefaults(<String, dynamic>{
    'excludedCategoryIds': '', // Default value is an empty string
  });

  // Fetch the latest value for excludedCategoryIds
  await remoteConfig.fetchAndActivate();

  // Update excludedCategoryIds with the fetched value from Remote Config
  final excludedCategoryIdsFromRemoteConfig = remoteConfig.getString('excludedCategoryIds')
      .split(',')
      .map((id) => int.tryParse(id.trim()))
      .where((id) => id != null)
      .cast<int>()
      .toList();

  excludedCategoryIds = excludedCategoryIdsFromRemoteConfig;
  print('Excluded Category IDs: $excludedCategoryIds');
}