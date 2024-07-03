import 'dart:convert';

import 'package:riverpodtemp/game/models/board.dart';
import 'package:riverpodtemp/infrastructure/models/data/address_information.dart';
import 'package:riverpodtemp/infrastructure/models/data/address_old_data.dart';
import 'package:riverpodtemp/infrastructure/models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_constants.dart';

class LocalStorage {
  static SharedPreferences? _preferences;

  LocalStorage._();

  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future<void> setToken(String? token) async {
    if (_preferences != null) {
      await _preferences!.setString(AppConstants.keyToken, token ?? '');
    }
  }

  static String getToken() =>
      _preferences?.getString(AppConstants.keyToken) ?? '';

  static void deleteToken() => _preferences?.remove(AppConstants.keyToken);

  static Future<void> setUiType(int type) async {
    if (_preferences != null) {
      await _preferences!.setInt(AppConstants.keyUiType, type);
    }
  }

  static int? getUiType() => _preferences?.getInt(AppConstants.keyUiType);

  static Future<void> setLastName(String? image) async {
    if (_preferences != null) {
      await _preferences!.setString(AppConstants.keyLastName, image ?? "");
    }
  }

  static String getLastName() =>
      _preferences?.getString(AppConstants.keyLastName) ?? "";

  static void deleteLastName() =>
      _preferences?.remove(AppConstants.keyLastName);



  static Future<void> setPhone(String? phone) async {
    if (_preferences != null) {
      await _preferences!.setString(AppConstants.keyPhone, phone ?? "");
    }
  }

  static String? getPhone() =>
      _preferences?.getString(AppConstants.keyPhone);

  static void deletePhone() =>
      _preferences?.remove(AppConstants.keyPhone);

  static Future<void> setFirstName(String? image) async {
    if (_preferences != null) {
      await _preferences!.setString(AppConstants.keyFirstName, image ?? "");
    }
  }

  static String getFirstName() =>
      _preferences?.getString(AppConstants.keyFirstName) ?? "";

  static void deleteFirstName() =>
      _preferences?.remove(AppConstants.keyFirstName);

  static Future<void> setUserId(int? image) async {
    if (_preferences != null) {
      await _preferences!.setInt(AppConstants.keyUserId, image ?? 0);
    }
  }

  static int getUserId() => _preferences?.getInt(AppConstants.keyUserId) ?? 0;

  static void deleteUserId() => _preferences?.remove(AppConstants.keyUserId);

  static Future<void> setProfileImage(String? image) async {
    if (_preferences != null) {
      await _preferences!.setString(AppConstants.keyUserImage, image ?? '');
    }
  }

  static String getProfileImage() =>
      _preferences?.getString(AppConstants.keyUserImage) ?? '';

  static void deleteProfileImage() =>
      _preferences?.remove(AppConstants.keyUserImage);

  static Future<void> setSearchHistory(List<String> list) async {
    if (_preferences != null) {
      final List<String> idsStrings = list.map((e) => e.toString()).toList();
      await _preferences!
          .setStringList(AppConstants.keySearchStores, idsStrings);
    }
  }

  static List<String> getSearchList() {
    final List<String> strings =
        _preferences?.getStringList(AppConstants.keySearchStores) ?? [];
    return strings;
  }

  static void deleteSearchList() =>
      _preferences?.remove(AppConstants.keySearchStores);

  static Future<void> setSavedShopsList(List<int> ids) async {
    if (_preferences != null) {
      final List<String> idsStrings = ids.map((e) => e.toString()).toList();
      await _preferences!
          .setStringList(AppConstants.keySavedStores, idsStrings);
    }
  }

  static List<int> getSavedShopsList() {
    final List<String> strings =
        _preferences?.getStringList(AppConstants.keySavedStores) ?? [];
    if (strings.isNotEmpty) {
      final List<int> ids = strings.map((e) => int.parse(e)).toList();
      return ids;
    } else {
      return [];
    }
  }

  static void deleteSavedShopsList() =>
      _preferences?.remove(AppConstants.keySavedStores);

  static Future<void> setAddressSelected(AddressData data) async {
    if (_preferences != null) {
      await _preferences!.setString(
          AppConstants.keyAddressSelected, jsonEncode(data.toJson()));
    }
  }

  static AddressData? getAddressSelected() {
    String dataString =
        _preferences?.getString(AppConstants.keyAddressSelected) ?? "";
    if (dataString.isNotEmpty) {
      AddressData data = AddressData.fromJson(jsonDecode(dataString));
      return data;
    } else {
      return null;
    }
  }

  static void deleteAddressSelected() =>
      _preferences?.remove(AppConstants.keyAddressSelected);

  static Future<void> setAddressInformation(AddressInformation data) async {
    if (_preferences != null) {
      await _preferences!.setString(
          AppConstants.keyAddressInformation, jsonEncode(data.toJson()));
    }
  }

  static AddressInformation? getAddressInformation() {
    String dataString =
        _preferences?.getString(AppConstants.keyAddressInformation) ?? "";
    if (dataString.isNotEmpty) {
      AddressInformation data =
          AddressInformation.fromJson(jsonDecode(dataString));
      return data;
    } else {
      return null;
    }
  }

  static void deleteAddressInformation() =>
      _preferences?.remove(AppConstants.keyAddressInformation);

  static Future<void> setLanguageSelected(bool selected) async {
    if (_preferences != null) {
      await _preferences!.setBool(AppConstants.keyLangSelected, selected);
    }
  }

  static bool getLanguageSelected() =>
      _preferences?.getBool(AppConstants.keyLangSelected) ?? false;

