// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:chatose/common/enums/message_enum.dart';
import 'package:chatose/common/providers/message_reply_provider.dart';
import 'package:chatose/common/widgets/loader.dart';
import 'package:chatose/features/chat/widgets/my_msg_card.dart';
import 'package:chatose/features/chat/widgets/sender_msg_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:chatose/features/chat/controller/chat_controller.dart';

import 'package:chatose/models/message.dart';

import 'package:intl/intl.dart';

class ChatList extends ConsumerStatefulWidget {
  final String receiverUserId;
  const ChatList({super.key, required this.receiverUserId});

  @override
  ConsumerState<ChatList> createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    super.dispose();
  }

  void onMessageSwipe({
    required String message,
    required bool isMe,
    required MessageEnum messageEnum,
  }) {
    ref.read(messageReplyProvider.notifier).update((state) =>
        MessageReply(message: message, isMe: isMe, messageEnum: messageEnum));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Message>>(
        stream: ref
            .read(chatControllerProvider)
            .getChatStream(widget.receiverUserId),
        builder: (context, snapshot) {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            _scrollController
                .jumpTo(_scrollController.position.maxScrollExtent);
          });
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Loader();
          }
          return ListView.builder(
            controller: _scrollController,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final messageData = snapshot.data![index];
              if (!messageData.isSeen &&
                  messageData.receiverid ==
                      FirebaseAuth.instance.currentUser!.uid) {
                ref.read(chatControllerProvider).setChatMessageSeen(
                    context: context,
                    receiverUserId: widget.receiverUserId,
                    messageId: messageData.messageId);
              }

              if (messageData.senderId ==
                  FirebaseAuth.instance.currentUser!.uid) {
                return MyMessageCard(
                  message: messageData.text,
                  date: DateFormat.Hm().format(messageData.timeSent),
                  type: messageData.type,
                  repliedMessageType: messageData.repliedMessageType,
                  repliedText: messageData.repliedMessage,
                  username: messageData.repliedTo,
                  isSeen: messageData.isSeen,
                  onLeftSwipe: () => onMessageSwipe(
                    message: messageData.text,
                    isMe: true,
                    messageEnum: messageData.type,
                  ),
                );
              }
              return SenderMessageCard(
                message: messageData.text,
                date: DateFormat.Hm().format(messageData.timeSent),
                type: messageData.type,
                repliedMessageType: messageData.repliedMessageType,
                repliedText: messageData.repliedMessage,
                username: messageData.repliedTo,
                onRightSwipe: () => onMessageSwipe(
                    isMe: false,
                    message: messageData.text,
                    messageEnum: messageData.type),
              );
            },
          );
        });
  }
}
