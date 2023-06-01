import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:users/utils/colors.dart';

class LazyLoading extends StatefulWidget {
  const LazyLoading({super.key});

  @override
  State<LazyLoading> createState() => _LazyLoadingState();
}

class _LazyLoadingState extends State<LazyLoading>
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
