import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class SuccessFulWidget extends StatefulWidget {
  final String animation;
  const SuccessFulWidget({super.key, required this.animation});

  @override
  State<SuccessFulWidget> createState() => _SuccessFulWidgetState();
}

class _SuccessFulWidgetState extends State<SuccessFulWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController lottieController;
  @override
  void initState() {
    super.initState();
    lottieController = AnimationController(
      vsync: this,
    );

    lottieController.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        Timer(const Duration(seconds: 1), () {});
        context.go('/');
        lottieController.reset();
      }
    });
  }

  @override
  void dispose() {
    lottieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Lottie.asset(
        widget.animation,
        controller: lottieController,
        onLoaded: (composition) {
          lottieController.duration = composition.duration;
          lottieController.forward();
        },
        repeat: false,
      )),
    );
  }
}
