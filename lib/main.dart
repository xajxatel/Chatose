import 'package:chatose/common/widgets/loader.dart';
import 'package:chatose/features/auth/controller/auth_controller.dart';
import 'package:chatose/features/landing/screens/landing_screens.dart';
import 'package:chatose/helpers/colors.dart';

import 'package:chatose/router.dart';
import 'package:chatose/title_screen/mobile_layout_screen.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chatose',
      onGenerateRoute: (settings) {
        return generateRoute(settings);
      },
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: backgroundColor,
      ),
      home: ref.watch(userDataAuthProvider).when(
            data: (user) => user != null
                ? const MobileLayoutScreen()
                : const LandingScreen(),
            loading: () => const Loader(),
            error: (error, stackTrace) => const LandingScreen(),
          ),
    );
  }
}
