//import 'package:flutter/material.dart';
//import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:riverpodtemp/infrastructure/services/tr_keys.dart';

class AppConstants {
  AppConstants._();

  /// shared preferences keys
  static const String keyLangSelected = 'keyLangSelected';
  static const String keyUserId = 'keyUserId';
  static const String keyUserImage = 'keyUser';
  static const String keyToken = 'keyToken';
  static const String keyUiType = 'keyUiType';
  static const String keyLocaleCode = 'keyLocaleCode';
  static const String keyFirstName = 'keyFirstName';
  static const String keyLastName = 'keyLastName';
  static const String keyPhone = 'keyPhone';
  static const String keyBoard = 'keyBoard';
  static const String keyProfileImage = 'keyProfileImage';
  static const String keySavedStores = 'keySavedStores';
  static const String keySearchStores = 'keySearchStores';
  static const String keyViewedProducts = 'keyViewedProducts';
  static const String keyAddressSelected = 'keyAddressSelected';
  static const String keyAddressInformation = 'keyAddressInformation';
  static const String keyIsGuest = 'keyIsGuest';
  static const String keyLocalAddresses = 'keyLocalAddresses';
  static const String keyActiveAddressTitle = 'keyActiveAddressTitle';
  static const String keyLikedProducts = 'keyLikedProducts';
  static const String keySelectedCurrency = 'keySelectedCurrency';
  static const String keyCartProducts = 'keyCartProducts';
  static const String keyAppThemeMode = 'keyAppThemeMode';
  static const String keyWalletData = 'keyWalletData';
  static const String keyGlobalSettings = 'keyGlobalSettings';
  static const String keySettingsFetched = 'keySettingsFetched';
  static const String keyTranslations = 'keyTranslations';
  static const String keyLanguageData = 'keyLanguageData';
  static const String keyAuthenticatedWithSocial = 'keyAuthenticatedWithSocial';
  static const String keyLangLtr = 'keyLangLtr';

  /// hero tags
  static const String heroTagSelectUser = 'heroTagSelectUser';
  static const String heroTagSelectAddress = 'heroTagSelectAddress';
  static const String heroTagSelectCurrency = 'heroTagSelectCurrency';


  /// auth phone fields
  static const bool isSpecificNumberEnabled = false;
  static const bool isNumberLengthAlwaysSame = true;
  static const String countryCodeISO = 'UZ';
  static const bool showFlag = true;
  static const bool showArrowIcon = true;



  /// app strings
  static const String emptyString = '';

  /// api urls
  static String drawingBaseUrl = 'https://api.openrouteservice.org';
  static String baseUrl = 'https://api.juvo.app';
  static String googleApiKey = 'AIzaSyDJjLCq6HBCe7xae6l0D9DW1MWpE4900GU';
  static String privacyPolicyUrl = '$baseUrl/privacy-policy';
  static String adminPageUrl = 'https://admin.juvo.app';
  static const String webUrl = 'https://food.juvo.app';
  static const String firebaseWebKey = 'AIzaSyACbWuYUg7UmWtuPODxAsuox5kOP0Ev1Tk';
  static String uriPrefix = 'https://juvo.page.link';
  static String routingKey = '5b3ce3597851110001cf62480384c1db92764d1b8959761ea2510ac8';
  static String androidPackageName = 'app.juvo.food';
  static String iosPackageName = 'app.juvo.food';
  static bool isDemo = false;

  ///Operating time
  static String isOpen = '6am';
  static String isClosed = '10pm';
  static bool isMaintain = false;

  ///Google Maps POI
  static bool showGooglePOILayer = true;

  /// locales
  static String localeCodeEn = 'en';
  static String chatGpt = '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';

  /// location
  static double demoLatitude = -22.34058;
  static double demoLongitude = 30.01341;
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
}

enum ShopStatus { notRequested, newShop, edited, approved, rejected }

enum UploadType {
  extras,
  brands,
  categories,
  shopsLogo,
  shopsBack,
  products,
  reviews,
  users,
}

enum PriceFilter { byLow, byHigh }

enum ListAlignment { singleBig, vertically, horizontally }

enum ExtrasType { color, text, image }

enum DeliveryTypeEnum { delivery, pickup }

enum ShippingDeliveryVisibilityType {
  cantOrder,
  onlyDelivery,
  onlyPickup,
  both,
}

enum OrderStatus { open, accepted, ready, onWay, delivered, canceled }

enum CouponType { fix, percent }

enum MessageOwner { you, partner }

enum BannerType { banner, look }

enum LookProductStockStatus { outOfStock, alreadyAdded, notAdded }
