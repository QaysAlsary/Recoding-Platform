import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:recoding_platform_project/features/profile/view/profile_view.dart';
import 'package:recoding_platform_project/src/routing/custom_navigation_observer.dart';
import 'package:recoding_platform_project/src/routing/routes.dart';
import '../../features/home/view/home_view.dart';
import 'fallback_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final goRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  // initialLocation: Routes.splashScreen,
  initialLocation: Routes.home,
  observers: [BotToastNavigatorObserver(), CustomNavigationObserver()],
  errorBuilder: (context, state) => const FallbackScreen(),
  routes: [
    GoRoute(
        path: Routes.profile, builder: (context, state) => const ProfileView()),
    GoRoute( path: Routes.home, builder: (context, state) => const HomeView())

    // GoRoute(
    //   path: Routes.splashScreen,
    //   builder: (context, state) => const HomePage(),
    // ),
    // GoRoute(
    //   path: Routes.login,
    //   builder: (context, state) => const LoginPage(),
    // ),
    // Add more routes here
  ],
);
