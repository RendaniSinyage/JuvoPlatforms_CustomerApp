import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app_constants.dart';
import '../application/poidata/poi_data_provider.dart';
import '../infrastructure/models/data/poi_data.dart';
//import 'package:foodyman/utils/excluded_product_ids.dart';

class AppInitializer extends StatefulWidget {
  final ProviderContainer providerContainer;
  //final List<int> excludedProductIds = [];
  //final List<int> excludedCategoryIds = [];

  const AppInitializer({super.key, required this.providerContainer});

  Future<void> initializeApp() async {
    await initializeRemoteConfigWithoutAPICall();
    await checkAppStatusFromAPI();
    // Add other app initialization tasks here
  }

  Future<void> initializeRemoteConfigWithoutAPICall() async {
    final initializer = _AppInitializerState(providerContainer);
    await initializer._initializeRemoteConfigWithoutAPICall();
  }

  Future<void> checkAppStatusFromAPI() async {
    final initializer = _AppInitializerState(providerContainer);
    await initializer._checkAppStatusFromAPI();
  }

  @override
  _AppInitializerState createState() => _AppInitializerState(providerContainer);
}

class _AppInitializerState extends State<AppInitializer> {
  final ProviderContainer providerContainer;

  _AppInitializerState(this.providerContainer);

  @override
  void initState() {
    super.initState();
    // You can perform additional setup here if needed
  }

