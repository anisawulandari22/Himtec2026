import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../providers/auth_provider.dart';
import '../../presentation/screens/auth/login_screen.dart';
import '../../presentation/screens/auth/register_screen.dart';
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

  static GoRouter createRouter(AuthProvider authProvider) {
    return GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: authProvider.isAuthenticated ? '/home' : '/login',
      refreshListenable: authProvider,
      debugLogDiagnostics: false,
      redirect: (context, state) {
        final isLoggedIn = authProvider.isAuthenticated;
        final isAuthRoute = state.matchedLocation == '/login' || state.matchedLocation == '/register';

        if (!isLoggedIn && !isAuthRoute) {
          return '/login';
        }

        if (isLoggedIn && isAuthRoute) {
          return '/home';
        }

        return null;
      },
      routes: [
        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          path: '/login',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: LoginScreen(),
          ),
        ),
        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          path: '/register',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: RegisterScreen(),
          ),
        ),
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
}
