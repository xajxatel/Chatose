// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:chatose/features/auth/controller/auth_controller.dart';
import 'package:chatose/helpers/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class OtpScreen extends ConsumerWidget {
  static const String routeName = "/otp-screen";
  final String verificationId;
  const OtpScreen({
    Key? key,
    required this.verificationId,
  }) : super(key: key);

  void verifyWithOTP(WidgetRef ref, BuildContext context, String userOTP) {
    ref
        .read(authControllerProvider)
        .verifyOTP(context, verificationId, userOTP);
  }

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Text(
          "Verifying Credentials",
          style: GoogleFonts.lato(fontSize: 23),
        ),
        centerTitle: true,
      ),
      body: Center(
          child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          const Text("Enter OTP",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
              )),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: size.width * 0.4,
            child: TextField(
              style: TextStyle(fontSize: 25),
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: redColor)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: greenColor)),
                  hintText: "-  -  -  -  -  -",
                  hintStyle: TextStyle(fontSize: 30)),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                if (value.trim().length == 6) {
                  verifyWithOTP(ref, context, value.trim());
                }
              },
            ),
          )
        ],
      )),
    );
  }
}
