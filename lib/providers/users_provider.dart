import 'dart:async';

import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../entities/users.dart';
import '../pages/change_name_dialog.dart';

final usersProvider = ChangeNotifierProvider<UsersProvider>(
  (ref) => UsersProvider._(),
);

class UsersProvider extends ChangeNotifier {
  UsersProvider._() {
    _sub = _auth.authStateChanges().listen(
      (
        User user,
      ) async {
        if (user == null) {
          await _auth.signInAnonymously();
          _users = Users.anonymous();
        } else {
          if (_auth.currentUser.isAnonymous) {
            _users = Users.anonymous();
          } else {
            await UsersRepository.instance.addUsers(Users.fromUser(user));
            _users = await UsersRepository.instance.fetchByUserId(user.uid);
          }
        }
        notifyListeners();
      },
    );
  }
  @override
  void dispose() {
    super.dispose();
    _sub.cancel();
  }

  StreamSubscription _sub;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Users _users;
  Users get users => _users;

  Future<void> signOut() async {
    await _auth.signInAnonymously();
    notifyListeners();
  }

  Future<void> signInWithGoogle() async {
    // Trigger the authentication flow
    final googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final googleAuth = await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    await _auth.signInWithCredential(credential);

    await UsersRepository.instance.addUsers(Users.fromUser(_auth.currentUser));

    notifyListeners();
  }

  Future<void> _updateName(String name) async {
    _users = await users.updateName(name);
  }

  Future<void> changeName(BuildContext context) async {
    final res = await ChangeNameDialog.showDialog(context, users.name);
    if (res?.isNotEmpty ?? false) {
      await _updateName(res);
    }
    notifyListeners();
  }
}