import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

final authProvider = ChangeNotifierProvider.autoDispose<AuthProvider>(
  (ref) => AuthProvider(),
);

class AuthProvider extends ChangeNotifier {
  @override
  void dispose() {
    super.dispose();
    sub.cancel();
  }

  FirebaseAuth auth = FirebaseAuth.instance;
  final sub = FirebaseAuth.instance.authStateChanges().listen(
    (
      User user,
    ) async {
      if (user == null) {
        await FirebaseAuth.instance.signInAnonymously();
      } else {
        print('${user.email} , ${user.displayName}');
      }
    },
  );

  Future<void> signOut() async {
    await auth.signInAnonymously();
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
    await auth.signInWithCredential(credential);

    notifyListeners();
  }

  Future<void> changeName(String name) async {
    await auth.currentUser.updateProfile(displayName: name);
    notifyListeners();
  }
}
