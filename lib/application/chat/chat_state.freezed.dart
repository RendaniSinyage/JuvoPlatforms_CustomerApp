// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ChatState {
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isMoreLoading => throw _privateConstructorUsedError;
  List<ChatMessageData> get chats => throw _privateConstructorUsedError;
  String get chatId => throw _privateConstructorUsedError;
  TextEditingController? get textController =>
      throw _privateConstructorUsedError;
  bool get isEditing =>
      throw _privateConstructorUsedError; // Add this for editing state
  String? get editingMessageId => throw _privateConstructorUsedError;

  /// Create a copy of ChatState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChatStateCopyWith<ChatState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatStateCopyWith<$Res> {
  factory $ChatStateCopyWith(ChatState value, $Res Function(ChatState) then) =
      _$ChatStateCopyWithImpl<$Res, ChatState>;
  @useResult
  $Res call(
      {bool isLoading,
      bool isMoreLoading,
      List<ChatMessageData> chats,
      String chatId,
      TextEditingController? textController,
      bool isEditing,
      String? editingMessageId});
}

/// @nodoc
class _$ChatStateCopyWithImpl<$Res, $Val extends ChatState>
    implements $ChatStateCopyWith<$Res> {
  _$ChatStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChatState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? isMoreLoading = null,
    Object? chats = null,
    Object? chatId = null,
    Object? textController = freezed,
    Object? isEditing = null,
    Object? editingMessageId = freezed,
  }) {
    return _then(_value.copyWith(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isMoreLoading: null == isMoreLoading
          ? _value.isMoreLoading
          : isMoreLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      chats: null == chats
          ? _value.chats
          : chats // ignore: cast_nullable_to_non_nullable
              as List<ChatMessageData>,
      chatId: null == chatId
          ? _value.chatId
          : chatId // ignore: cast_nullable_to_non_nullable
              as String,
      textController: freezed == textController
          ? _value.textController
          : textController // ignore: cast_nullable_to_non_nullable
              as TextEditingController?,
      isEditing: null == isEditing
          ? _value.isEditing
          : isEditing // ignore: cast_nullable_to_non_nullable
              as bool,
      editingMessageId: freezed == editingMessageId
          ? _value.editingMessageId
          : editingMessageId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChatStateImplCopyWith<$Res>
    implements $ChatStateCopyWith<$Res> {
  factory _$$ChatStateImplCopyWith(
          _$ChatStateImpl value, $Res Function(_$ChatStateImpl) then) =
      __$$ChatStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isLoading,
      bool isMoreLoading,
      List<ChatMessageData> chats,
      String chatId,
      TextEditingController? textController,
      bool isEditing,
      String? editingMessageId});
}

/// @nodoc
class __$$ChatStateImplCopyWithImpl<$Res>
    extends _$ChatStateCopyWithImpl<$Res, _$ChatStateImpl>
    implements _$$ChatStateImplCopyWith<$Res> {
  __$$ChatStateImplCopyWithImpl(
      _$ChatStateImpl _value, $Res Function(_$ChatStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of ChatState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? isMoreLoading = null,
    Object? chats = null,
    Object? chatId = null,
    Object? textController = freezed,
    Object? isEditing = null,
    Object? editingMessageId = freezed,
  }) {
    return _then(_$ChatStateImpl(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isMoreLoading: null == isMoreLoading
          ? _value.isMoreLoading
          : isMoreLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      chats: null == chats
          ? _value._chats
          : chats // ignore: cast_nullable_to_non_nullable
              as List<ChatMessageData>,
      chatId: null == chatId
          ? _value.chatId
          : chatId // ignore: cast_nullable_to_non_nullable
              as String,
      textController: freezed == textController
          ? _value.textController
          : textController // ignore: cast_nullable_to_non_nullable
              as TextEditingController?,
      isEditing: null == isEditing
          ? _value.isEditing
          : isEditing // ignore: cast_nullable_to_non_nullable
              as bool,
      editingMessageId: freezed == editingMessageId
          ? _value.editingMessageId
          : editingMessageId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$ChatStateImpl extends _ChatState {
  const _$ChatStateImpl(
      {this.isLoading = false,
      this.isMoreLoading = false,
      final List<ChatMessageData> chats = const [],
      this.chatId = '',
      this.textController,
      this.isEditing = false,
      this.editingMessageId})
      : _chats = chats,
        super._();

  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool isMoreLoading;
  final List<ChatMessageData> _chats;
  @override
  @JsonKey()
  List<ChatMessageData> get chats {
    if (_chats is EqualUnmodifiableListView) return _chats;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_chats);
  }

  @override
  @JsonKey()
  final String chatId;
  @override
  final TextEditingController? textController;
  @override
  @JsonKey()
  final bool isEditing;
// Add this for editing state
  @override
  final String? editingMessageId;

  @override
  String toString() {
    return 'ChatState(isLoading: $isLoading, isMoreLoading: $isMoreLoading, chats: $chats, chatId: $chatId, textController: $textController, isEditing: $isEditing, editingMessageId: $editingMessageId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatStateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isMoreLoading, isMoreLoading) ||
                other.isMoreLoading == isMoreLoading) &&
            const DeepCollectionEquality().equals(other._chats, _chats) &&
            (identical(other.chatId, chatId) || other.chatId == chatId) &&
            (identical(other.textController, textController) ||
                other.textController == textController) &&
            (identical(other.isEditing, isEditing) ||
                other.isEditing == isEditing) &&
            (identical(other.editingMessageId, editingMessageId) ||
                other.editingMessageId == editingMessageId));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      isLoading,
      isMoreLoading,
      const DeepCollectionEquality().hash(_chats),
      chatId,
      textController,
      isEditing,
      editingMessageId);

  /// Create a copy of ChatState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatStateImplCopyWith<_$ChatStateImpl> get copyWith =>
      __$$ChatStateImplCopyWithImpl<_$ChatStateImpl>(this, _$identity);
}

abstract class _ChatState extends ChatState {
  const factory _ChatState(
      {final bool isLoading,
      final bool isMoreLoading,
      final List<ChatMessageData> chats,
      final String chatId,
      final TextEditingController? textController,
      final bool isEditing,
      final String? editingMessageId}) = _$ChatStateImpl;
  const _ChatState._() : super._();

  @override
  bool get isLoading;
  @override
  bool get isMoreLoading;
  @override
  List<ChatMessageData> get chats;
  @override
  String get chatId;
  @override
  TextEditingController? get textController;
  @override
  bool get isEditing; // Add this for editing state
  @override
  String? get editingMessageId;

  /// Create a copy of ChatState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChatStateImplCopyWith<_$ChatStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
