import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pennywise/components/pages.dart';

class Navbar extends StatefulWidget {
  const Navbar({super.key});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      tabBar: CupertinoTabBar(
        backgroundColor: Colors.grey.shade100,
        border: const Border(),
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
      ),
      tabBuilder: (BuildContext context, int index) {
        return CupertinoTabView(
          builder: (BuildContext context) {
            return pages[index];
          },
        );
      },
    );
  }
}
