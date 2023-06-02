import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:users/utils/colors.dart';

class LoadingCircle extends StatefulWidget {
  const LoadingCircle({super.key});

  @override
  State<LoadingCircle> createState() => _LoadingCircleState();
}

class _LoadingCircleState extends State<LoadingCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController animateController;

  @override
  void initState() {
    super.initState();

    animateController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
  }

  @override
  void dispose() {
    animateController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SpinKitRing(
      color: primaryColor,
      lineWidth: 4,
      size: 40,
      controller: animateController,
    );
  }
}
