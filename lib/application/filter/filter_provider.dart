import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:foodyman/domain/di/dependency_manager.dart';
import 'filter_notifier.dart';
import 'filter_state.dart';

final filterProvider =
    StateNotifierProvider.autoDispose<FilterNotifier, FilterState>(
  (ref) => FilterNotifier(shopsRepository),
);
