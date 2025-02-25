import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodyman/domain/interface/shops.dart';
import 'package:foodyman/infrastructure/services/app_connectivity.dart';
import 'package:foodyman/infrastructure/services/app_helpers.dart';
import 'package:foodyman/infrastructure/services/local_storage.dart';

import 'like_state.dart';

class LikeNotifier extends StateNotifier<LikeState> {
  final ShopsRepositoryFacade _shopsRepository;

  LikeNotifier(
      this._shopsRepository,
      ) : super(const LikeState());

  Future<void> fetchLikeShop(BuildContext context) async {
    final connected = await AppConnectivity.connectivity();
    if (connected) {
      state = state.copyWith(isShopLoading: true);
      final list = LocalStorage.getSavedShopsList();
      if (list.isNotEmpty) {
        final response = await _shopsRepository.getShopsByIds(list);
        response.when(
          success: (data) async {
            state = state.copyWith(
              isShopLoading: false,
              shops: data.data ?? [],
              likedShopsCount: data.data?.length ?? 0, // Add this line
            );
          },
          failure: (failure, status) {
            state = state.copyWith(isShopLoading: false);
            AppHelpers.showCheckTopSnackBar(
              context,
              failure,
            );
          },
        );
      } else {
        state = state.copyWith(isShopLoading: false, shops: [], likedShopsCount: 0); // Add this line
      }
    } else {
      if (context.mounted) {
        AppHelpers.showNoConnectionSnackBar(context);
      }
    }
  }
}
