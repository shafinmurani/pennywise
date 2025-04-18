import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pennywise/components/drawer.dart';
import 'package:pennywise/pages/expenses.dart';
import 'package:pennywise/pages/income.dart';
import 'package:pennywise/pages/statistics.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  List<Widget> pages = [
    Income(key: ValueKey(Random().nextInt(255))),
    Expenses(key: ValueKey(Random().nextInt(255))),
    Statistics(key: ValueKey(Random().nextInt(255))),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerComponent(),
      appBar: AppBar(
        backgroundColor: const Color(0xffe4e4e4),
        title: const Text("XerØ"),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xffe4e4e4),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.money_dollar_circle_fill),
            label: 'Income',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.payments_rounded),
            label: 'Expenses',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.graph_square_fill),
            label: 'Statistics',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xff1e1e1e),
        onTap: _onItemTapped,
      ),
      body: pages[_selectedIndex],
    );
  }
}
