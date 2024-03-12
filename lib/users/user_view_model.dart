import 'dart:async';

import 'package:crepas/auth_repo.dart';
import 'package:crepas/users/user_profile_model.dart';
import 'package:crepas/users/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserViewModel extends AsyncNotifier<UserProfileModel> {
  late final UserRepository _repository;
  late final AuthenticationRepository _authrepo;
  @override
  FutureOr<UserProfileModel> build() async {
    _repository = ref.read(userRepo);
    _authrepo = ref.read(authRepo);
    if (_authrepo.isLoggedIn) {
      final profile = await _repository.findProfile(_authrepo.user!.uid);
      if (profile != null) {
        return UserProfileModel.fromJson(profile);
      }
    }
    return UserProfileModel.empty();
  }

  Future<void> createAccount(UserCredential credential) async {
    if (credential.user == null) {
      throw Exception("Account not created");
    }
    state = const AsyncValue.loading();
    final profile = UserProfileModel(
      uid: credential.user!.uid,
      email: credential.user!.email ?? "",
      name: credential.user!.displayName ?? "",
      imageURL: '',
      token: "",
      nickName: '',
      country: "",
    );
    await _repository.createProfile(profile);
    state = AsyncValue.data(profile);
    print("create account success");
  }
}

final userProvider = AsyncNotifierProvider<UserViewModel, UserProfileModel>(
  () => UserViewModel(),
);
