import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:pennywise/services/auth.dart';
import 'package:sign_in_button/sign_in_button.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
        title: const Text("PennyWise"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Lottie.asset("assets/login_animation.json"),
            const Gap(10),
            SignInButton(
              Buttons.google,
              text: "Continue with Google",
              onPressed: () {
                Auth().loginWithGoogle().then((res) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(res),
                      duration: const Duration(seconds: 1),
                      showCloseIcon: true,
                    ),
                  );
                });
              },
            )
          ],
        ),
      ),
    );
  }
}
