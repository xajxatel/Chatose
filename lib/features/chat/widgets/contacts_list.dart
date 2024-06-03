
import 'package:chatose/common/widgets/loader.dart';
import 'package:chatose/features/chat/controller/chat_controller.dart';
import 'package:chatose/helpers/colors.dart';
import 'package:chatose/features/chat/screens/mobile_chat_screen.dart';
import 'package:chatose/models/chat_contacts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ContactsList extends ConsumerWidget {
  const ContactsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, left: 10, right: 10),
      child: StreamBuilder<List<ChatContact>>(
          stream: ref.watch(chatControllerProvider).getChatContacts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Loader();
            }
            return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var chatContact = snapshot.data![index];
                return Column(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, MobileChatScreen.routeName,
                            arguments: {
                              'name': chatContact.name,
                              'uid': chatContact.contactId,
                              'profilePic': chatContact.profilePic,
                            });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Container(
                          color: Colors.black87,
                          child: ListTile(
                            title: Text(
                              chatContact.name,
                              style: GoogleFonts.lato(
                                fontSize: 18,
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 6.0),
                              child: Text(
                                chatContact.lastMessage,
                                style: const TextStyle(fontSize: 15),
                              ),
                            ),
                            leading: Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                      chatContact.profilePic,
                                    ),
                                  )),
                            ),
                            trailing: Text(
                              DateFormat.Hm().format(chatContact.timeSent),
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Divider(
                      color: dividerColor,
                      indent: 10,
                      endIndent: 10,
                    ),
                  ],
                );
              },
            );
          }),
    );
  }
}
