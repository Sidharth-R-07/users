import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:users/providers/auth_provider.dart';
import 'package:users/screens/add_user_screen.dart';
import 'package:users/screens/auth_screens/sign_in_screen.dart';
import 'package:users/utils/methods.dart';

import '../../utils/fonts.dart';
import '../../widgets/input_field.dart';
import '../../widgets/loader.dart';
import '../../widgets/my_button.dart';
import '../../widgets/show_input_error.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confromPasswordController = TextEditingController();
  bool isLoading = false;

  String emailValidationText = '';
  String passwordValidationText = '';
  String conformPassValidationText = '';

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confromPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

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
                    'Signup to\nget started',
                    style: FontsProvider.titleLarge,
                  ),
                  SizedBox(
                    height: size.height * 0.08,
                  ),

                  ///--------------------TEXT INPUT FEILD SECTIONS------------------------
                  InputField(
                    controller: emailController,
                    hint: 'email',
                    keyBoard: TextInputType.name,
                    textInputAction: TextInputAction.next,
                  ),
                  ShowInputError(error: emailValidationText),
                  SizedBox(
                    height: size.height * 0.01,
                  ),
                  InputField(
                    controller: passwordController,
                    hint: 'password',
                    keyBoard: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.next,
                  ),
                  ShowInputError(error: passwordValidationText),
                  SizedBox(
                    height: size.height * 0.01,
                  ),
                  InputField(
                    controller: confromPasswordController,
                    hint: 'conform password',
                    keyBoard: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.done,
                    obscure: true,
                  ),
                  ShowInputError(error: conformPassValidationText),
                  SizedBox(
                    height: size.height * 0.04,
                  ),

                  ///--------------------ON SUBMIT BUTTON------------------------
                  MyButton(
                    onTap: () => _trySubmit(authProvider),
                    child: isLoading
                        ? const Loader()
                        : Text(
                            'Sign Up',
                            style: FontsProvider.whiteMediumText,
                          ),
                  ),

                  SizedBox(
                    height: size.height * 0.02,
                  ),

                  ///--------------------GO TO SIGNUP SCREEN BUTTON----------------------
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account?",
                        style: FontsProvider.hintText,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const SignInScreen(),
                          ));
                        },
                        child: Text(
                          'Sign In',
                          style: FontsProvider.headingMedium,
                        ),
                      ),
                    ],
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

  void passwordValidation(String val) {
    RegExp regex =
        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    if (val.isEmpty) {
      setState(() {
        passwordValidationText = 'Please enter password';
      });
    } else if (!regex.hasMatch(val)) {
      setState(() {
        passwordValidationText =
            'Password must be:\nAt least 2 number,1 uppercase latter and lowercase latter';
      });
    } else if (val.length < 5) {
      setState(() {
        passwordValidationText = 'Password must be 5 character';
      });
    } else {
      setState(() {
        passwordValidationText = '';
      });
    }
  }

  void conformPasswordValidation() {
    final password = passwordController.text.trim();
    final conformPassword = confromPasswordController.text.trim();

    if (password != conformPassword) {
      setState(() {
        conformPassValidationText = "Password does't match";
      });
    } else {
      setState(() {
        conformPassValidationText = '';
      });
    }
  }

  _trySubmit(AuthProvider authProvider) async {
    emailValidation(emailController.text.trim());
    passwordValidation(passwordController.text.trim());
    conformPasswordValidation();
    if (emailValidationText.trim().isEmpty &&
        passwordValidationText.trim().isEmpty &&
        conformPassValidationText.trim().isEmpty) {
      //FORM IS VALID PROCCED TO SIGNUP

      setState(() {
        isLoading = true;
      });
      log('FORM VALID');
      await authProvider
          .signupWithEmailAndPassword(
              emailController.text.trim(), passwordController.text.trim())
          .then((result) {
        setState(() {
          isLoading = false;
        });

        log('RESULT:$result');
        showToast(result);
        if (result == 'Sucessfull') {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const AddUserScreen(),
          ));
        }
      });
    } else {
      log('FORM NOT VALID');
      return;
    }
  }
}
