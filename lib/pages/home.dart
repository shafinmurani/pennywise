import 'package:flutter/material.dart';
import 'package:pennywise/components/drawer.dart';
import 'package:pennywise/components/navbar.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerComponent(),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("PennyWise"),
      ),
      body: const Navbar(),
    );
  }
}