  static void deleteLangSelected() =>
      _preferences?.remove(AppConstants.keyLangSelected);

  static Future<void> setSelectedCurrency(CurrencyData currency) async {
    if (_preferences != null) {
      final String currencyString = jsonEncode(currency.toJson());
      await _preferences!
          .setString(AppConstants.keySelectedCurrency, currencyString);
    }
  }

  static CurrencyData? getSelectedCurrency() {
    String json =
        _preferences?.getString(AppConstants.keySelectedCurrency) ?? '';
    if (json.isEmpty) {
      return null;
    } else {
      final map = jsonDecode(json);
      return CurrencyData.fromJson(map);
    }
  }

  static void deleteSelectedCurrency() =>
      _preferences?.remove(AppConstants.keySelectedCurrency);

  static Future<void> setWalletData(Wallet? wallet) async {
    if (_preferences != null) {
      final String walletString = jsonEncode(wallet?.toJson());
      await _preferences!.setString(AppConstants.keyWalletData, walletString);
    }
  }

  static Wallet? getWalletData() {
    final wallet = _preferences?.getString(AppConstants.keyWalletData);
    if (wallet == null) {
      return null;
    }
    final map = jsonDecode(wallet);
    if (map == null) {
      return null;
    }
    return Wallet.fromJson(map);
  }

  static void deleteWalletData() =>
      _preferences?.remove(AppConstants.keyWalletData);

  static Future<void> setSettingsList(List<SettingsData> settings) async {
    if (_preferences != null) {
      final List<String> strings =
          settings.map((setting) => jsonEncode(setting.toJson())).toList();
      await _preferences!
          .setStringList(AppConstants.keyGlobalSettings, strings);
    }
  }

  static List<SettingsData> getSettingsList() {
    final List<String> settings =
        _preferences?.getStringList(AppConstants.keyGlobalSettings) ?? [];
    final List<SettingsData> settingsList = settings
        .map(
          (setting) => SettingsData.fromJson(jsonDecode(setting)),
        )
        .toList();
    return settingsList;
  }

  static void deleteSettingsList() =>
      _preferences?.remove(AppConstants.keyGlobalSettings);

  static Future<void> setTranslations(
      Map<String, dynamic>? translations) async {
    if (_preferences != null) {
      final String encoded = jsonEncode(translations);
      await _preferences!.setString(AppConstants.keyTranslations, encoded);
    }
  }

  static Map<String, dynamic> getTranslations() {
    final String encoded =
        _preferences?.getString(AppConstants.keyTranslations) ?? '';
    if (encoded.isEmpty) {
      return {};
    }
    final Map<String, dynamic> decoded = jsonDecode(encoded);
    return decoded;
  }

  static void deleteTranslations() =>
      _preferences?.remove(AppConstants.keyTranslations);

  static Future<void> setAppThemeMode(bool isDarkMode) async {
    if (_preferences != null) {
      await _preferences!.setBool(AppConstants.keyAppThemeMode, isDarkMode);
    }
  }

  static bool getAppThemeMode() =>
      _preferences?.getBool(AppConstants.keyAppThemeMode) ?? false;

  static void deleteAppThemeMode() =>
      _preferences?.remove(AppConstants.keyAppThemeMode);

  static Future<void> setSettingsFetched(bool fetched) async {
    if (_preferences != null) {
      await _preferences!.setBool(AppConstants.keySettingsFetched, fetched);
    }
  }

  static bool getSettingsFetched() =>
      _preferences?.getBool(AppConstants.keySettingsFetched) ?? false;

  static void deleteSettingsFetched() =>
      _preferences?.remove(AppConstants.keySettingsFetched);

  static Future<void> setLanguageData(LanguageData? langData) async {
    if (_preferences != null) {
      final String lang = jsonEncode(langData?.toJson());
      await _preferences!.setString(AppConstants.keyLanguageData, lang);
    }
  }

  static LanguageData? getLanguage() {
    final lang = _preferences?.getString(AppConstants.keyLanguageData);
    if (lang == null) {
      return null;
    }
    final map = jsonDecode(lang);
    if (map == null) {
      return null;
    }
    return LanguageData.fromJson(map);
  }

  static void deleteLanguage() =>
      _preferences?.remove(AppConstants.keyLanguageData);

  static Future<void> setLangLtr(bool? backward) async {
    if (_preferences != null) {
      await _preferences!.setBool(AppConstants.keyLangLtr, (backward ?? false));
    }
  }

  static bool getLangLtr() =>
      !(_preferences?.getBool(AppConstants.keyLangLtr) ?? false);

  static void deleteLangLtr() => _preferences?.remove(AppConstants.keyLangLtr);

  static Future<void> setBoard(Board? board) async {
    if (_preferences != null) {
      await _preferences?.setString(AppConstants.keyBoard, jsonEncode(board?.toJson()));
    }
  }

  static Board? getBoard() {
    Map jsonData = {};
    if (_preferences?.getString(AppConstants.keyBoard) != null) {
      jsonData = jsonDecode(_preferences?.getString(AppConstants.keyBoard) ?? "");
    }

    if (jsonData.isNotEmpty) {
      Board board = Board.fromJson(jsonData);
      return board;
    }

    return null;
  }

  static deleteBoard() {
    return _preferences?.remove(AppConstants.keyBoard);
  }

  static void logout() {
    deleteWalletData();
    deleteSavedShopsList();
    deleteSearchList();
    deleteProfileImage();
    deleteUserId();
    deleteFirstName();
    deleteLastName();
    deleteToken();
    deletePhone();
    deleteAddressSelected();
    deleteAddressInformation();
    deleteBoard();
  }
}
