import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'closed_state.dart';

class ClosedNotifier extends StateNotifier<ClosedState> {
  ClosedNotifier() : super(const ClosedState());

  void changeIndex(int index) {
    state = state.copyWith(currentIndex: index);
  }
}
