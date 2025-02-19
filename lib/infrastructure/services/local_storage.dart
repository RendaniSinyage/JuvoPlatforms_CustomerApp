import 'dart:convert';
import 'package:foodyman/game/models/board.dart';
import 'package:foodyman/infrastructure/models/data/address_information.dart';
import 'package:foodyman/infrastructure/models/data/address_old_data.dart';
import 'package:foodyman/infrastructure/models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'storage_keys.dart';

abstract class LocalStorage {
  LocalStorage._();
  static SharedPreferences? _preferences;

  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future<void> setToken(String? token) async {
    await _preferences?.setString(StorageKeys.keyToken, token ?? '');
  }

  static String getToken() =>
      _preferences?.getString(StorageKeys.keyToken) ?? '';

  static void deleteToken() => _preferences?.remove(StorageKeys.keyToken);

  static Future<void> setUiType(int type) async {
    await _preferences?.setInt(StorageKeys.keyUiType, type);
  }

  static int? getUiType() => _preferences?.getInt(StorageKeys.keyUiType);

  static Future<void> setUser(ProfileData? user) async {
    if (_preferences != null) {
      final String userString = user != null ? jsonEncode(user.toJson()) : '';
      await _preferences!.setString(StorageKeys.keyUser, userString);
    }
  }

  static ProfileData? getUser() {
    final savedString = _preferences?.getString(StorageKeys.keyUser);
    if (savedString == null) {
      return null;
    }
    final map = jsonDecode(savedString);
    if (map == null) {
      return null;
    }
    return ProfileData.fromJson(map);
  }

  static void _deleteUser() => _preferences?.remove(StorageKeys.keyUser);

  static Future<void> setSearchHistory(List<String> list) async {
    final List<String> idsStrings = list.map((e) => e.toString()).toList();
    await _preferences?.setStringList(StorageKeys.keySearchStores, idsStrings);
  }

  static List<String> getSearchList() {
    final List<String> strings =
        _preferences?.getStringList(StorageKeys.keySearchStores) ?? [];
    return strings;
  }

  static void deleteSearchList() =>
      _preferences?.remove(StorageKeys.keySearchStores);

  static Future<void> setSavedShopsList(List<int> ids) async {
    final List<String> idsStrings = ids.map((e) => e.toString()).toList();
    await _preferences?.setStringList(StorageKeys.keySavedStores, idsStrings);
  }

  static List<int> getSavedShopsList() {
    final List<String> strings =
        _preferences?.getStringList(StorageKeys.keySavedStores) ?? [];
    if (strings.isNotEmpty) {
      final List<int> ids = strings.map((e) => int.parse(e)).toList();
      return ids;
    } else {
      return [];
    }
  }

  static void deleteSavedShopsList() =>
      _preferences?.remove(StorageKeys.keySavedStores);

  static Future<void> setAddressSelected(AddressData data) async {
    await _preferences?.setString(
        StorageKeys.keyAddressSelected, jsonEncode(data.toJson()));
  }

  static AddressData? getAddressSelected() {
    String dataString =
        _preferences?.getString(StorageKeys.keyAddressSelected) ?? "";
    if (dataString.isNotEmpty) {
      AddressData data = AddressData.fromJson(jsonDecode(dataString));
      return data;
    } else {
      return null;
    }
  }

  static void deleteAddressSelected() =>
      _preferences?.remove(StorageKeys.keyAddressSelected);

  static Future<void> setAddressInformation(AddressInformation data) async {
    await _preferences?.setString(
        StorageKeys.keyAddressInformation, jsonEncode(data.toJson()));
  }

  static AddressInformation? getAddressInformation() {
    String dataString =
        _preferences?.getString(StorageKeys.keyAddressInformation) ?? "";
    if (dataString.isNotEmpty) {
      AddressInformation data =
          AddressInformation.fromJson(jsonDecode(dataString));
      return data;
    } else {
      return null;
    }
  }

  static void deleteAddressInformation() =>
      _preferences?.remove(StorageKeys.keyAddressInformation);

  static Future<void> setLanguageSelected(bool selected) async {
    await _preferences?.setBool(StorageKeys.keyLangSelected, selected);
  }

  static bool getLanguageSelected() =>
      _preferences?.getBool(StorageKeys.keyLangSelected) ?? false;

  static void deleteLangSelected() =>
      _preferences?.remove(StorageKeys.keyLangSelected);

  static Future<void> setSelectedCurrency(CurrencyData currency) async {
    final String currencyString = jsonEncode(currency.toJson());
    await _preferences?.setString(
        StorageKeys.keySelectedCurrency, currencyString);
  }

