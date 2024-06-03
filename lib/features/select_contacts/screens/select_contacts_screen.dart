import 'package:chatose/common/widgets/error.dart';
import 'package:chatose/common/widgets/loader.dart';
import 'package:chatose/features/auth/controller/auth_controller.dart';
import 'package:chatose/features/select_contacts/controller/select_contact_controller.dart';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectContactScreen extends ConsumerWidget {
  static const String routeName = "/select-contact";
  const SelectContactScreen({super.key});

  void selectContact(WidgetRef ref, Contact contact, BuildContext context) {
    ref.read(selectContactControllerProvider).selectContact(contact, context);
  }

  void signOut(BuildContext context, WidgetRef ref) {
    ref.read(authControllerProvider).signOutUser(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 24, 24, 24),
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text("Select a Contact"),
          // actions: [
          //   // IconButton(
          //   //     onPressed: () {
          //   //       signOut(context, ref);
          //   //     },
          //   //     icon: Icon(FluentIcons.arrow_exit_20_filled))
          // ],
        ),
        body: ref.watch(getContacstProvider).when(
              data: (contactList) {
                return Padding(
                  padding: EdgeInsets.all(4),
                  child: ListView.builder(
                      itemCount: contactList.length,
                      itemBuilder: (context, index) {
                        final contact = contactList[index];
                        return InkWell(
                          onTap: () => selectContact(ref, contact, context),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: ListTile(
                              title: Text(
                                contact.displayName,
                                style: const TextStyle(fontSize: 18),
                              ),
                              leading: contact.photo == null
                                  ? null
                                  : CircleAvatar(
                                      backgroundImage:
                                          MemoryImage(contact.photo!),
                                      radius: 30,
                                    ),
                            ),
                          ),
                        );
                      }),
                );
              },
              error: (error, stackTrace) =>
                  ErrorScreen(error: error.toString()),
              loading: () => const Loader(),
            ));
  }
}
