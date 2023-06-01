import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loader extends StatefulWidget {
  const Loader({super.key});

  @override
  State<Loader> createState() => _LoaderState();
}

class _LoaderState extends State<Loader> with SingleTickerProviderStateMixin {
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
    return SpinKitThreeBounce(
      color: Colors.white,
      size: 30,
      controller: animateController,
    );
  }
}
