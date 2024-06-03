// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:chatose/common/enums/message_enum.dart';
import 'package:chatose/common/providers/message_reply_provider.dart';
import 'package:chatose/common/repository/firebase_storage_repository.dart';
import 'package:chatose/common/utils/utils.dart';
import 'package:chatose/models/chat_contacts.dart';
import 'package:chatose/models/message.dart';
import 'package:chatose/models/user_models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final chatRepositoryProvider = Provider((ref) => ChatRepository(
    auth: FirebaseAuth.instance, firestore: FirebaseFirestore.instance));

class ChatRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  ChatRepository({
    required this.auth,
    required this.firestore,
  });

  Stream<List<ChatContact>> getChatContacts() {
    // ASYNC MAP USAGE HERE , I TOOK USER ALAG SE KYUKI AS RECEIVER CAN CHANGE HIS DATA
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .snapshots()
        .asyncMap((event) async {
      List<ChatContact> contacts = [];

      for (var document in event.docs) {
        var chatContact = ChatContact.fromMap(document.data());

        var userData = await firestore
            .collection('users')
            .doc(chatContact.contactId)
            .get();

        var userModel = UserModel.fromMap(userData.data()!);

        contacts.add(ChatContact(
            name: userModel.name,
            profilePic: userModel.profilePic,
            contactId: chatContact.contactId,
            timeSent: chatContact.timeSent,
            lastMessage: chatContact.lastMessage));
      }

      return contacts;
    });
  }

  void _saveDataToContactsSubcollection({
    required UserModel senderUserData,
    required UserModel receiverUserData,
    required String text,
    required DateTime timeSent,
    required String receiverUserId,
  }) async {
    var receiverChatContact = ChatContact(
      name: senderUserData.name,
      profilePic: senderUserData.profilePic,
      contactId: senderUserData.uid,
      timeSent: timeSent,
      lastMessage: text,
    );
    await firestore
        .collection('users')
        .doc(receiverUserId)
        .collection('chats')
        .doc(senderUserData.uid)
        .set(receiverChatContact.toMap());

    var senderChatContact = ChatContact(
      name: receiverUserData.name,
      profilePic: receiverUserData.profilePic,
      contactId: receiverUserData.uid,
      timeSent: timeSent,
      lastMessage: text,
    );
    await firestore
        .collection('users')
        .doc(senderUserData.uid)
        .collection('chats')
        .doc(receiverUserId)
        .set(senderChatContact.toMap());
  }

  Stream<List<Message>> getChatStream(String receiverUserId) {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(receiverUserId)
        .collection('messages')
        .orderBy('timeSent')
        .snapshots()
        .asyncMap((event) {
      List<Message> messages = [];
      for (var document in event.docs) {
        var message = Message.fromMap(document.data());
        messages.add(message);
      }
      return messages;
    });
  }

  void _saveMessageToMessageSubcollection({
    required String receiverUserId,
    required String username,
    required String receiverUsername,
    required String text,
    required DateTime timeSent,
    required String messageId,
    required MessageEnum messagetype,
    required MessageReply? messageReply,
    required String senderUsername,
    required String? recieverUserName,
  }) async {
    final message = Message(
      senderId: auth.currentUser!.uid,
      receiverid: receiverUserId,
      text: text,
      type: messagetype,
      timeSent: timeSent,
      messageId: messageId,
      isSeen: false,
      repliedMessage: messageReply == null ? '' : messageReply.message,
      repliedTo: messageReply == null
          ? ''
          : messageReply.isMe
              ? senderUsername
              : recieverUserName ?? '',
      repliedMessageType:
          messageReply == null ? MessageEnum.text : messageReply.messageEnum,
    );

    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(receiverUserId)
        .collection('messages')
        .doc(messageId)
        .set(message.toMap());

    await firestore
        .collection('users')
        .doc(receiverUserId)
        .collection('chats')
        .doc(auth.currentUser!.uid)
        .collection('messages')
        .doc(messageId)
        .set(message.toMap());
  }

  void sendTextMessage({
    required BuildContext context,
    required String text,
    required String receiverUserId,
    required UserModel senderUserData,
    required MessageReply? messageReply,
  }) async {
    try {
      var timeSent = DateTime.now();
      UserModel receiverUserData;

      var userDataMap =
          await firestore.collection('users').doc(receiverUserId).get();

      receiverUserData = UserModel.fromMap(userDataMap.data()!);

      var messageId = const Uuid().v1();

      _saveDataToContactsSubcollection(
          senderUserData: senderUserData,
          receiverUserData: receiverUserData,
          text: text,
          timeSent: timeSent,
          receiverUserId: receiverUserId);

      _saveMessageToMessageSubcollection(
        receiverUserId: receiverUserId,
        username: senderUserData.name,
        receiverUsername: receiverUserData.name,
        text: text,
        timeSent: timeSent,
        messageId: messageId,
        messagetype: MessageEnum.text,
        messageReply: messageReply,
        recieverUserName: receiverUserData.name,
        senderUsername: senderUserData.name,
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void sendGIF({
    required BuildContext context,
    required String gifURL,
    required String receiverUserId,
    required UserModel senderUserData,
    required MessageReply? messageReply,
  }) async {
    try {
      var timeSent = DateTime.now();
      UserModel receiverUserData;

      var userDataMap =
          await firestore.collection('users').doc(receiverUserId).get();

      receiverUserData = UserModel.fromMap(userDataMap.data()!);

      var messageId = const Uuid().v1();

      _saveDataToContactsSubcollection(
          senderUserData: senderUserData,
          receiverUserData: receiverUserData,
          text: 'GIF',
          timeSent: timeSent,
          receiverUserId: receiverUserId);

      _saveMessageToMessageSubcollection(
        receiverUserId: receiverUserId,
        username: senderUserData.name,
        receiverUsername: receiverUserData.name,
        text: gifURL,
        timeSent: timeSent,
        messageId: messageId,
        messagetype: MessageEnum.gif,
        messageReply: messageReply,
        recieverUserName: receiverUserData.name,
        senderUsername: senderUserData.name,
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void sendFileMessage({
    required BuildContext context,
    required File file,
    required String receiverUserId,
    required UserModel senderUserData,
    required ProviderRef ref,
    required MessageEnum messageEnum,
    required MessageReply? messageReply,
  }) async {
    try {
      DateTime timeSent = DateTime.now();
      String messageId = const Uuid().v1();

      String mediaUrl = await ref
          .read(commonFirebaseStorageRepositoryProvider)
          .storeFileToFirebase(
              'chat/${messageEnum.type}/${senderUserData.uid}/$receiverUserId/$messageId',
              file);

      UserModel receiverUserData;

      var userDataMap =
          await firestore.collection('users').doc(receiverUserId).get();

      receiverUserData = UserModel.fromMap(userDataMap.data()!);

      String contactDisplayMessage;
      ;

      switch (messageEnum) {
        case MessageEnum.image:
          contactDisplayMessage = '📷image';
          break;
        case MessageEnum.video:
          contactDisplayMessage = '📹video';
          break;
        case MessageEnum.audio:
          contactDisplayMessage = '🔊audio';
          break;
        case MessageEnum.gif:
          contactDisplayMessage = '🎥gif';
          break;
        default:
          contactDisplayMessage = 'some message';
          break;
      }

      _saveDataToContactsSubcollection(
          senderUserData: senderUserData,
          receiverUserData: receiverUserData,
          text: contactDisplayMessage,
          timeSent: timeSent,
          receiverUserId: receiverUserId);

      _saveMessageToMessageSubcollection(
        receiverUserId: receiverUserId,
        username: senderUserData.name,
        receiverUsername: receiverUserData.name,
        text: mediaUrl,
        timeSent: timeSent,
        messageId: messageId,
        messagetype: messageEnum,
        messageReply: messageReply,
        recieverUserName: receiverUserData.name,
        senderUsername: senderUserData.name,
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void setChatMessageSeen({
    required BuildContext context,
    required String receiverUserId,
    required String messageId,
  }) async {
    try {
      await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('chats')
          .doc(receiverUserId)
          .collection('messages')
          .doc(messageId)
          .update({
        'isSeen': true,
      });

      await firestore
          .collection('users')
          .doc(receiverUserId)
          .collection('chats')
          .doc(auth.currentUser!.uid)
          .collection('messages')
          .doc(messageId)
          .update({
        'isSeen': true,
      });
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
