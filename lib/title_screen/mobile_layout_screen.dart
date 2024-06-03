
import 'package:chatose/common/utils/utils.dart';
import 'package:chatose/features/auth/controller/auth_controller.dart';
import 'package:chatose/features/select_contacts/screens/select_contacts_screen.dart';

import 'package:chatose/features/chat/widgets/contacts_list.dart';
import 'package:chatose/common/widgets/animated_title.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MobileLayoutScreen extends ConsumerStatefulWidget {
  const MobileLayoutScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<MobileLayoutScreen> createState() => _MobileLayoutScreenState();
}

class _MobileLayoutScreenState extends ConsumerState<MobileLayoutScreen>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  late TabController tabController = TabController(length: 2, vsync: this);
  Color titleColor = Colors.white;

  @override
  void initState() {
    ref.read(authControllerProvider).setUserState(true);
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        ref.read(authControllerProvider).setUserState(true);
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.paused:
        ref.read(authControllerProvider).setUserState(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover, image: AssetImage('assets/back6.png'))),
        child: Column(
          children: [
            Container(
                alignment: Alignment.center,
                width: getUserScreenSize(context).width,
                color: const Color.fromARGB(164, 0, 0, 0),
                child: const AnimatedTitle()),
            const ContactsList(),
          ],
        ),
      ),
      floatingActionButton: IconButton(
        color: Colors.white,
        iconSize: 40,
        onPressed: () async {
          Navigator.of(context).pushNamed(SelectContactScreen.routeName);
        },
        icon: const Icon(
          FluentIcons.people_12_filled,
        ),
      ),
    ));
  }
}
