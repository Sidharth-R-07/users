import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<String> signupWithEmailAndPassword(
      String email, String password) async {
    String result = "Something went wrong!try again...";
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      result = 'Sucessfull';
    } on FirebaseAuthException catch (err) {
      result = err.message.toString();
    } catch (err) {
      result = err.toString();
      log('ERROR FROM SIGNUP :$err');
    }
    return result;
  }

  Future<String> signInWithEmailAndPassword(
      String email, String password) async {
    String result = "Something went wrong!try again...";

    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      result = 'Sucessfull';
    } on FirebaseAuthException catch (err) {
      result = err.message.toString();
    } catch (err) {
      log('ERROR FROM SIGNIn :$err');
      result = 'Some error occured!';
    }
    return result;
  }

  Future<String> resetPassword(String email) async {
    String result = 'Something went wrong!';
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      result = 'Sucessfull';
    } on FirebaseAuthException catch (e) {
      result = e.message.toString();
    } catch (err) {
      result = err.toString();
    }

    return result;
  }

  Future<String> signInWithGoogle() async {
    String result = 'Something went wrong!';
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleSignInAccount!.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _firebaseAuth.signInWithCredential(credential);
      result = 'Sucessfull';
    } on FirebaseAuthException catch (err) {
      log("ERROR FOUND:  ${err.message.toString()}");

      result = err.message.toString();
    } on PlatformException catch (err) {
      log("ERROR FOUND:  ${err.message.toString()}");

      result = err.message.toString();
    } catch (err) {
      log("ERROR FOUND:  ${err.toString()}");

      result = 'Error occured!';
    }

    return result;
  }

  // Sign out
  Future<String> signOut() async {
    String result = 'Something went wrong!';
    try {
      await _firebaseAuth.signOut();
    } on PlatformException catch (err) {
      result = err.message.toString();
    } catch (err) {
      result = 'Some error occured!';
      result = err.toString();
    }
    return result;
  }
}