  Future<void> _initializeRemoteConfigWithoutAPICall() async {
    final remoteConfig = FirebaseRemoteConfig.instance;

    // Set minimum fetch interval to 0 to force fetch on every app start
    RemoteConfigSettings remoteConfigSettings = RemoteConfigSettings(
      minimumFetchInterval: Duration.zero, // Provide minimumFetchInterval explicitly
      fetchTimeout: const Duration(seconds: 10), // Set a reasonable timeout
    );
    await remoteConfig.setConfigSettings(remoteConfigSettings);

    // Fetch the latest values with a shorter expiration time
    await remoteConfig.fetchAndActivate();

    // Update other AppConstants with values from Remote Config
    AppConstants.drawingBaseUrl = remoteConfig.getString('drawingBaseUrl');
    AppConstants.baseUrl = remoteConfig.getString('baseUrl');
    //AppConstants.privacyPolicyUrl = remoteConfig.getString('privacyPolicyUrl');
    AppConstants.androidPackageName = remoteConfig.getString('androidPackageName');
    AppConstants.iosPackageName = remoteConfig.getString('iosPackageName');
    AppConstants.isDemo = remoteConfig.getBool('isDemo');
    AppConstants.adminPageUrl = remoteConfig.getString('adminPageUrl');
    AppConstants.routingKey = remoteConfig.getString('routingKey');
    AppConstants.googleApiKey = remoteConfig.getString('googleApiKey');
    AppConstants.firebaseWebKey = remoteConfig.getString('firebaseWebKey');
    AppConstants.uriPrefix = remoteConfig.getString('uriPrefix');
    AppConstants.isOpen = remoteConfig.getString('isOpen');
    AppConstants.isClosed = remoteConfig.getString('isClosed');
    AppConstants.showGooglePOILayer = remoteConfig.getBool('showGooglePOILayer');
    AppConstants.localeCodeEn = remoteConfig.getString('localeCodeEn');
    //AppConstants.chatGpt = remoteConfig.getString('chatGpt');
    AppConstants.demoLatitude = double.parse(remoteConfig.getString('demoLatitude'));
    AppConstants.demoLongitude = double.parse(remoteConfig.getString('demoLongitude'));
    AppConstants.pinLoadingMin = double.parse(remoteConfig.getString('pinLoadingMin'));
    AppConstants.pinLoadingMax = double.parse(remoteConfig.getString('pinLoadingMax'));
    AppConstants.newShopDays = remoteConfig.getInt('newShopDays');
    AppConstants.cardDirect = remoteConfig.getBool('cardDirect');

    ///Payfast
    //AppConstants.passphrase = remoteConfig.getString('payfast_passphrase');
    //AppConstants.merchantId = remoteConfig.getString('payfast_merchant_id');
    //AppConstants.merchantKey = remoteConfig.getString('payfast_merchant_key');


   /* try {
      // Set the default value for excludedProductIds
      await remoteConfig.setDefaults(<String, dynamic>{
        'excludedProductIds': '', // Default value is an empty string
      });

      // Fetch the latest value for excludedProductIds
      await remoteConfig.fetchAndActivate();

      // Update excludedProductIds with the fetched value from Remote Config
      final excludedProductIdsFromRemoteConfig = remoteConfig
          .getString('excludedProductIds')
          .split(',')
          .map((id) => int.tryParse(id.trim()) ?? 0) // Handle null values
          .where((id) => id != 0) // Filter out 0 values
          .cast<int>()
          .toList();

      excludedProductIds = excludedProductIdsFromRemoteConfig;
      if (kDebugMode) {
        print('Excluded Product IDs: $excludedProductIds');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing excluded product IDs: $e');
      }
      // Handle the exception here, e.g., set a default value for excludedProductIds
    } */

   /* try {
      // Set the default value for excludedCategoryIds
      await remoteConfig.setDefaults(<String, dynamic>{
        'excludedCategoryIds': '', // Default value is an empty string
      });

      // Fetch the latest value for excludedCategoryIds
      await remoteConfig.fetchAndActivate();

      // Update excludedCategoryIds with the fetched value from Remote Config
      final excludedCategoryIdsFromRemoteConfig = remoteConfig
          .getString('excludedCategoryIds')
          .split(',')
          .map((id) => int.tryParse(id.trim()) ?? 0) // Handle null values
          .where((id) => id != 0) // Filter out 0 values
          .cast<int>()
          .toList();

      excludedCategoryIds = excludedCategoryIdsFromRemoteConfig;
      if (kDebugMode) {
        print('Excluded Category IDs: $excludedCategoryIds');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing excluded Category IDs: $e');
      }
      // Handle the exception here, e.g., set a default value for excludedCategoryIds
    }*/

    try {
      // Fetch and process the poiData parameter
      Map<String, RemoteConfigValue> remoteConfigData = remoteConfig.getAll();
      RemoteConfigValue? poiDataValue = remoteConfigData['poiData'];

      if (poiDataValue != null) {
        String? poiDataString = poiDataValue.asString();

        List<dynamic> poiDataJson = jsonDecode(poiDataString);

        if (kDebugMode) {
          print("poiDataJson: $poiDataJson");
        } // Debug print to check poiDataJson

        List<POIData> poiDataList = [];
        for (var poiDataMap in poiDataJson) {
          poiDataList.add(
            POIData(
              name: poiDataMap['name'],
              latitude: poiDataMap['latitude'].toDouble(),
              longitude: poiDataMap['longitude'].toDouble(),
              titleColor: Color(int.parse(poiDataMap['titleColor'].substring(2), radix: 16) + 0xFF000000),
              pin: poiDataMap['pin'],
            ),
          );
        }
        if (kDebugMode) {
          print("poiDataList: $poiDataList");
        } // Debug print to check poiDataList

        // Update the poiDataProvider with the new data
        providerContainer.read(poiDataProvider.notifier).updatePOIData(poiDataList);
            } else {
        if (kDebugMode) {
          print("poiData is null");
        }
        // Handle the case where poiData is null
        throw Exception("poiData is null");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error processing poiData: $e");
      }
    }

    // Check if other configurations have expired
    final expireAfter = remoteConfigSettings.minimumFetchInterval;
    final lastFetchTime = remoteConfig.lastFetchTime;
    final currentTime = DateTime.now();

    if (currentTime.difference(lastFetchTime) > expireAfter) {
      // Fetch other values with the default expiration time (12 hours)
      await remoteConfig.fetchAndActivate();
    }
  }
  Future<void> _checkAppStatusFromAPI() async {
    // Check the app status from the API with a 5-second timeout
    try {
      final response = await http
          .get(Uri.parse('${AppConstants.baseUrl}/public/api/v1/rest/status'))
          .timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        AppConstants.isMaintain = data['status'] != 'OK';
      } else {
        AppConstants.isMaintain = true; // Set isMaintain to true if API response is not successful
      }
    } on TimeoutException {
      AppConstants.isMaintain = true; // Set isMaintain to true if the API call times out
    } catch (e) {
      AppConstants.isMaintain = true; // Set isMaintain to true if an exception occurs
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(); // No UI needed here
  }
}
