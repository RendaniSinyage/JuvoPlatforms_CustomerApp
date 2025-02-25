import 'package:foodyman/infrastructure/services/tr_keys.dart';

import 'infrastructure/services/enums.dart';

abstract class AppConstants {
  AppConstants._();

  /// api urls
  static String baseUrl = '';
  static String drawingBaseUrl = 'https://api.openrouteservice.org';
  static String googleApiKey = 'AIzaSyDJjLCq6HBCe7xae6l0D9DW1MWpE4900GU';
  static String adminPageUrl = '';
  static String webUrl = '';
  static String firebaseWebKey = '';
  static String uriPrefix = 'https://foodyman.page.link';
  static String routingKey =
      '5b3ce3597851110001cf62480384c1db92764d1b8959761ea2510ac8';
  static String androidPackageName = 'com.foodyman';
  static String iosPackageName = 'com.foodyman.customer';
  static bool isDemo = false;
  static bool isPhoneFirebase = true;
  static int scheduleInterval = 60;
  static SignUpType signUpType = SignUpType.phone;
  static bool use24Format = true;

///newStores and Recommendation Time
  static int newShopDays = 60;

  ///Operating time
  static String isOpen = '6am';
  static String isClosed = '10pm';
  static bool isMaintain = false;

  ///Google Maps POI
  static bool showGooglePOILayer = true;

 /// hero tags
  static const String heroTagSelectUser = 'heroTagSelectUser';
  static const String heroTagSelectAddress = 'heroTagSelectAddress';
  static const String heroTagSelectCurrency = 'heroTagSelectCurrency';


  /// PayFast
  static String passphrase = 'Sgosouthbwi1';
  static String merchantId = '12035225';
  static String merchantKey = 'j5gtf8n3jvxo3';


  static const String demoUserLogin = 'user@githubit.com';
  static const String demoUserPassword = 'githubit';

  /// locales
  static String localeCodeEn = 'en';

  /// auth phone fields
  static const bool isNumberLengthAlwaysSame = true;
  static const String countryCodeISO = 'ZA';
  static const bool showFlag = true;
  static const bool showArrowIcon = true;

  /// location
  static double demoLatitude = 41.304223;
  static double demoLongitude = 69.2348277;
  static double pinLoadingMin = 0.116666667;
  static double pinLoadingMax = 0.611111111;

  static const Duration timeRefresh = Duration(seconds: 30);

  static const List infoImage = [
    "assets/images/save.png",
    "assets/images/delivery.png",
    "assets/images/fast.png",
    "assets/images/set.png",
  ];

  static const List infoTitle = [
    TrKeys.saveTime,
    TrKeys.deliveryRestriction,
    TrKeys.fast,
    TrKeys.set,
  ];

  static const payLater = [
    "progress",
    "canceled",
    "rejected",
  ];
  static const genderList = [
    "male",
    "female",
  ];

  static bool fixed = true;

  static bool cardDirect = false;
}


