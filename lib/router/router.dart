import 'package:go_router/go_router.dart';
import 'package:pennywise/pages/auth_manager.dart';

final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: "/",
      builder: (context, state) => const AuthManager(),
    )
  ],
);
