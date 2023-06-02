import 'package:flutter/material.dart';

import '../utils/fonts.dart';

class InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final TextInputAction textInputAction;
  final TextInputType keyBoard;
  bool obscure;

  InputField(
      {super.key,
      required this.controller,
      required this.hint,
      required this.keyBoard,
      required this.textInputAction,
      this.obscure = false});

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
      child: TextFormField(
        controller: controller,
        keyboardType: keyBoard,
        obscureText: obscure,
        textInputAction: textInputAction,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: FontsProvider.hintText,
        ),
      ),
    );
  }
}
