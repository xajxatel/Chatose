// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:chatose/common/enums/message_enum.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final messageReplyProvider = StateProvider<MessageReply?>((ref) => null);

class MessageReply {
  final String message;
  final bool isMe;
  final MessageEnum messageEnum;
  MessageReply({
    required this.message,
    required this.isMe,
    required this.messageEnum,
  });
}
