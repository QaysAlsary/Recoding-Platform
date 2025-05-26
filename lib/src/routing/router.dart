import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:recoding_platform_project/features/login/bloc/login_bloc.dart';
import 'package:recoding_platform_project/features/login/data/repo/login_repo.dart';
import 'package:recoding_platform_project/features/login/ui/login_screen.dart';
import 'package:recoding_platform_project/src/di/service_locator.dart';
import 'package:recoding_platform_project/src/routing/custom_navigation_observer.dart';
import 'package:recoding_platform_project/src/routing/routes.dart';
import 'fallback_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final goRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: Routes.login,
  observers: [BotToastNavigatorObserver(), CustomNavigationObserver()],
  errorBuilder: (context, state) => const FallbackScreen(),
  routes: [
    // GoRoute(
    //   path: Routes.splashScreen,
    //   builder: (context, state) => const HomePage(),
    // ),
    GoRoute(
      path: Routes.login,
      builder: (context, state) => BlocProvider(
        create: (_) => getIt<LoginBloc>(),
        child: LoginScreen(),
      ),
    ),

    // Add more routes here
  ],
);
