import 'package:flutter/material.dart';
import 'package:users/models/user_model.dart';
import 'package:users/utils/colors.dart';
import 'package:users/utils/fonts.dart';

class UserCard extends StatelessWidget {
  final UserModel user;
  const UserCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      padding: const EdgeInsets.all(4),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(
              5.0,
              5.0,
            ),
            blurRadius: 10.0,
            spreadRadius: 2.0,
          ),
          BoxShadow(
            color: Colors.white,
            offset: Offset(0.0, 0.0),
            blurRadius: 0.0,
            spreadRadius: 0.0,
          ),
        ],
      ),
      child: ListTile(
        leading: CircleAvatar(
          radius: 25,
          backgroundColor: primaryColor,
          child: Text(
            user.age.toString(),
            style: FontsProvider.headingMedium
                .copyWith(fontSize: 32, color: bgScaffold),
          ),
        ),
        title: Text(
          user.name,
          style: FontsProvider.headingMedium,
        ),
        subtitle: Text(user.email),
      ),
    );
  }
}
