import 'dart:io';

import 'package:chatose/common/utils/utils.dart';
import 'package:chatose/features/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserInformationScreen extends ConsumerStatefulWidget {
  static const String routeName = "/user-information";

  const UserInformationScreen({super.key});

  @override
  ConsumerState<UserInformationScreen> createState() =>
      _UserInformationScreenState();
}

class _UserInformationScreenState extends ConsumerState<UserInformationScreen> {
  final TextEditingController _nameController = TextEditingController();

  File? image;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void pickImage() async {
    image = await pickImageFromGallery(context);
    setState(() {});
  }

  void storeUserData() async {
    final name = _nameController.text;

    if (name.trim().isNotEmpty) {
      ref
          .read(authControllerProvider)
          .saveUserDataToFirebase(context, name, image);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Stack(
                children: [
                  (image == null)
                      ? const CircleAvatar(
                          radius: 64,
                          backgroundImage: NetworkImage(defaultProfileImage),
                        )
                      : CircleAvatar(
                          radius: 64,
                          backgroundImage: FileImage(image!),
                        ),
                  Positioned(
                      bottom: -10,
                      left: 80,
                      child: IconButton(
                          onPressed: pickImage,
                          icon: const Icon(Icons.add_a_photo))),
                ],
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    width: size.width * 0.85,
                    child: TextField(
                      controller: _nameController,
                      decoration:
                          const InputDecoration(hintText: "Enter Your Name"),
                    ),
                  ),
                  IconButton(
                      onPressed: storeUserData, icon: const Icon(Icons.done)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
