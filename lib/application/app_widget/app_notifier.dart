import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpodtemp/infrastructure/models/models.dart';

import '../../infrastructure/services/local_storage.dart';
import 'app_state.dart';

class AppNotifier extends StateNotifier<AppState> {
  AppNotifier() : super(const AppState()) {
    fetchThemeAndLocale();
  }

  Future<void> fetchThemeAndLocale() async {
    final isDarkMode = LocalStorage.getAppThemeMode();
    final lang = LocalStorage.getLanguage();
    final ltr = LocalStorage.getLangLtr();
    state = state.copyWith(
      isDarkMode: isDarkMode,
      activeLanguage: lang,
      isLtr: ltr,
    );
  }

  Future<void> changeTheme(bool? isDarkMode) async {
    await LocalStorage.setAppThemeMode(isDarkMode ?? false);
    state = state.copyWith(isDarkMode: isDarkMode ?? false);
  }

  Future<void> changeLocale(LanguageData? language) async {
    await LocalStorage.setLanguageData(language);
    await LocalStorage.setLangLtr(language?.backward);
    state = state.copyWith(
      activeLanguage: language,
      isLtr: !(language?.backward ?? false),
    );
  }
}
