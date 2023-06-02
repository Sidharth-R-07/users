import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/fonts.dart';

class PhoneInputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final int inputLength;
  FocusNode? focusNode;

  bool isOtp;
  PhoneInputField(
      {super.key,
      required this.controller,
      required this.hint,
      required this.inputLength,
      this.isOtp = false,
      this.focusNode});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(
              5.0,
              5.0,
            ),
            blurRadius: 10.0,
            spreadRadius: 2.0,
          ),
          BoxShadow(
            color: Colors.white,
            offset: Offset(0.0, 0.0),
            blurRadius: 0.0,
            spreadRadius: 0.0,
          ),
        ],
      ),
      child: Row(
        children: [
          if (!isOtp)
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                '+91',
                style: FontsProvider.hintText
                    .copyWith(color: Colors.grey.shade600),
              ),
            ),
          Expanded(
            child: TextFormField(
              controller: controller,
              textAlign: TextAlign.center,
              inputFormatters: [
                LengthLimitingTextInputFormatter(inputLength),
              ],
              focusNode: focusNode,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.done,
              style: FontsProvider.headingMedium.copyWith(
                  color: Colors.grey.shade700, letterSpacing: isOtp ? 22 : 5),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hint,
                hintStyle: FontsProvider.hintText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
