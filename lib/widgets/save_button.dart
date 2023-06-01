import 'package:flutter/material.dart';

import '../utils/colors.dart';
import '../utils/fonts.dart';

class SaveButton extends StatelessWidget {
  final String title;
  final Function() onTap;
  const SaveButton({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: const BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.all(Radius.circular(8))),
        child: Text(
          title,
          style: FontsProvider.whiteMediumText,
        ),
      ),
    );
  }
}
