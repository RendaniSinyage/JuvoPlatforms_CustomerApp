import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodyman/domain/di/dependency_manager.dart';


import 'promo_code_notifier.dart';
import 'promo_code_state.dart';



final promoCodeProvider = StateNotifierProvider<PromoCodeNotifier, PromoCodeState>(
  (ref) => PromoCodeNotifier(ordersRepository),
);
