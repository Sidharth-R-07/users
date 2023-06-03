import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:users/screens/add_user_screen.dart';
import 'package:users/utils/colors.dart';
import 'package:users/utils/methods.dart';
import 'package:users/widgets/phone_input_field.dart';
import 'package:users/widgets/show_input_error.dart';

import '../../providers/auth_provider.dart';
import '../../utils/fonts.dart';
import '../../widgets/loader.dart';
import '../../widgets/my_button.dart';

class PhoneAuthenticationScreen extends StatefulWidget {
  const PhoneAuthenticationScreen({super.key});

  @override
  State<PhoneAuthenticationScreen> createState() =>
      _PhoneAuthenticationScreenState();
}

class _PhoneAuthenticationScreenState extends State<PhoneAuthenticationScreen> {
  final phoneController = TextEditingController();
  final otpController = TextEditingController();

  FocusNode otpFocusNode = FocusNode();

  bool isLoading = false;
  bool codeSended = false;

  String phoneValidationText = '';
  String otpValidationText = '';

  int countDownSec = 60;

  late Timer timer;

  @override
  void dispose() {
    phoneController.dispose();
    otpController.dispose();
    timer.cancel();
    otpFocusNode.dispose();

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: size.height * 0.04,
                ),
                IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: primaryColor,
                    )),
                SizedBox(
                  height: size.height * 0.04,
                ),

                ///---------------------TITLE -----------------------------------------
                Text(
                  'Enter your\nmobile number',
                  style: FontsProvider.titleLarge,
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                Center(
                  child: Text(
                    "We have to sent the code verication to\nYour mobile number",
                    style: FontsProvider.hintText,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),

                ///--------------------TEXT INPUT FEILD SECTIONS------------------------
                PhoneInputField(
                  controller: phoneController,
                  hint: 'Phone number',
                  inputLength: 10,
                ),
                ShowInputError(error: phoneValidationText),
                SizedBox(
                  height: size.height * 0.03,
                ),
                if (codeSended)
                  PhoneInputField(
                    controller: otpController,
                    hint: '______',
                    inputLength: 6,
                    isOtp: true,
                    focusNode: otpFocusNode,
                  ),
                if (codeSended) ShowInputError(error: otpValidationText),

                SizedBox(
                  height: size.height * 0.03,
                ),

                ///--------------------ON SUBMIT BUTTON------------------------
                MyButton(
                  onTap: () => _submitFn(authProvider),
                  child: isLoading
                      ? const Loader()
                      : Text(
                          codeSended ? 'Verify Otp' : 'Send Code',
                          style: FontsProvider.whiteMediumText,
                        ),
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),

                if (codeSended)
                  Center(
                    child: Text(
                      "Haven't recieved the verification code?",
                      style: FontsProvider.hintText,
                      textAlign: TextAlign.center,
                    ),
                  ),
                SizedBox(
                  height: size.height * 0.001,
                ),

                if (codeSended)
                  Visibility(
                    visible: countDownSec != 0,
                    child: Center(
                      child: Text(
                        "00:$countDownSec",
                        style:
                            FontsProvider.headingMedium.copyWith(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                if (codeSended)
                  Visibility(
                    visible: countDownSec == 0,
                    child: Center(
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          'Resend',
                          style: FontsProvider.headingMedium
                              .copyWith(fontSize: 16),
                        ),
                      ),
                    ),
                  ),

                SizedBox(
                  height: size.height * 0.03,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _sendOTP(AuthProvider authProvider) async {
    phoneValidation(phoneController.text.trim());

    if (phoneValidationText.isNotEmpty) {
      return;
    }
    setState(() {
      isLoading = true;
    });
    await authProvider
        .signInWithPhone(phoneNumber: '+91${phoneController.text.trim()}')
        .then((_) {
      setState(() {
        isLoading = false;
        codeSended = true;
      });

      startTimer();
      FocusScope.of(context).requestFocus(otpFocusNode);
    });
  }

  _verifyOTP(AuthProvider authProvider) {
    otpValidation(otpController.text.trim());

    if (otpValidationText.isNotEmpty) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    authProvider.verifyOTP(otp: otpController.text.trim()).then((result) {
      if (result == 'Sucessfull') {
        timer.cancel();
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const AddUserScreen(),
        ));
        showToast('Sign In Successfull');
      } else {
        showToast(result);
      }
    });
    setState(() {
      isLoading = false;
    });
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (countDownSec == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          if (mounted) {
            setState(() {
              countDownSec--;
            });
          }
        }

        // log('TIMER:$countDownSec');
      },
    );
  }

  void phoneValidation(String val) {
    if (val.isEmpty) {
      setState(() {
        phoneValidationText = 'Please enter phone number';
      });
    } else if (int.tryParse(val) == null) {
      setState(() {
        phoneValidationText = 'Only Number are allowed';
      });
    } else if (val.length != 10) {
      setState(() {
        phoneValidationText = 'Please enter valid phone number';
      });
    } else {
      setState(() {
        phoneValidationText = '';
      });
    }
  }

  void otpValidation(String val) {
    if (val.isEmpty) {
      setState(() {
        otpValidationText = 'Please enter OTP';
      });
    } else if (int.tryParse(val) == null) {
      setState(() {
        phoneValidationText = 'Only Number are allowed';
      });
    } else if (val.length != 6) {
      setState(() {
        otpValidationText = 'Please enter valid OTP';
      });
    } else {
      setState(() {
        otpValidationText = '';
      });
    }
  }

  _submitFn(AuthProvider authProvider) {
    phoneValidation(phoneController.text.trim());
    otpValidation(otpController.text.trim());

    if (!codeSended) {
      _sendOTP(authProvider);
    } else {
      _verifyOTP(authProvider);
    }
  }
}
