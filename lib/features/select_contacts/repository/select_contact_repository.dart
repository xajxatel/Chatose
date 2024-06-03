// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:chatose/common/utils/utils.dart';
import 'package:chatose/models/user_models.dart';
import 'package:chatose/features/chat/screens/mobile_chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectContactRepositoryProvider = Provider(
    (ref) => SelectContactRepository(firestore: FirebaseFirestore.instance));

class SelectContactRepository {
  FirebaseFirestore firestore;
  SelectContactRepository({
    required this.firestore,
  });

  Future<List<Contact>> getContacts() async {
    List<Contact> contacts = [];
    try {
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return contacts;
  }

  void selectContact(Contact selectedContact, BuildContext context) async {
    try {
      var collection = await firestore.collection('users').get();

      bool isFound = false;

      for (var document in collection.docs) {
        var userData = UserModel.fromMap(document.data());

        String selectedPhoneNumber =
            selectedContact.phones[0].number.replaceAll(" ", "");

        if (selectedPhoneNumber == userData.phoneNumber) {
          isFound = true;

          Navigator.of(context)
              .pushNamed(MobileChatScreen.routeName, arguments: {
            'name': userData.name,
            'uid': userData.uid,
            'profilePic': userData.profilePic,
          });
        }
      }

      if (!isFound) {
        print("not found");
        showSnackBar(context: context, content: "Number not found");
      }
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
