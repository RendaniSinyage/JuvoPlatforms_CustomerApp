import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpodtemp/domain/di/dependency_manager.dart';

import 'parcel_notifier.dart';
import 'parcel_state.dart';



final parcelProvider = StateNotifierProvider<ParcelNotifier, ParcelState>(
  (ref) => ParcelNotifier(parcelRepository,drawRepository),
);
