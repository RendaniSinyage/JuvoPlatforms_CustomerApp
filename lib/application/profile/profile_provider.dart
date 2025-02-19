import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodyman/domain/di/dependency_manager.dart';
import 'package:foodyman/application/profile/profile_notifier.dart';
import 'profile_state.dart';



final profileProvider = StateNotifierProvider<ProfileNotifier, ProfileState>(
  (ref) => ProfileNotifier(userRepository,shopsRepository,galleryRepository),
);
