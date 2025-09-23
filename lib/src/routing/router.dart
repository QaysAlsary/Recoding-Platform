import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:recoding_platform_project/features/home/bloc/home_bloc.dart';
import 'package:recoding_platform_project/features/home/models/location_model.dart';
import 'package:recoding_platform_project/features/home/models/marker_model.dart';
import 'package:recoding_platform_project/features/home/view/widgets/edit_marker_view.dart';
import 'package:recoding_platform_project/features/home/view/widgets/create_marker_view.dart';
import 'package:recoding_platform_project/features/home/view/widgets/marker_details.dart';
import 'package:recoding_platform_project/features/login/bloc/login_bloc.dart';
import 'package:recoding_platform_project/features/login/ui/login_screen.dart';
import 'package:recoding_platform_project/features/profile/bloc/profile_bloc.dart';
import 'package:recoding_platform_project/features/profile/view/profile_view.dart';
import 'package:recoding_platform_project/features/profile/view/widgets/change_email.dart';
import 'package:recoding_platform_project/features/profile/view/widgets/email_verfication.dart';
import 'package:recoding_platform_project/features/profile/view/widgets/success_change.dart';
import 'package:recoding_platform_project/features/profile/view/widgets/change_password.dart';
import 'package:recoding_platform_project/features/register/bloc/bloc/register_bloc.dart';
import 'package:recoding_platform_project/features/register/ui/screens/register_screen.dart';
import 'package:recoding_platform_project/features/register/ui/widgets/verify_email_reg.dart';
import 'package:recoding_platform_project/src/di/bloc_provider_wrapper.dart';
import 'package:recoding_platform_project/src/di/service_locator.dart';
import 'package:recoding_platform_project/src/di/session.dart';
import 'package:recoding_platform_project/src/routing/custom_navigation_observer.dart';
import 'package:recoding_platform_project/src/routing/routes.dart';
import '../../features/home/view/home_view.dart';
import 'fallback_screen.dart';
import 'package:recoding_platform_project/src/core/storage/secure_storage_service.dart';
import 'package:recoding_platform_project/features/login/ui/widgets/password_reset.dart';
import 'package:recoding_platform_project/features/login/ui/widgets/verify_email.dart';
import 'package:recoding_platform_project/features/login/ui/widgets/reset_pass.dart';
import 'package:recoding_platform_project/features/login/ui/widgets/success.dart';
import 'package:recoding_platform_project/features/home/view/widgets/verify_email.dart';
import 'package:recoding_platform_project/features/home/view/widgets/change_pass.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final goRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: Routes.home,
  observers: [BotToastNavigatorObserver(), getIt<CustomNavigationObserver>()],
  errorBuilder: (context, state) => const FallbackScreen(),
  redirect: (context, state) async {
    final token = await SecureStorageService.getUserToken();
    final sessionToken = SessionManager().token;
    final isLoggedIn = (token != null) || (sessionToken != null);

    final isLoginRoute = state.matchedLocation == Routes.login;
    final isRegisterRoute = state.matchedLocation == Routes.register;
    final isPasswordResetRoute = state.matchedLocation == Routes.passwordReset;
    final isResetPasswordRoute = state.matchedLocation == Routes.resetPass;
    final isVerifyEmailRoute = state.matchedLocation == Routes.verifyEmail;
    final isSuccessRoute = state.matchedLocation == Routes.success;
    final isVerifyEmailRegRoute =
        state.matchedLocation == Routes.verifyEmailReg;

    // If we have a token and we're on login/register, redirect to home
    if ( token != null && (isLoginRoute || isRegisterRoute)) {
      return Routes.home;
    }

    // If we don't have a token and we're not on login/register/passwordReset, redirect to login
    if (!isLoggedIn &&
        !isLoginRoute &&
        !isRegisterRoute &&
        !isPasswordResetRoute &&
        !isResetPasswordRoute &&
        !isVerifyEmailRoute &&
        !isSuccessRoute &&
        !isVerifyEmailRegRoute) {
      return Routes.login;
    }

    // No redirection needed
    return null;
  },
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
      path: Routes.editMarker,
      builder: (context, state) {
        final extra = state.extra;
        Location? location;
        if (extra is Location) {
          location = extra;
        } else if (extra is Map<String, dynamic> &&
            extra['location'] is Location) {
          location = extra['location'] as Location;
        }
        if (location == null) {
          return const FallbackScreen();
        }
        return EditMarkerView(location: location);
        // BlocProviderWrapper<HomeBloc>(
        //   create: (_) => getIt<HomeBloc>(),
        //   child: EditMarkerView(location: location),
        // );
      },
    ),
    GoRoute(
      path: Routes.markerDetails,
      builder: (context, state) {
        // Extract extra and locationId from state.extra
        final Map<String, dynamic> extra =
            state.extra as Map<String, dynamic>? ?? {};
        final MarkerData marker = extra['marker'] as MarkerData;
        return BlocProvider.value(
          value: context.read<HomeBloc>(),
          child: MarkerDetailsPanel(marker: marker),
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
    GoRoute(
      path: Routes.emailVerification,
      builder: (context, state) {
        String email = '';
        if (state.extra is String) {
          email = state.extra as String;
        } else if (state.extra is Map &&
            (state.extra as Map).containsKey('email')) {
          email = (state.extra as Map)['email'] as String? ?? '';
        }
        return EmailVerificationScreen(email: email);
      },
    ),
    GoRoute(
      path: Routes.successChange,
      builder: (context, state) {
        final Map<String, dynamic> extra =
            state.extra as Map<String, dynamic>? ?? {};
        final String title = extra['title'] as String? ?? 'Success';
        final String subtitle =
            extra['subtitle'] as String? ?? 'Operation completed successfully';
        final String? nextRoute = extra['nextRoute'] as String?;
        return SuccessChangeScreen(
          title: title,
          subtitle: subtitle,
          nextRoute: nextRoute,
        );
      },
    ),
    GoRoute(
      path: Routes.changePassword,
      builder: (context, state) {
        return const ChangePasswordScreen();
      },
    ),
    GoRoute(
      path: Routes.passwordReset,
      builder: (context, state) {
        return BlocProviderWrapper<LoginBloc>(
          create: (_) => getIt<LoginBloc>(),
          child: PasswordReset(),
        );
      },
    ),
    GoRoute(
      path: Routes.verifyEmail,
      builder: (context, state) {
        String email = '';
        if (state.extra is String) {
          email = state.extra as String;
        } else if (state.extra is Map &&
            (state.extra as Map).containsKey('email')) {
          email = (state.extra as Map)['email'] as String? ?? '';
        }

        return BlocProviderWrapper<LoginBloc>(
          create: (_) => getIt<LoginBloc>(),
          child: VerifyEmail(email: email),
        );
      },
    ),
    GoRoute(
      path: Routes.verifyEmailReg,
      builder: (context, state) {
        String email = '';
        if (state.extra is String) {
          email = state.extra as String;
        } else if (state.extra is Map &&
            (state.extra as Map).containsKey('email')) {
          email = (state.extra as Map)['email'] as String? ?? '';
        }
        return BlocProviderWrapper<RegisterBloc>(
          create: (_) => getIt<RegisterBloc>(),
          child: VerifyEmailReg(email: email),
        );
      },
    ),
    GoRoute(
      path: Routes.resetPass,
      builder: (context, state) {
        String email = '';
        if (state.extra is String) {
          email = state.extra as String;
        } else if (state.extra is Map &&
            (state.extra as Map).containsKey('email')) {
          email = (state.extra as Map)['email'] as String? ?? '';
        }
        return BlocProviderWrapper<LoginBloc>(
          create: (_) => getIt<LoginBloc>(),
          child: ResetPass(email: email),
        );
      },
    ),
    GoRoute(
      path: Routes.success,
      builder: (context, state) {
        final Map<String, dynamic> extra =
            state.extra as Map<String, dynamic>? ?? {};
        final String title = extra['title'] as String? ?? 'Success';
        final String subtitle =
            extra['subtitle'] as String? ?? 'Operation completed successfully';
        final String? nextRoute = extra['nextRoute'] as String?;
        return Success(
          title: title,
          subtitle: subtitle,
          nextRoute: nextRoute,
        );
      },
    ),
    GoRoute(
      path: Routes.changeEmail,
      builder: (context, state) {
        return const ChangeEmailScreen();
      },
    ),
    GoRoute(
      path: Routes.verifyEmailHome,
      builder: (context, state) {
        return BlocProviderWrapper<ProfileBloc>(
          create: (_) => getIt<ProfileBloc>(),
          child: const VerifyEmailHomeScreen(),
        );
      },
    ),
    GoRoute(
      path: Routes.changePasswordHome,
      builder: (context, state) {
        return BlocProviderWrapper<ProfileBloc>(
          create: (_) => getIt<ProfileBloc>(),
          child: const ChangePassHomeScreen(),
        );
      },
    ),
  ],
);
