// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:chatose/common/enums/message_enum.dart';
import 'package:chatose/common/providers/message_reply_provider.dart';
import 'package:chatose/features/auth/controller/auth_controller.dart';
import 'package:chatose/features/chat/repository/chat_repository.dart';
import 'package:chatose/models/chat_contacts.dart';
import 'package:chatose/models/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatControllerProvider = Provider((ref) => ChatController(
    chatRepository: ref.watch(chatRepositoryProvider), ref: ref));

class ChatController {
  final ChatRepository chatRepository;
  final ProviderRef ref;
  ChatController({required this.chatRepository, required this.ref});

  Stream<List<ChatContact>> getChatContacts() {
    return chatRepository.getChatContacts();
  }

  Stream<List<Message>> getChatStream(String receiverUserId) {
    return chatRepository.getChatStream(receiverUserId);
  }

  void sentTextMessage(
    BuildContext context,
    String text,
    String receiverUserId,
  ) async {
    final messageReply = ref.read(messageReplyProvider);
    ref
        .read(userDataAuthProvider)
        .whenData((value) => chatRepository.sendTextMessage(
              context: context,
              text: text,
              receiverUserId: receiverUserId,
              senderUserData: value!,
              messageReply: messageReply,
            ));
    ref.read(messageReplyProvider.notifier).update((state) => null);
  }

  void sentFileMessage({
    required BuildContext context,
    required File file,
    required MessageEnum messageEnum,
    required String receiverUserId,
  }) async {
    final messageReply = ref.read(messageReplyProvider);
    ref
        .read(userDataAuthProvider)
        .whenData((value) => chatRepository.sendFileMessage(
              context: context,
              file: file,
              receiverUserId: receiverUserId,
              senderUserData: value!,
              ref: ref,
              messageEnum: messageEnum,
              messageReply: messageReply,
            ));
    ref.read(messageReplyProvider.notifier).update((state) => null);
  }

  void sendGIFMessage({
    required BuildContext context,
    required String gifUrl,
    required String receiverUserId,
  }) {
    final messageReply = ref.read(messageReplyProvider);
    int gifUrlPartIndex = gifUrl.lastIndexOf('-') + 1;
    String gifUrlPart = gifUrl.substring(gifUrlPartIndex);
    String newgifUrl = 'https://i.giphy.com/media/$gifUrlPart/200.gif';

    ref.read(userDataAuthProvider).whenData((value) => chatRepository.sendGIF(
          senderUserData: value!,
          context: context,
          gifURL: newgifUrl,
          receiverUserId: receiverUserId,
          messageReply: messageReply,
        ));

    ref.read(messageReplyProvider.notifier).update((state) => null);
  }

  void setChatMessageSeen({
    required BuildContext context,
    required String receiverUserId,
    required String messageId,
  }) {
    chatRepository.setChatMessageSeen(
        context: context, receiverUserId: receiverUserId, messageId: messageId);
  }
}
