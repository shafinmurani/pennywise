import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pennywise/firebase_options.dart';
import 'package:pennywise/router/router.dart';
import 'package:pennywise/theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: theme,
      routerConfig: router,
    );
  }
}
