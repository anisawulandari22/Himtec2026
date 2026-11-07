import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/screens/drawer/help_screen.dart';
import '../../presentation/screens/drawer/history_screen.dart';
import '../../presentation/screens/drawer/settings_screen.dart';
import '../../presentation/screens/home/home_screen.dart';
import '../../presentation/screens/main_wrapper.dart';
import '../../presentation/screens/market/market_screen.dart';
import '../../presentation/screens/pest/pest_screen.dart';
import '../../presentation/screens/profile/profile_screen.dart';
import '../../presentation/screens/scan/disease_scan_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/home',
    debugLogDiagnostics: false,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainWrapper(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: HomeScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/pest',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: PestScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/market',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: MarketScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: ProfileScreen(),
                ),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/history',
        builder: (context, state) => const HistoryScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/help',
        builder: (context, state) => const HelpScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/scan',
        builder: (context, state) => const DiseaseScanScreen(),
      ),
    ],
  );
}
