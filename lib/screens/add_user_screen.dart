import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:users/utils/fonts.dart';
import 'package:users/widgets/input_field.dart';
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
                  SaveButton(title: 'save', onTap: _submitFn),
                  SizedBox(
                    height: size.height * 0.10,
                  ),
                  Center(
                    child: TextButton(
                      onPressed: () {},
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

  void _submitFn() {
    nameValidation(nameController.text.trim());
    emailValidation(emailController.text.trim());
    ageValidation(ageController.text.trim());

    if (nameValidationText.isEmpty &&
        emailValidationText.isEmpty &&
        ageValidationText.isEmpty) {
      //Then Save User

      log('User DATA Saved');
    } else {
      log('FORM IS NOT VALID');
    }
  }
}
