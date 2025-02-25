import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodyman/domain/interface/settings.dart';
import 'package:foodyman/infrastructure/models/models.dart';
import 'package:foodyman/infrastructure/services/app_connectivity.dart';
import 'package:foodyman/infrastructure/services/app_helpers.dart';
import 'package:foodyman/infrastructure/services/local_storage.dart';
import 'package:foodyman/presentation/routes/app_router.dart';

import 'language_state.dart';

class LanguageNotifier extends StateNotifier<LanguageState> {
  final SettingsRepositoryFacade _settingsRepository;

  LanguageNotifier(this._settingsRepository) : super(const LanguageState());

  void change(int index) {
    state = state.copyWith(index: index);
    LocalStorage.setLanguageData(state.list[index]);
  }

  Future<void> getLanguages(BuildContext context, {bool autoSelectIfSingle = false}) async {
    final connect = await AppConnectivity.connectivity();
    if (connect) {
      state = state.copyWith(isLoading: true, isSuccess: false);
      final response = await _settingsRepository.getLanguages();
      response.when(
        success: (data) {
          final List<LanguageData> languages = data.data ?? [];
          final lang = LocalStorage.getLanguage();
          int index = 0;

          // If there's only one language and autoSelectIfSingle is true,
          // automatically select it and skip language selection
          if (languages.length == 1 && autoSelectIfSingle) {
            LocalStorage.setLanguageSelected(true);
            LocalStorage.setLanguageData(languages[0]);
            LocalStorage.setLangLtr(languages[0].backward);
            getTranslations(context);
            state = state.copyWith(
                isLoading: false,
                list: languages,
                index: 0,
                isSuccess: true,
                autoSelected: true
            );
            return;
          }

          // Otherwise, find the index of the current language
          for (int i = 0; i < languages.length; i++) {
            if (languages[i].id == lang?.id) {
              index = i;
              break;
            }
          }

          state = state.copyWith(
            isLoading: false,
            list: languages,
            index: index,
          );
        },
        failure: (failure, status) {
          state = state.copyWith(isLoading: false);
          AppHelpers.showCheckTopSnackBar(
            context,
            failure,
          );
        },
      );
    } else {
      if (context.mounted) {
        AppHelpers.showNoConnectionSnackBar(context);
      }
    }
  }

  Future<void> makeSelectedLang(BuildContext context) async {
    LocalStorage.setLanguageSelected(true);
    LocalStorage.setLanguageData(state.list[state.index]);
    LocalStorage.setLangLtr(state.list[state.index].backward);
    await getTranslations(context);
  }

  Future<void> getTranslations(BuildContext context) async {
    final connect = await AppConnectivity.connectivity();
    if (connect) {
      state = state.copyWith(isLoading: true, isSuccess: false);
      final response = await _settingsRepository.getMobileTranslations();
      response.when(
        success: (data) {
          LocalStorage.setTranslations(data.data);
          state = state.copyWith(isLoading: false, isSuccess: true);
        },
        failure: (failure, status) {
          state = state.copyWith(isLoading: false);
          AppHelpers.showCheckTopSnackBar(context, failure);
        },
      );
    } else {
      if (context.mounted) {
        context.replaceRoute(const NoConnectionRoute());
      }
    }
  }
}