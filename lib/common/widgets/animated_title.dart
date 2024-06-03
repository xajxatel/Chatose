import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chatose/common/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AnimatedTitle extends StatelessWidget {
  const AnimatedTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedTextKit(
      animatedTexts: [
        TyperAnimatedText(
          'Chatose',
          curve: Curves.easeInOut,
          textStyle: GoogleFonts.zeyada(
              color: Colors.white70,
              fontSize: getUserScreenSize(context).width / 5),
          speed: const Duration(milliseconds: 1000),
        ),
        TyperAnimatedText(
          'Chatose',
          curve: Curves.easeInOut,
          textStyle: GoogleFonts.zeyada(
              color: Colors.white54,
              fontSize: getUserScreenSize(context).width / 5),
          speed: const Duration(milliseconds: 1000),
        ),
        TyperAnimatedText(
          'Chatose',
          curve: Curves.easeInOut,
          textStyle: GoogleFonts.zeyada(
              color: Colors.white38,
              fontSize: getUserScreenSize(context).width / 5),
          speed: const Duration(milliseconds: 1000),
        ),
        TyperAnimatedText(
          'Chatose',
          curve: Curves.easeInOut,
          textStyle: GoogleFonts.zeyada(
              color: Colors.white30,
              fontSize: getUserScreenSize(context).width / 5),
          speed: const Duration(milliseconds: 1000),
        ),
        TyperAnimatedText(
          'Chatose',
          curve: Curves.easeInOut,
          textStyle: GoogleFonts.zeyada(
              color: Colors.white24,
              fontSize: getUserScreenSize(context).width / 5),
          speed: const Duration(milliseconds: 1000),
        ),
        TyperAnimatedText(
          'Chatose',
          curve: Curves.easeInOut,
          textStyle: GoogleFonts.zeyada(
              color: Colors.white12,
              fontSize: getUserScreenSize(context).width / 5),
          speed: const Duration(milliseconds: 1000),
        ),
        TyperAnimatedText(
          'Chatose',
          curve: Curves.easeInOut,
          textStyle: GoogleFonts.zeyada(
              color: Colors.white10,
              fontSize: getUserScreenSize(context).width / 5),
          speed: const Duration(milliseconds: 1000),
        ),
      ],
      displayFullTextOnTap: true,
      repeatForever: true,
      stopPauseOnTap: true,
    );
  }
}
