
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:foodyman/infrastructure/models/models.dart';
part 'like_state.freezed.dart';

@freezed
class LikeState with _$LikeState {

  const factory LikeState({
    @Default(true) bool isShopLoading,
    @Default([]) List<ShopData> shops,
    @Default(0) int likedShopsCount,

  }) = _LikeState;

  const LikeState._();

}