import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:users/models/user_model.dart';
import 'package:users/providers/user_provider.dart';
import 'package:users/utils/fonts.dart';
import 'package:users/widgets/lazy_loading.dart';

import '../widgets/user_card.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  bool isLoading = false;

  @override
  void initState() {
    fetchUsers(context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  fetchUsers(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    setState(() {
      isLoading = true;
    });

    await userProvider.getAllUsers();

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text(
            'All users',
            style: FontsProvider.headingMedium,
          ),
        ),
        body: isLoading
            ? const LazyLoading()
            : ListView.builder(
                itemCount: userProvider.usersList.length,
                itemBuilder: (context, index) {
                  return UserCard(user: userProvider.usersList[index]);
                },
              ));
  }
}
