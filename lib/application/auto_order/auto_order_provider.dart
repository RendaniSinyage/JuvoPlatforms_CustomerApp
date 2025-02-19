import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auto_order_state.dart';
import 'auto_order_notifier.dart';

final autoOrderProvider = StateNotifierProvider.autoDispose<AutoOrderNotifier, AutoOrderState>(
  (ref) => AutoOrderNotifier(),
);
