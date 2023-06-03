import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:users/utils/methods.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  late String _verificationId;
  late int _tokenId;

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

  //PHONE AUTHENTICATION

  Future<void> signInWithPhone({required String phoneNumber}) async {
    try {
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (phoneAuthCredential) async {
          await _firebaseAuth.signInWithCredential(phoneAuthCredential);
          log('Phone Verification Successfull');
        },
        verificationFailed: (error) {
          //SHOW ERROR

          log('VERFICATION FAILD :$error');
          showToast(error.message.toString());
        },
        codeSent: (verificationId, resendToken) {
          log('SMS sent to the Phone Number Successfull');
          _verificationId = verificationId;
          _tokenId = resendToken!;
        },
        codeAutoRetrievalTimeout: (verificationId) {},
      );
    } on FirebaseAuthException catch (err) {
      log('ERROR FOUND:${err.message}');
      showToast(err.message.toString());
    } catch (err) {
      log('ERROR FOUND:$err');
      showToast(err.toString());
    }
  }

  Future<String> verifyOTP({required String otp}) async {
    String result = 'Something went wrong!';
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: otp,
      );

      await _firebaseAuth.signInWithCredential(credential);
      result = 'Sucessfull';

      log('Sign in with phone number successfull');
    } on PlatformException catch (err) {
      log('ERROR FOUND:${err.message}');
      result = err.message.toString();
    } catch (err) {
      log('ERROR FOUND:$err');
      result = 'Error occured!';
    }
    return result;
  }
}
