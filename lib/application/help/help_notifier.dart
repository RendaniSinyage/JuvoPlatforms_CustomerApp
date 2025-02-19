import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodyman/infrastructure/services/app_helpers.dart';

import 'package:foodyman/domain/interface/settings.dart';
import 'package:foodyman/infrastructure/services/app_connectivity.dart';
import 'help_state.dart';

class HelpNotifier extends StateNotifier<HelpState> {
  final SettingsRepositoryFacade _settingsRepository;

  HelpNotifier(this._settingsRepository) : super(const HelpState());

  Future<void> fetchHelp(BuildContext context) async {
    final connected = await AppConnectivity.connectivity();
    if (connected) {
      state = state.copyWith(isLoading: true);
      final response = await _settingsRepository.getFaq();
      response.when(
        success: (data) async {
          state = state.copyWith(
            isLoading: false,
            data: data,
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
}
