// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$NotificationState {
  List<NotificationModel> get notifications =>
      throw _privateConstructorUsedError;
  CountNotificationModel? get countOfNotifications =>
      throw _privateConstructorUsedError;
  bool get isReadAllLoading => throw _privateConstructorUsedError;
  bool get isAllNotificationsLoading => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $NotificationStateCopyWith<NotificationState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationStateCopyWith<$Res> {
  factory $NotificationStateCopyWith(
          NotificationState value, $Res Function(NotificationState) then) =
      _$NotificationStateCopyWithImpl<$Res, NotificationState>;
  @useResult
  $Res call(
      {List<NotificationModel> notifications,
      CountNotificationModel? countOfNotifications,
      bool isReadAllLoading,
      bool isAllNotificationsLoading});
}

/// @nodoc
class _$NotificationStateCopyWithImpl<$Res, $Val extends NotificationState>
    implements $NotificationStateCopyWith<$Res> {
  _$NotificationStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? notifications = null,
    Object? countOfNotifications = freezed,
    Object? isReadAllLoading = null,
    Object? isAllNotificationsLoading = null,
  }) {
    return _then(_value.copyWith(
      notifications: null == notifications
          ? _value.notifications
          : notifications // ignore: cast_nullable_to_non_nullable
              as List<NotificationModel>,
      countOfNotifications: freezed == countOfNotifications
          ? _value.countOfNotifications
          : countOfNotifications // ignore: cast_nullable_to_non_nullable
              as CountNotificationModel?,
      isReadAllLoading: null == isReadAllLoading
          ? _value.isReadAllLoading
          : isReadAllLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isAllNotificationsLoading: null == isAllNotificationsLoading
          ? _value.isAllNotificationsLoading
          : isAllNotificationsLoading // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NotificationStateImplCopyWith<$Res>
    implements $NotificationStateCopyWith<$Res> {
  factory _$$NotificationStateImplCopyWith(_$NotificationStateImpl value,
          $Res Function(_$NotificationStateImpl) then) =
      __$$NotificationStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<NotificationModel> notifications,
      CountNotificationModel? countOfNotifications,
      bool isReadAllLoading,
      bool isAllNotificationsLoading});
}

/// @nodoc
class __$$NotificationStateImplCopyWithImpl<$Res>
    extends _$NotificationStateCopyWithImpl<$Res, _$NotificationStateImpl>
    implements _$$NotificationStateImplCopyWith<$Res> {
  __$$NotificationStateImplCopyWithImpl(_$NotificationStateImpl _value,
      $Res Function(_$NotificationStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? notifications = null,
    Object? countOfNotifications = freezed,
    Object? isReadAllLoading = null,
    Object? isAllNotificationsLoading = null,
  }) {
    return _then(_$NotificationStateImpl(
      notifications: null == notifications
          ? _value._notifications
          : notifications // ignore: cast_nullable_to_non_nullable
              as List<NotificationModel>,
      countOfNotifications: freezed == countOfNotifications
          ? _value.countOfNotifications
          : countOfNotifications // ignore: cast_nullable_to_non_nullable
              as CountNotificationModel?,
      isReadAllLoading: null == isReadAllLoading
          ? _value.isReadAllLoading
          : isReadAllLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isAllNotificationsLoading: null == isAllNotificationsLoading
          ? _value.isAllNotificationsLoading
          : isAllNotificationsLoading // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$NotificationStateImpl extends _NotificationState {
  const _$NotificationStateImpl(
      {final List<NotificationModel> notifications = const [],
      this.countOfNotifications = null,
      this.isReadAllLoading = false,
      this.isAllNotificationsLoading = false})
      : _notifications = notifications,
        super._();

  final List<NotificationModel> _notifications;
  @override
  @JsonKey()
  List<NotificationModel> get notifications {
    if (_notifications is EqualUnmodifiableListView) return _notifications;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_notifications);
  }

  @override
  @JsonKey()
  final CountNotificationModel? countOfNotifications;
  @override
  @JsonKey()
  final bool isReadAllLoading;
  @override
  @JsonKey()
  final bool isAllNotificationsLoading;

  @override
  String toString() {
    return 'NotificationState(notifications: $notifications, countOfNotifications: $countOfNotifications, isReadAllLoading: $isReadAllLoading, isAllNotificationsLoading: $isAllNotificationsLoading)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationStateImpl &&
            const DeepCollectionEquality()
                .equals(other._notifications, _notifications) &&
            (identical(other.countOfNotifications, countOfNotifications) ||
                other.countOfNotifications == countOfNotifications) &&
            (identical(other.isReadAllLoading, isReadAllLoading) ||
                other.isReadAllLoading == isReadAllLoading) &&
            (identical(other.isAllNotificationsLoading,
                    isAllNotificationsLoading) ||
                other.isAllNotificationsLoading == isAllNotificationsLoading));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_notifications),
      countOfNotifications,
      isReadAllLoading,
      isAllNotificationsLoading);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationStateImplCopyWith<_$NotificationStateImpl> get copyWith =>
      __$$NotificationStateImplCopyWithImpl<_$NotificationStateImpl>(
          this, _$identity);
}

abstract class _NotificationState extends NotificationState {
  const factory _NotificationState(
      {final List<NotificationModel> notifications,
      final CountNotificationModel? countOfNotifications,
      final bool isReadAllLoading,
      final bool isAllNotificationsLoading}) = _$NotificationStateImpl;
  const _NotificationState._() : super._();

  @override
  List<NotificationModel> get notifications;
  @override
  CountNotificationModel? get countOfNotifications;
  @override
  bool get isReadAllLoading;
  @override
  bool get isAllNotificationsLoading;
  @override
  @JsonKey(ignore: true)
  _$$NotificationStateImplCopyWith<_$NotificationStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
