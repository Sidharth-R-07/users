import 'package:flutter/material.dart';
import 'package:users/screens/auth/sign_up_screen.dart';

import '../../utils/fonts.dart';
import '../../widgets/input_field.dart';
import '../../widgets/loader.dart';
import '../../widgets/my_button.dart';
import '../../widgets/show_input_error.dart';
import '../users_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
                  // ShowInputError(error: nameValidationText),
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
                  //  ShowInputError(error: emailValidationText),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: const Text('forgot password? '),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: size.height * 0.06,
                  ),

                  ///--------------------ON SUBMIT BUTTON------------------------
                  MyButton(
                    onTap: () {},
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
                        child: const Text('Sign Up'),
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
}
