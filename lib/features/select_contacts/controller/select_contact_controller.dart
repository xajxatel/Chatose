// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:chatose/features/select_contacts/repository/select_contact_repository.dart';

final selectContactControllerProvider = Provider((ref) {
  final selectContactRepository = ref.watch(selectContactRepositoryProvider);
  return SelectContactController(
      selectContactRepository: selectContactRepository, ref: ref);
});

final getContacstProvider = FutureProvider((ref) {
  final selectContactRepository = ref.watch(selectContactRepositoryProvider);

  return selectContactRepository.getContacts();
});

class SelectContactController {
  final SelectContactRepository selectContactRepository;
  final ProviderRef ref;
  SelectContactController({
    required this.selectContactRepository,
    required this.ref,
  });

  void selectContact(Contact selectedContact, BuildContext context) {
    selectContactRepository.selectContact(selectedContact, context);
  }
}
