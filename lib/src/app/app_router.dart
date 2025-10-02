import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:animations/animations.dart';
import '../app/tokens.dart';

import '../features/overview/overview_page.dart';
import '../features/resident/resident_detail_page.dart';
import '../features/support/support_page.dart';
import '../features/alerts/alerts_page.dart';
import '../shell/bottom_shell.dart';

/// App routing configuration using GoRouter
/// Centralizes navigation logic in a single configuration
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/overview', // Start on the main dashboard
    navigatorKey: GlobalKey<NavigatorState>(),
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) => BottomShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/overview',
              pageBuilder: (context, state) => _fadeThroughPage(const OverviewPage(), context),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/alerts',
              pageBuilder: (context, state) => _fadeThroughPage(const AlertsPage(), context),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/support',
              pageBuilder: (context, state) => _fadeThroughPage(const SupportPage(), context),
            ),
          ]),
        ],
      ),
      GoRoute(
        path: '/resident/:id',
        pageBuilder: (context, state) {
          final id = state.pathParameters['id']!;
          return _sharedAxisPage(ResidentDetailPage(residentId: id), context);
        },
      ),
    ],
    errorPageBuilder: (context, state) => MaterialPage(
      child: Scaffold(
        body: Center(child: Text("Route error: '${state.error}'")),
      ),
    ),
  );
});


/// Fade transition for tab changes to avoid abrupt switching
CustomTransitionPage<void> _fadeThroughPage(Widget child, BuildContext context) {
  final motion = Theme.of(context).extension<MotionTokens>() ?? const MotionTokens();
  return CustomTransitionPage<void>(
    child: child,
    transitionsBuilder: (context, animation, secondary, child) => FadeThroughTransition(
      animation: animation,
      secondaryAnimation: secondary,
      child: child,
    ),
    transitionDuration: motion.regular,
  );
}

/// Shared axis transition for detail pages to convey depth
CustomTransitionPage<void> _sharedAxisPage(Widget child, BuildContext context) {
  final motion = Theme.of(context).extension<MotionTokens>() ?? const MotionTokens();
  return CustomTransitionPage<void>(
    child: child,
    transitionsBuilder: (context, animation, secondary, child) => SharedAxisTransition(
      animation: animation,
      secondaryAnimation: secondary,
      transitionType: SharedAxisTransitionType.scaled,
      child: child,
    ),
    transitionDuration: motion.slow,
  );
}

