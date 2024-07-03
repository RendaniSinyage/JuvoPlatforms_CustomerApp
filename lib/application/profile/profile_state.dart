import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpodtemp/infrastructure/models/data/address_new_data.dart';
import 'package:riverpodtemp/infrastructure/models/data/referral_data.dart';
import 'package:riverpodtemp/infrastructure/models/models.dart';

import '../../infrastructure/models/data/translation.dart';


part 'profile_state.freezed.dart';

@freezed
class ProfileState with _$ProfileState {
  const factory ProfileState({
    @Default(true) bool isLoading,
    @Default(true) bool isReferralLoading,
    @Default(false) bool isSaveLoading,
    @Default(true) bool isLoadingHistory,
    @Default(0) int typeIndex,
    @Default(0) int selectAddress,
    @Default("") String bgImage,
    @Default("") String logoImage,
    @Default(null) AddressNewModel? addressModel,
    @Default(null) ProfileData? userData,
    @Default(null) ReferralModel? referralData,
    @Default([]) List<WalletData>? walletHistory,
    @Default(false) bool isTermLoading,
    @Default(false) bool isPolicyLoading,
    @Default(null) Translation? policy,
    @Default(null) Translation? term,
  }) = _ProfileState;

  const ProfileState._();
}
