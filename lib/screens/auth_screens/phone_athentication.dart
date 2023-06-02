import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:users/utils/colors.dart';
import 'package:users/widgets/phone_input_field.dart';

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

  @override
  void dispose() {
    phoneController.dispose();
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

                SizedBox(
                  height: size.height * 0.05,
                ),
                if (codeSended)
                  PhoneInputField(
                    controller: otpController,
                    hint: '______',
                    inputLength: 6,
                    isOtp: true,
                    focusNode: otpFocusNode,
                  ),

                SizedBox(
                  height: size.height * 0.05,
                ),

                ///--------------------ON SUBMIT BUTTON------------------------
                MyButton(
                  onTap: () {
                    if (!codeSended) {
                      _sendOTP();
                    } else {
                      _verifyOTP();
                    }
                  },
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  _sendOTP() {
    FocusScope.of(context).requestFocus(otpFocusNode);

    setState(() {
      codeSended = true;
    });
  }

  _verifyOTP() {
    setState(() {
      codeSended = false;
    });
  }
}
