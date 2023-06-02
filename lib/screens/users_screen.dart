import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/user_model.dart';
import '../utils/fonts.dart';
import '../utils/methods.dart';
import '../widgets/loading_circle.dart';

import '../widgets/user_card.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  ///SET FECTHING USERS COUNT
  int limit = 15;

  ///INTIAL LOADING FOR FETCH USERS FIRST TIME
  bool loadingUsers = false;

  List<UserModel> usersList = [];
  final firestore = FirebaseFirestore.instance;

  ///LASTUSERS VARAIBLE FOR FINDING OUT LAST USERS IN LIST
  late UserModel lastUser;

  ///CREATING SCROLL CONTROLLER FOR SCROLL CONTROLLER
  final _scrollController = ScrollController();

  ///BOOL FOR GETTING MORE USERS
  bool _gettingMoreUsers = false;

  ///BOOL FOR IS THERE MORE AVAILABLE USERS
  bool _moreUsersAvailable = true;

  bool loadMore = false;

  ///GETUSERS FUNCTION FOR FETCHING LIMITED USERS AND SHOWING TO LISTVIEW
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

  ///GETMOREUSERS FUNCTION FOR FETCHING MORE LIMITED DATA AND ADD TO LIST
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
      log('ERROR IN _getMoreUser FUNCTION:$err');
    } finally {
      setState(() {
        loadingUsers = false;
      });
    }
  }

  @override
  void initState() {
    _getUsers();

    ///LISTENING SCROLL POSITION
    _scrollController.addListener(() async {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;

      ///IF SCROLLING POSITION IN END THEN SHOW LOADING AND GETMORE USERS
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
            'all users',
            style: FontsProvider.headingMedium,
          ),
        ),

        ///CHECKING IS FETCHING USERS OR NOT
        body: loadingUsers
            ? const LoadingCircle()

            ///CHECKING LIST IS EMPTY OR NOT
            : usersList.isEmpty
                ? const Center(
                    child: Text('No User Found!'),
                  )

                ///IF FIRESTORE HAS DATA THEN SHOWING A LISTVIEW
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

                      ///LOADING FOR FETCH MORE USERS
                      if (loadMore) const LoadingCircle()
                    ],
                  ));
  }
}
