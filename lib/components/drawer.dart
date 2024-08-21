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
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              accountName:
                  Text("${FirebaseAuth.instance.currentUser?.displayName}"),
              accountEmail:
                  Text("${FirebaseAuth.instance.currentUser?.email}")),
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
