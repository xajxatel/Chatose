
import 'package:chatose/common/widgets/loader.dart';
import 'package:chatose/features/auth/controller/auth_controller.dart';
import 'package:chatose/features/chat/widgets/bottom_chat_field.dart';
import 'package:chatose/features/chat/widgets/chat_list.dart';
import 'package:chatose/helpers/colors.dart';
import 'package:chatose/models/user_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MobileChatScreen extends ConsumerWidget {
  static const String routeName = '/mobile-chat-screen';
  final String name;
  final String uid;

  final String profilePic;
  const MobileChatScreen({
    Key? key,
    required this.name,
    required this.uid,
    required this.profilePic,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: StreamBuilder<UserModel>(
            stream: ref.read(authControllerProvider).getUserDataByID(uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Loader();
              }
              return Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                CircleAvatar(
                  radius: 23,
                  backgroundImage: NetworkImage(profilePic),
                ),
                const SizedBox(
                  width: 15,
                ),
                Text(
                  name,
                  style: const TextStyle(letterSpacing: 2),
                ),
                const Spacer(),
                Icon(
                  Icons.circle,
                  color: snapshot.data!.isOnline ? greenColor : redColor,
                )
              ]);
            }),
        centerTitle: false,
      ),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover, image: AssetImage('assets/back5.jpg'))),
        child: Column(
          children: [
            Expanded(
              child: ChatList(
                receiverUserId: uid,
              ),
            ),
            BottomChatField(
              receiverUserId: uid,
            ),
          ],
        ),
      ),
    );
  }
}
