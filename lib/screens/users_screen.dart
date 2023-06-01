import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:users/models/user_model.dart';
import 'package:users/utils/fonts.dart';
import 'package:users/utils/methods.dart';
import 'package:users/widgets/lazy_loading.dart';

import '../widgets/user_card.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  int limit = 10;
  bool loadingUsers = false;

  List<UserModel> usersList = [];
  final firestore = FirebaseFirestore.instance;
  late UserModel lastUser;

  final _scrollController = ScrollController();
  bool _gettingMoreUsers = false;
  bool _moreUsersAvailable = true;

  bool loadMore = false;




  
  Future<void> _getUsers() async {
    try {
      setState(() {
        loadingUsers = true;
      });
      final snapshot = await firestore
          .collection('users')
          .orderBy('createAt', descending: true)
          .limit(limit)
          .get();
      final fetchedList = snapshot.docs
          .map<UserModel>((data) => UserModel(
              name: data['name'],
              email: data['email'],
              age: data['age'],
              createAt: data['createAt']))
          .toList();

      lastUser = fetchedList[fetchedList.length - 1];
      usersList = fetchedList;

      setState(() {
        loadingUsers = false;
      });
    } on PlatformException catch (err) {
      showToast(err.message.toString());
    } catch (err) {
      log('ERROR IN _getUser FUNCTION:$err');
    } finally {
      setState(() {
        loadingUsers = false;
      });
    }
  }

  _getMoreUsers() async {
    log('GET MORE FUNCTION CALLED');

    if (_moreUsersAvailable == false) {
      showToast('No more Users');
      return;
    }

    if (_gettingMoreUsers == true) {
      return;
    }
    try {
      _gettingMoreUsers = true;
      final snapshot = await firestore
          .collection('users')
          .orderBy('createAt', descending: true)
          .startAfter([lastUser.createAt])
          .limit(limit)
          .get();

      final fetchedList = snapshot.docs
          .map<UserModel>((data) => UserModel(
              name: data['name'],
              email: data['email'],
              age: data['age'],
              createAt: data['createAt']))
          .toList();

      if (fetchedList.length < limit) {
        _moreUsersAvailable = false;
      }

      lastUser = fetchedList[fetchedList.length - 1];
      setState(() {
        usersList.addAll(fetchedList);
      });

      _gettingMoreUsers = false;
    } on PlatformException catch (err) {
      showToast(err.message.toString());
    } catch (err) {
      showToast(err.toString());
    } finally {
      setState(() {
        loadingUsers = false;
      });
    }
  }

  @override
  void initState() {
    _getUsers();
    _scrollController.addListener(() async {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;

      final delta = MediaQuery.of(context).size.height * 0.25;

      if (maxScroll == currentScroll) {
        setState(() {
          loadMore = true;
        });
        Future.delayed(
          const Duration(milliseconds: 2000),
          () {
            setState(() {
              loadMore = false;
            });
          },
        );
        _getMoreUsers();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'All users',
            style: FontsProvider.headingMedium,
          ),
        ),
        body: loadingUsers
            ? const LazyLoading()
            : usersList.isEmpty
                ? const Center(
                    child: Text('No User Found!'),
                  )
                : Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          controller: _scrollController,
                          itemCount: usersList.length,
                          itemBuilder: (context, index) {
                            log('PRODUCT COUNT:${usersList.length}');
                            return UserCard(user: usersList[index]);
                          },
                        ),
                      ),
                      if (loadMore) const LazyLoading()
                    ],
                  ));
  }
}
