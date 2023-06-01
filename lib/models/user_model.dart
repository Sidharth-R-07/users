import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String name;
  final String email;
  final int age;
  final Timestamp createAt;

  UserModel(
      {required this.name,
      required this.email,
      required this.age,
      required this.createAt});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'email': email,
      'age': age,
      'createAt': createAt
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
        name: map['name'] as String,
        email: map['email'] as String,
        age: map['age'] as int,
        createAt: map['createAt'] as Timestamp);
  }
}
