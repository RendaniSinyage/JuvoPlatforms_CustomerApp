
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodyman/infrastructure/services/local_storage.dart';

import '../../app_constants.dart';
import 'main_state.dart';

class MainNotifier extends StateNotifier<MainState> {
  MainNotifier() : super(const MainState());

  void selectIndex(int index) {
    state = state.copyWith(selectIndex: index);
  }

  // Add this method to reset to the initial page
  void resetToInitialPage() {
    // Assuming index 0 is the home/main page
    state = state.copyWith(selectIndex: 0);
  }

  bool checkGuest(){
    return LocalStorage.getToken().isEmpty;
  }

  void changeScrolling(bool isScrolling) {
    if (!AppConstants.fixed) {
      state = state.copyWith(isScrolling: isScrolling);
    } else {
      state = state.copyWith(isScrolling: false);
    }
  }
}
