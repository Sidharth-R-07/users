import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:users/utils/methods.dart';
import '../models/user_model.dart';

class UserProvider with ChangeNotifier {
  List<UserModel> usersList = [];
  final firestore = FirebaseFirestore.instance;
  Future<void> saveUserToFirestore({required UserModel user}) async {
    try {
      final ref = firestore.collection('users');

      await ref.add(user.toMap());
    } on PlatformException catch (err) {
      log('PLATFORM ERROR :${err.message}');

      showToast(err.message.toString());
    } catch (err) {
      log('ERROR FOUND :$err');
      showToast('Something went worng!try again');
    }
  }

  Future<void> getAllUsers() async {
    try {
      final ref = firestore.collection('users');

      final fetedData = await ref.get();

      final fetchedList = fetedData.docs
          .map<UserModel>((data) => UserModel(
              name: data['name'], email: data['email'], age: data['age']))
          .toList();

      usersList = fetchedList;
      notifyListeners();
    } on PlatformException catch (err) {
      log('PLATFORM ERROR :${err.message}');

      showToast(err.message.toString());
    } catch (err) {
      log('ERROR FOUND :$err');
      showToast('Something went worng!try again');
    }
  }
}
