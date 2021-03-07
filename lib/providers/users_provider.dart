import 'dart:async';

import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/users.dart';
import '../pages/change_name_dialog.dart';

final usersProvider = ChangeNotifierProvider<UsersProvider>(
  (ref) => UsersProvider._(),
);

class UsersProvider extends ChangeNotifier {
  UsersProvider._() {
    _sub = _auth.authStateChanges().listen(signIn);
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  late StreamSubscription _sub;
  late Users _users;

  Users get users => _users;

  Future<void> signIn(User? user) async {
    if (user == null) {
      await _auth.signInAnonymously();
      _users = Users.anonymous();
    } else {
      if (_auth.currentUser!.isAnonymous) {
        _users = Users.anonymous();
      } else {
        await UsersRepository.instance.addUsers(Users.fromUser(user));
        _users = await UsersRepository.instance.fetchByUserId(user.uid);
      }
    }
    notifyListeners();
  }

  Future<void> signOut() async {
    await _auth.signInAnonymously();
    notifyListeners();
  }

  Future<void> signInWithGoogle() async {
    // Trigger the authentication flow
    final googleUser = await (GoogleSignIn().signIn() as FutureOr<GoogleSignInAccount>);

    // Obtain the auth details from the request
    final googleAuth = await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    await _auth.signInWithCredential(credential);

    await UsersRepository.instance.addUsers(Users.fromUser(_auth.currentUser!));

    notifyListeners();
  }

  Future<void> updateName(BuildContext context) async {
    final res = await ChangeNameDialog.showDialog(context, users.name);
    if (res?.isNotEmpty ?? false) {
      _users = await users.updateName(res);
    }
    notifyListeners();
  }
}
