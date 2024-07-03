import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpodtemp/infrastructure/services/app_helpers.dart';
import 'package:riverpodtemp/infrastructure/services/local_storage.dart';
import 'package:riverpodtemp/infrastructure/services/tr_keys.dart';

import 'chat_state.dart';

class ChatNotifier extends StateNotifier<ChatState> {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  ChatNotifier() : super(ChatState(textController: TextEditingController()));
  String roleId = "";

  Future<void> fetchChats(BuildContext context, String roleId) async {
    state = state.copyWith(isLoading: true,);
    roleId = roleId;
    final userId = LocalStorage.getUserId();
    QuerySnapshot? query;
    try {
      query = await _fireStore
          .collection('chats')
          .where('user.id', isEqualTo: userId)
          .where("roleId", isEqualTo: roleId)
          .get();
    } catch (e) {
      state = state.copyWith(isLoading: false);
      if (context.mounted) {
        AppHelpers.showCheckTopSnackBar(
        context,
        AppHelpers.getTranslation(TrKeys.errorWithConnectingToFirebase),
      );
      }
    }

    if (query?.size == 0) {
      final CollectionReference chats = _fireStore.collection('chats');
      final res = await  chats.add({
        'shop_id': -1,
        'created_at': Timestamp.now(),
        "roleId": roleId,
        'user': {
          'firstname': LocalStorage.getFirstName(),
          'id': LocalStorage.getUserId(),
          'img': LocalStorage.getProfileImage(),
          'lastname': LocalStorage.getLastName(),
        }
      });
      final String chatId = res.id;
      state = state.copyWith(chatId: chatId, isLoading: false);
    } else {
      state =
          state.copyWith(chatId: query?.docs.first.id ?? '', isLoading: false);
    }
  }

  Future<void> sendMessage() async {
    if (state.textController?.text.trim().isNotEmpty ?? false) {
      debugPrint('===> send message chat id ${state.chatId}');
      try {
        CollectionReference message = _fireStore.collection('messages');
        message.add(
          {
            'chat_content': state.textController?.text.trim(),
            "chat_id": state.chatId,
            "created_at": Timestamp.now(),
            "sender": 1,
            "roleId": roleId,
            'unread': true,
          },
        );
        state.textController?.clear();
      } catch (e) {
        debugPrint('==> send message send $e');
      }
    }
  }

  void checkAuthorised(BuildContext context) {
    // if (LocalStorage.instance.getUserId() == null) {
    //   AppHelpers.showCheckTopSnackBar(
    //     context,
    //     AppHelpers.getTranslation(TrKeys.youNeedToLoginFirst),
    //   );
    //   context.router.pushAndPopUntil(
    //     const LoginRoute(),
    //     predicate: (route) => false,
    //   );
    // } else {
    //   context.router.popAndPush(const ChatRoute());
    // }
  }
}