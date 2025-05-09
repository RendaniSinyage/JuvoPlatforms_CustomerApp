import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodyman/domain/di/dependency_manager.dart';


import 'edit_profile_notifier.dart';
import 'edit_profile_state.dart';



final editProfileProvider = StateNotifierProvider<EditProfileNotifier, EditProfileState>(
  (ref) => EditProfileNotifier(userRepository,galleryRepository),
);
