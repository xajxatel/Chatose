import 'dart:io';

import 'package:chatose/features/auth/repository/auth_repository.dart';
import 'package:chatose/models/user_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authControllerProvider = Provider((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthController(authRepository: authRepository, ref: ref);
});

final userDataAuthProvider = FutureProvider((ref) {
  final authController = ref.watch(authControllerProvider);

  return authController.getCurrentUserData();
});

class AuthController {
  final AuthRepository authRepository;
  final ProviderRef ref;

  AuthController({
    required this.ref,
    required this.authRepository,
  });

  Future<UserModel?> getCurrentUserData() async {
    UserModel? user = await authRepository.getCurrentUserData();

    return user;
  }

  void signInWithPhone(BuildContext context, String phoneNumber) {
    authRepository.signInWithPhone(context, phoneNumber);
  }

  void verifyOTP(BuildContext context, String verificationId, String userOTP) {
    
    authRepository.verifyOTP(
        context: context, userOTP: userOTP, verificationId: verificationId);
  }

  void saveUserDataToFirebase(
      BuildContext context, String name, File? profilePic) {
    authRepository.saveUserDataToFirebase(
        context: context, name: name, ref: ref, profilePic: profilePic);
  }

  Stream<UserModel> getUserDataByID(String uid) {
    return authRepository.userData(uid);
  }

  void setUserState(bool isOnline) async {
    authRepository.setUserState(isOnline);
  }

  void signOutUser(BuildContext context)async {
    
    authRepository.signOutUser(context);
  }
}
