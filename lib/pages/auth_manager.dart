import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pennywise/pages/home.dart';
import 'package:pennywise/pages/login.dart';

class AuthManager extends StatefulWidget {
  const AuthManager({super.key});

  @override
  State<AuthManager> createState() => _AuthManagerState();
}

class _AuthManagerState extends State<AuthManager> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // user logged in
          if (snapshot.hasData) {
            return const Home();
            // user is NOT logged in
          } else {
            return const Login();
          }
        },
      ),
    );
  }
}
