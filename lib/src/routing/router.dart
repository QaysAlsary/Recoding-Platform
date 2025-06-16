import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:recoding_platform_project/features/home/bloc/home_bloc.dart';
import 'package:recoding_platform_project/features/home/models/location_model.dart';
import 'package:recoding_platform_project/features/home/view/widgets/edit_marker_view.dart';
import 'package:recoding_platform_project/features/home/view/widgets/create_marker_view.dart';
import 'package:recoding_platform_project/features/home/view/widgets/marker_details.dart';
import 'package:recoding_platform_project/features/home/view/widgets/select_marker_view.dart';
import 'package:recoding_platform_project/features/login/bloc/login_bloc.dart';
import 'package:recoding_platform_project/features/login/ui/login_screen.dart';
import 'package:recoding_platform_project/features/profile/bloc/profile_bloc.dart';
import 'package:recoding_platform_project/features/profile/view/profile_view.dart';
import 'package:recoding_platform_project/features/register/bloc/bloc/register_bloc.dart';
import 'package:recoding_platform_project/features/register/ui/screens/register_screen.dart';
import 'package:recoding_platform_project/src/di/bloc_provider_wrapper.dart';
import 'package:recoding_platform_project/src/di/service_locator.dart';
import 'package:recoding_platform_project/src/routing/custom_navigation_observer.dart';
import 'package:recoding_platform_project/src/routing/routes.dart';
import '../../features/home/view/home_view.dart';
import 'fallback_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final goRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  // initialLocation: Routes.splashScreen,
  initialLocation: Routes.login,
  // initialLocation: Routes.createMarker,
  observers: [BotToastNavigatorObserver(), CustomNavigationObserver()],
  errorBuilder: (context, state) => const FallbackScreen(),
  routes: [
    GoRoute(
      path: Routes.home,
      builder: (context, state) {
        return BlocProviderWrapper<HomeBloc>(
          create: (_) => getIt<HomeBloc>(),
          child: const HomeView(),
        );
      },
    ),
    GoRoute(
      path: Routes.profile,
      builder: (context, state) {
        return BlocProviderWrapper<ProfileBloc>(
          create: (_) => getIt<ProfileBloc>()..add(LoadProfile()),
          child: const ProfileView(),
        );
      },
    ),
    GoRoute(
      path: Routes.createMarker,
      builder: (context, state) {
        final Map<String, dynamic> extra =
            state.extra as Map<String, dynamic>? ?? {};
        final double latitude = extra['latitude'] as double? ?? 0.0;
        final double longitude = extra['longitude'] as double? ?? 0.0;
        return BlocProviderWrapper<HomeBloc>(
          create: (_) => getIt<HomeBloc>(),
          child: CreateMarkerView(
            initialLatitude: latitude,
            initialLongitude: longitude,
          ),
        );
      },
    ),
    GoRoute(
      path: Routes.selectMarker,
      builder: (context, state) {
        return BlocProviderWrapper<HomeBloc>(
          create: (_) => getIt<HomeBloc>(),
          child: const SelectMarkerView(),
        );
      },
    ),
    GoRoute(
      path: Routes.editMarker,
      builder: (context, state) {
        final location = state.extra as Location;
        return BlocProviderWrapper<HomeBloc>(
          create: (_) => getIt<HomeBloc>(),
          child: EditMarkerView(location: location),
        );
      },
    ),
    GoRoute(
      path: Routes.markerDetails,
      builder: (context, state) {
        return BlocProviderWrapper<HomeBloc>(
          create: (_) => getIt<HomeBloc>(),
          child: const MarkerDetailsPanel(locationId: 3),
        );
      },
    ),
    // GoRoute(
    //   path: Routes.splashScreen,
    //   builder: (context, state) => const HomePage(),
    // ),
    GoRoute(
      path: Routes.login,
      builder: (context, state) {
        return BlocProviderWrapper<LoginBloc>(
          create: (_) => getIt<LoginBloc>(),
          child: LoginScreen(),
        );
      },
    ),

    GoRoute(
      path: Routes.register,
      builder: (context, state) {
        return BlocProviderWrapper<RegisterBloc>(
          create: (_) => getIt<RegisterBloc>(),
          child: RegisterScreen(),
        );
      },
    ),
  ],
);
