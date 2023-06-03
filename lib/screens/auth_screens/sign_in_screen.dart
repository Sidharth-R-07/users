import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:users/screens/auth_screens/phone_athentication.dart';
import 'package:users/screens/auth_screens/sign_up_screen.dart';
import 'package:users/utils/colors.dart';
import 'package:users/widgets/auth_icon.dart';
import 'package:users/widgets/loading_circle.dart';

import '../../providers/auth_provider.dart';
import '../../utils/fonts.dart';
import '../../utils/methods.dart';
import '../../widgets/input_field.dart';
import '../../widgets/loader.dart';
import '../../widgets/my_button.dart';
import '../../widgets/show_input_error.dart';
import '../add_user_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final resetEmailController = TextEditingController();

  String emailValidationText = '';
  String passwordValidationText = '';
  bool isLoading = false;
  bool gLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    resetEmailController.dispose();
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
                    'Hello!\nWelcome back',
                    style: FontsProvider.titleLarge,
                  ),
                  SizedBox(
                    height: size.height * 0.08,
                  ),

                  ///--------------------TEXT INPUT FEILD SECTIONS------------------------
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
                    controller: passwordController,
                    hint: 'password',
                    keyBoard: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.done,
                    obscure: true,
                  ),
                  ShowInputError(error: passwordValidationText),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => _showAlertDialog(authProvider),
                        child: const Text('forgot password? '),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: size.height * 0.03,
                  ),

                  ///--------------------ON SUBMIT BUTTON------------------------
                  MyButton(
                    onTap: () => _trySubmit(authProvider),
                    child: isLoading
                        ? const Loader()
                        : Text(
                            'Sign In',
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
                        "Don't have an account?",
                        style: FontsProvider.hintText,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const SignUpScreen(),
                          ));
                        },
                        child: Text(
                          'Sign Up',
                          style: FontsProvider.headingMedium,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: size.height * 0.03,
                  ),

                  const Divider(
                    color: Colors.grey,
                    thickness: .2,
                  ),
                  SizedBox(
                    height: size.height * 0.03,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      AuthIcon(
                        onTap: () => _signInwithGoogle(authProvider),
                        child: gLoading
                            ? const LoadingCircle()
                            : Image.asset(
                                'assets/images/google.png',
                                height: 38,
                              ),
                      ),
                      AuthIcon(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                const PhoneAuthenticationScreen(),
                          ));
                        },
                        child: Image.asset(
                          'assets/images/cell-phone.png',
                          height: 38,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(
                    height: size.height * 0.03,
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
    } else if (val.length < 4) {
      setState(() {
        emailValidationText = 'enter a valid email';
      });
    } else {
      setState(() {
        emailValidationText = '';
      });
    }
  }

  void passwordValidation(String val) {
    if (val.isEmpty) {
      setState(() {
        passwordValidationText = 'Please enter password';
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

  _trySubmit(AuthProvider authProvider) async {
    emailValidation(emailController.text.trim());
    passwordValidation(passwordController.text.trim());

    if (emailValidationText.trim().isEmpty &&
        passwordValidationText.trim().isEmpty) {
      //FORM IS VALID PROCCED TO SIGNUP

      setState(() {
        isLoading = true;
      });
      log('FORM VALID');
      await authProvider
          .signInWithEmailAndPassword(
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

  Future<void> _showAlertDialog(AuthProvider authProvider) async {
    bool showLoading = false;
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: bgScaffold,
          title: Text(
            'Forgot your password?',
            style: FontsProvider.headingMedium,
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Text(
                    "Enter your email address and we'll send you a link to reset your password."),
                const SizedBox(
                  height: 8,
                ),
                InputField(
                    controller: resetEmailController,
                    hint: 'enter email',
                    keyBoard: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done)
              ],
            ),
          ),
          actions: <Widget>[
            MyButton(
                child: showLoading
                    ? const Loader()
                    : Text(
                        'Request to send link',
                        style: FontsProvider.whiteMediumText
                            .copyWith(fontSize: 18),
                      ),
                onTap: () async {
                  setState(() {
                    showLoading = true;
                  });
                  await _sendRestLink(
                      authProvider: authProvider,
                      email: resetEmailController.text.trim());

                  resetEmailController.clear();
                  setState(() {
                    showLoading = false;
                  });
                }),
            Center(
              child: TextButton(
                child: const Text('Back'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Future _sendRestLink({
    required AuthProvider authProvider,
    required String email,
  }) async {
    await authProvider.resetPassword(email).then((result) {
      if (result == 'Sucessfull') {
        log('SUCCESSFULLY SENDED LINK');
        showToast('Rest Password link Sended !');
        Navigator.of(context).pop();
      } else {
        log('SOME ERROR OCCURED !WHILE SEND REST MAIL');
        showToast(result);
      }
    });
  }

  _signInwithGoogle(AuthProvider authProvider) async {
    setState(() {
      gLoading = true;
    });
    await authProvider.signInWithGoogle().then((result) {
      if (result == 'Sucessfull') {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const AddUserScreen(),
            ));
        setState(() {
          gLoading = false;
        });

        showToast('Sign In Successfull');
      } else {
        showToast(result);
      }
    });
    setState(() {
      gLoading = false;
    });
  }
}
