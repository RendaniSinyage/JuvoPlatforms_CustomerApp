import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'closed_notifier.dart';
import 'closed_state.dart';

final closedProvider =
    StateNotifierProvider.autoDispose<ClosedNotifier, ClosedState>(
  (ref) => ClosedNotifier(),
);
