import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pennywise/services/auth.dart';

class DrawerComponent extends StatefulWidget {
  const DrawerComponent({super.key});

  @override
  State<DrawerComponent> createState() => _DrawerComponentState();
}

class _DrawerComponentState extends State<DrawerComponent> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xffe4e4e4),
              ),
              accountName: Text(
                "${FirebaseAuth.instance.currentUser?.displayName}",
                style: const TextStyle(color: Color(0xff1e1e1e)),
              ),
              accountEmail: Text(
                "${FirebaseAuth.instance.currentUser?.email}",
                style: const TextStyle(color: Color(0xff1e1e1e)),
              )),
          Expanded(
            child: Align(
              alignment: FractionalOffset.bottomCenter,
              child: ListTile(
                leading: const Icon(
                  Icons.logout_rounded,
                ),
                title: const Text('Logout'),
                onTap: () {
                  context.pop();
                  Auth().logout();
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
