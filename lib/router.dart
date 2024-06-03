import 'package:chatose/common/widgets/error.dart';
import 'package:chatose/features/auth/screens/login_screen.dart';
import 'package:chatose/features/auth/screens/otp_screen.dart';
import 'package:chatose/features/auth/screens/user_information.dart';
import 'package:chatose/features/select_contacts/screens/select_contacts_screen.dart';
import 'package:chatose/features/chat/screens/mobile_chat_screen.dart';

import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginScreen.routeName:
      return MaterialPageRoute(
        builder: (context) {
          return const LoginScreen();
        },
      );
    case OtpScreen.routeName:
      String verificationId = settings.arguments as String;
      return MaterialPageRoute(
        builder: (context) {
          return OtpScreen(
            verificationId: verificationId,
          );
        },
      );
    case UserInformationScreen.routeName:
      return MaterialPageRoute(builder: (context) {
        return const UserInformationScreen();
      });
    case SelectContactScreen.routeName:
      return MaterialPageRoute(builder: (context) {
        return const SelectContactScreen();
      });

    case MobileChatScreen.routeName:
      final userDetails = settings.arguments as Map<String, dynamic>;

      String name = userDetails['name'];
      String uid = userDetails['uid'];
      String profilePic = userDetails['profilePic'];

      return MaterialPageRoute(builder: (context) {
        return MobileChatScreen(
          name: name,
          uid: uid,
          profilePic: profilePic,
        );
      });

    default:
      return MaterialPageRoute(builder: (context) {
        return const Scaffold(
          body: ErrorScreen(error: "Invalid Screen"),
        );
      });
  }
}
