import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodyman/domain/di/dependency_manager.dart';


import 'product_notifier.dart';
import 'product_state.dart';



final productProvider = StateNotifierProvider.autoDispose<ProductNotifier, ProductState>(
  (ref) => ProductNotifier(cartRepository,productsRepository),
);
