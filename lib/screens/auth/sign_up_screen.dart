import 'package:flutter/material.dart';
import 'package:users/screens/auth/sign_in_screen.dart';

import '../../utils/fonts.dart';
import '../../widgets/input_field.dart';
import '../../widgets/loader.dart';
import '../../widgets/my_button.dart';

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
                    'Sign Up',
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
                  // ShowInputError(error: nameValidationText),
                  SizedBox(
                    height: size.height * 0.01,
                  ),
                  InputField(
                    controller: passwordController,
                    hint: 'password',
                    keyBoard: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.next,
                  ),
                  //  ShowInputError(error: emailValidationText),
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
                  //  ShowInputError(error: emailValidationText),
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
                        "Already have an account?",
                        style: FontsProvider.hintText,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const SignInScreen(),
                          ));
                        },
                        child: const Text('Sign In'),
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
