import 'package:go_router/go_router.dart';
import 'package:pennywise/pages/login.dart';

final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: "/",
      builder: (context, state) => const Login(),
    )
  ],
);
