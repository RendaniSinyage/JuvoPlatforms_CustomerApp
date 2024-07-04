import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'intro_notifier.dart';
import 'intro_state.dart';

final introProvider =
    StateNotifierProvider.autoDispose<IntroNotifier, IntroState>(
  (ref) => IntroNotifier(),
);
