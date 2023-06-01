import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:users/models/user_model.dart';
import 'package:users/providers/user_provider.dart';
import 'package:users/screens/users_screen.dart';
import 'package:users/utils/fonts.dart';
import 'package:users/utils/methods.dart';
import 'package:users/widgets/input_field.dart';
import 'package:users/widgets/loader.dart';
import 'package:users/widgets/save_button.dart';
import 'package:users/widgets/show_input_error.dart';

class AddUserScreen extends StatefulWidget {
  const AddUserScreen({super.key});

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String nameValidationText = '';
  String emailValidationText = '';
  String ageValidationText = '';
  bool isLoading = false;
  @override
  void dispose() {
    super.dispose();

    nameController.dispose();
    emailController.dispose();
    ageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: size.height * 0.08,
                  ),
                  Text(
                    'Hello!\nWelcome back',
                    style: FontsProvider.titleLarge,
                  ),
                  SizedBox(
                    height: size.height * 0.08,
                  ),
                  InputField(
                    controller: nameController,
                    hint: 'name',
                    keyBoard: TextInputType.name,
                    textInputAction: TextInputAction.next,
                  ),
                  ShowInputError(error: nameValidationText),
                  SizedBox(
                    height: size.height * 0.01,
                  ),
                  InputField(
                    controller: emailController,
                    hint: 'email',
                    keyBoard: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                  ),
                  ShowInputError(error: emailValidationText),
                  SizedBox(
                    height: size.height * 0.01,
                  ),
                  InputField(
                    controller: ageController,
                    hint: 'age',
                    keyBoard: TextInputType.number,
                    textInputAction: TextInputAction.done,
                  ),
                  ShowInputError(error: ageValidationText),
                  SizedBox(
                    height: size.height * 0.07,
                  ),
                  SaveButton(
                    onTap: () => _submitFn(userProvider),
                    child: isLoading
                        ? const Loader()
                        : Text(
                            'save',
                            style: FontsProvider.whiteMediumText,
                          ),
                  ),
                  SizedBox(
                    height: size.height * 0.10,
                  ),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const UsersScreen(),
                        ));
                      },
                      child: const Text('View all users'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void nameValidation(String val) {
    if (val.isEmpty) {
      setState(() {
        nameValidationText = 'Enter a name';
      });
    } else if (val.length < 3) {
      setState(() {
        nameValidationText = 'name must be 3 character';
      });
    } else if (val.length > 10) {
      setState(() {
        nameValidationText = 'name  maximum 10 character';
      });
    } else {
      setState(() {
        nameValidationText = '';
      });
    }
  }

  void ageValidation(String val) {
    if (val.isEmpty) {
      setState(() {
        ageValidationText = 'Enter a age';
      });
    } else if (int.tryParse(val) == null) {
      setState(() {
        ageValidationText = 'Only numbers allowed';
      });
    } else if (val.length > 3) {
      setState(() {
        ageValidationText = 'please check entered age';
      });
    } else {
      setState(() {
        ageValidationText = '';
      });
    }
  }

  void emailValidation(String val) {
    if (val.isEmpty) {
      setState(() {
        emailValidationText = 'Enter a email';
      });
    } else if (val.length < 3) {
      setState(() {
        emailValidationText = 'enter a valid email';
      });
    } else if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(val)) {
      setState(() {
        emailValidationText = 'Enter valid email address';
      });
    } else {
      setState(() {
        emailValidationText = '';
      });
    }
  }

  void _submitFn(UserProvider userProvider) async {
    nameValidation(nameController.text.trim());
    emailValidation(emailController.text.trim());
    ageValidation(ageController.text.trim());

    if (nameValidationText.isEmpty &&
        emailValidationText.isEmpty &&
        ageValidationText.isEmpty) {
      //Then Save User
      setState(() {
        isLoading = true;
      });
      final name = nameController.text.trim();
      final email = emailController.text.trim();
      final age = ageController.text.trim();

      final newUser = UserModel(
          name: name,
          email: email,
          age: int.parse(age),
          createAt: Timestamp.now());

      await userProvider.saveUserToFirestore(user: newUser);
      setState(() {
        isLoading = false;
      });
      //clear all textfield text

      nameController.clear();
      emailController.clear();
      ageController.clear();
      showToast('User saved successfully');

      log('User DATA Saved');
    } else {
      //Form is not valid
      log('FORM IS NOT VALID');
    }
  }
}
