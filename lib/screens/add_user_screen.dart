import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_model.dart';
import '../providers/user_provider.dart';
import '../screens/users_screen.dart';
import '../utils/fonts.dart';
import '../utils/methods.dart';
import '../widgets/input_field.dart';
import '../widgets/loader.dart';
import '../widgets/my_button.dart';
import '../widgets/show_input_error.dart';

class AddUserScreen extends StatefulWidget {
  const AddUserScreen({super.key});

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  //CREATED CONTROLLER FOR INPUT FEILDS
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

//THESE VARAIBLE FOR TEXTFORM FIELD VALIDATION
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
          //WHEN CLICKED SCREEN AND UNFOCUS KEYBOARD
          FocusScope.of(context).unfocus();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
          child: SingleChildScrollView(
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: size.height * 0.08,
                  ),

                  ///---------------------TITLE -----------------------------------------
                  Text(
                    'Enter User\nDetails!',
                    style: FontsProvider.titleLarge,
                  ),
                  SizedBox(
                    height: size.height * 0.08,
                  ),

                  ///--------------------SELECT PHOTO------------------------------

                  ///--------------------TEXT INPUT FEILD SECTIONS------------------------
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
                    controller: ageController,
                    hint: 'age',
                    keyBoard: TextInputType.number,
                    textInputAction: TextInputAction.done,
                  ),
                  ShowInputError(error: ageValidationText),
                  SizedBox(
                    height: size.height * 0.07,
                  ),

                  ///--------------------ON SUBMIT BUTTON------------------------
                  MyButton(
                    onTap: () => _submitFn(userProvider),
                    child: isLoading
                        ? const Loader()
                        : Text(
                            'save',
                            style: FontsProvider.whiteMediumText,
                          ),
                  ),

                  SizedBox(
                    height: size.height * 0.08,
                  ),

                  ///--------------------VIEW ALL USERS BUTTON----------------------
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
                  SizedBox(
                    height: size.height * 0.10,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

//FUNCTION FOR VALIDATING NAME INPUT FEILD
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
//FUNCTION FOR VALIDATING AGE INPUT FEILD

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
//FUNCTION FOR VALIDATING EMAIL INPUT FEILD

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

  ///SUBMIT FUNCTION FOR SUBMITING USER DATA AND STORE TO FIRESTORE
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
      FocusScope.of(context).unfocus();

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
