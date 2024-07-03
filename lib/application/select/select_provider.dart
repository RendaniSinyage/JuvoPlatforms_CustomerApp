import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'select_state.dart';
import 'select_notifier.dart';

final selectProvider = StateNotifierProvider.autoDispose<SelectNotifier, SelectState>(
  (ref) => SelectNotifier(),
);
