import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:foodyman/infrastructure/models/data/chat_message_data.dart';


part 'chat_state.freezed.dart';

@freezed
class ChatState with _$ChatState {
  const factory ChatState({
    @Default(false) bool isLoading,
    @Default(false) bool isMoreLoading,
    @Default([]) List<ChatMessageData> chats,
    @Default('') String chatId,
    TextEditingController? textController,
    @Default(false) bool isEditing, // Add this for editing state
    String? editingMessageId, // Store the messageId of the message being edited
  }) = _ChatState;

  const ChatState._();
}
