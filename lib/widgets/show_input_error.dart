import 'package:flutter/material.dart';

import '../utils/fonts.dart';

class ShowInputError extends StatelessWidget {
  final String error;
  const ShowInputError({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        error,
        style: FontsProvider.errorText,
      ),
    );
  }
}
