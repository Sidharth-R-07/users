import 'package:flutter/material.dart';

import '../utils/colors.dart';

class SaveButton extends StatelessWidget {
  final Widget child;
  final Function() onTap;
  const SaveButton({super.key, required this.child, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: InkWell(
        onTap: onTap,
        child: Container(
            alignment: Alignment.center,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: const BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.all(Radius.circular(8))),
            child: child),
      ),
    );
  }
}
