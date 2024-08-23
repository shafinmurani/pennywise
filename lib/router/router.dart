import 'package:go_router/go_router.dart';
import 'package:pennywise/components/success.dart';
import 'package:pennywise/pages/add_income.dart';
import 'package:pennywise/pages/auth_manager.dart';

final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: "/",
      builder: (context, state) {
        return const AuthManager();
      },
    ),
    GoRoute(
      path: "/income/add",
      builder: (context, state) => const AddIncome(),
    ),
    GoRoute(
      path: "/success",
      builder: (context, state) {
        String animation = state.extra as String;
        return SuccessFulWidget(animation: animation);
      },
    ),
  ],
);