  static CurrencyData? getSelectedCurrency() {
    String json =
        _preferences?.getString(StorageKeys.keySelectedCurrency) ?? '';
    if (json.isEmpty) {
      return null;
    } else {
      final map = jsonDecode(json);
      return CurrencyData.fromJson(map);
    }
  }

  static void deleteSelectedCurrency() =>
      _preferences?.remove(StorageKeys.keySelectedCurrency);

  static Future<void> setWalletData(Wallet? wallet) async {
    final String walletString = jsonEncode(wallet?.toJson());
    await _preferences?.setString(StorageKeys.keyWalletData, walletString);
  }

  static Wallet? getWalletData() {
    final wallet = _preferences?.getString(StorageKeys.keyWalletData);
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
      _preferences?.remove(StorageKeys.keyWalletData);

  static Future<void> setSettingsList(List<SettingsData> settings) async {
    final List<String> strings =
        settings.map((setting) => jsonEncode(setting.toJson())).toList();
    await _preferences?.setStringList(StorageKeys.keyGlobalSettings, strings);
  }

  static List<SettingsData> getSettingsList() {
    final List<String> settings =
        _preferences?.getStringList(StorageKeys.keyGlobalSettings) ?? [];
    final List<SettingsData> settingsList = settings
        .map(
          (setting) => SettingsData.fromJson(jsonDecode(setting)),
        )
        .toList();
    return settingsList;
  }

  static void deleteSettingsList() =>
      _preferences?.remove(StorageKeys.keyGlobalSettings);

  static Future<void> setTranslations(
      Map<String, dynamic>? translations) async {
    final String encoded = jsonEncode(translations);
    await _preferences?.setString(StorageKeys.keyTranslations, encoded);
  }

  static Map<String, dynamic> getTranslations() {
    final String encoded =
        _preferences?.getString(StorageKeys.keyTranslations) ?? '';
    if (encoded.isEmpty) {
      return {};
    }
    final Map<String, dynamic> decoded = jsonDecode(encoded);
    return decoded;
  }

  static void deleteTranslations() =>
      _preferences?.remove(StorageKeys.keyTranslations);

  static Future<void> setAppThemeMode(bool isDarkMode) async {
    await _preferences?.setBool(StorageKeys.keyAppThemeMode, isDarkMode);
  }

  static bool getAppThemeMode() =>
      _preferences?.getBool(StorageKeys.keyAppThemeMode) ?? false;

  static void deleteAppThemeMode() =>
      _preferences?.remove(StorageKeys.keyAppThemeMode);

  static Future<void> setSettingsFetched(bool fetched) async {
    await _preferences?.setBool(StorageKeys.keySettingsFetched, fetched);
  }

  static bool getSettingsFetched() =>
      _preferences?.getBool(StorageKeys.keySettingsFetched) ?? false;

  static void deleteSettingsFetched() =>
      _preferences?.remove(StorageKeys.keySettingsFetched);

  static Future<void> setLanguageData(LanguageData? langData) async {
    final String lang = jsonEncode(langData?.toJson());
    await _preferences?.setString(StorageKeys.keyLanguageData, lang);
  }

  static LanguageData? getLanguage() {
    final lang = _preferences?.getString(StorageKeys.keyLanguageData);
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
      _preferences?.remove(StorageKeys.keyLanguageData);

  static Future<void> setLangLtr(bool? backward) async {
    await _preferences?.setBool(StorageKeys.keyLangLtr, (backward ?? false));
  }

  static bool getLangLtr() =>
      !(_preferences?.getBool(StorageKeys.keyLangLtr) ?? false);

  static void deleteLangLtr() => _preferences?.remove(StorageKeys.keyLangLtr);

  static Future<void> setBoard(Board? board) async {
    await _preferences?.setString(
        StorageKeys.keyBoard, jsonEncode(board?.toJson()));
  }

  static Board? getBoard() {
    Map jsonData = {};
    if (_preferences?.getString(StorageKeys.keyBoard) != null) {
      jsonData =
          jsonDecode(_preferences?.getString(StorageKeys.keyBoard) ?? "");
    }

    if (jsonData.isNotEmpty) {
      Board board = Board.fromJson(jsonData);
      return board;
    }

    return null;
  }

  static deleteBoard() {
    return _preferences?.remove(StorageKeys.keyBoard);
  }

  static void logout() {
    deleteWalletData();
    deleteSavedShopsList();
    deleteSearchList();
    _deleteUser();
    deleteToken();
    deleteAddressSelected();
    deleteAddressInformation();
    deleteBoard();
  }
}
