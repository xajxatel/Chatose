import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chatose/common/widgets/custom_button.dart';
import 'package:chatose/features/auth/screens/login_screen.dart';
import 'package:chatose/helpers/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({Key? key}) : super(key: key);

  void navigateToLoginScreen(BuildContext context) {
    Navigator.of(context).pushNamed(LoginScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: size.height / 12),
                Text(
                  'Chatose',
                  style: GoogleFonts.zeyada(
                    fontSize: size.height / 8,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Image.asset(
                  "assets/logo4.png",
                  height: size.height / 3,
                  width: size.width - 50,
                ),
                AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText('Hey there welcome to Chatose!',
                        textStyle:
                            GoogleFonts.lato(color: Colors.white, fontSize: 20),
                        speed: const Duration(milliseconds: 300),
                        textAlign: TextAlign.right),
                  ],
                  repeatForever: true,
                  pause: const Duration(milliseconds: 1000),
                  displayFullTextOnTap: true,
                  stopPauseOnTap: true,
                ),
                SizedBox(height: size.height / 6),
                SizedBox(
                    width: size.width * 0.75,
                    child: CustomButton(
                        text: "Become a Member",
                        color: blueColor,
                        onPressed: () => navigateToLoginScreen(context))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
