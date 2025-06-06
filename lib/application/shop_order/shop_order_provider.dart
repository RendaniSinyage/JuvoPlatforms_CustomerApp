import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodyman/domain/di/dependency_manager.dart';

import 'shop_order_notifier.dart';
import 'shop_order_state.dart';

final shopOrderProvider =
    StateNotifierProvider<ShopOrderNotifier, ShopOrderState>(
  (ref) => ShopOrderNotifier(cartRepository),
);
