import 'dart:ffi';

import 'package:daily_discipleship/services/firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final userStream = FirebaseAuth.instance.authStateChanges();
  final user = FirebaseAuth.instance.currentUser;

  Future<void> googleLogin() async {
    try {
      debugPrint("Signing in with Google...");
      final googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) return;

      final googleAuth = await googleUser.authentication;
      final authCredential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(authCredential);
      debugPrint("Succesfully Signed In with Google!");
      if ((user?.emailVerified ?? false)) {
        FirestoreService().verifyUser(user);
      }
    } on FirebaseAuthException catch (_) {
      debugPrint("Failed to Sign in with Google...");
      // handle error
    }
  }

  // Future<void> signInWithApple() async {
  //   // Initialize the AppleAuthProvider
  //   final appleProvider = AppleAuthProvider();

  //   try {
  //     debugPrint("Signing in with Apple...");
  //     UserCredential user =
  //         await FirebaseAuth.instance.signInWithProvider(appleProvider);
  //     debugPrint("Succesfully Signed In with Apple!");
  //     debugPrint(user.toString());
  //     // if ((user?.emailVerified ?? false)) {
  //     //   FirestoreService().verifyUser(user);
  //     // }
  //   } on FirebaseAuthException catch (e) {
  //     // Handle any FirebaseAuth related errors here
  //     debugPrint("FirebaseAuthException: ${e.message}");
  //     rethrow;
  //   } catch (e) {
  //     // Handle any other errors that might occur
  //     debugPrint("General Exception: $e");
  //     rethrow;
  //   }
  // }

  Future<String> emailLogin(String email, String password) async {
    try {
      debugPrint("Signing in with email");
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      debugPrint("Succesfully Signed In with email!");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        debugPrint('No user found for that email.');
        return 'No account for this email. ';
      } else if (e.code == 'wrong-password') {
        debugPrint('Wrong password provided for that user.');
        return 'Incorrect password. ';
      }
    }
    return "";
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      debugPrint("Sending password reset email");
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      debugPrint("Reset password email sent!");
    } on FirebaseAuthException catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<String> deleteAccountWithEmail(String email, String password) async {
    String response = await emailLogin(email, password);
    if (response != "") {
      return response;
    }
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userId = user.uid;
      try {
        await FirestoreService().deleteUserAccount(userId);
        await user.delete();
      } catch (error) {
        debugPrint(error.toString());
      }
    }
    return "";
  }

  Future<String> deleteAccountWithGoogle() async {
    await googleLogin();
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userId = user.uid;
      try {
        await FirestoreService().deleteUserAccount(userId);
        await user.delete();
        debugPrint("Successfully deleted account");
      } catch (error) {
        debugPrint(error.toString());
      }
    }
    return "";
  }

  Future<void> signOut() async {
    debugPrint("Signing Out...");
    await FirebaseAuth.instance.signOut();
  }
}
