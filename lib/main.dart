import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:maptiler_flutter/maptiler_flutter.dart';
import 'package:recoding_platform_project/features/home/bloc/home_bloc.dart';

import 'package:recoding_platform_project/features/profile/bloc/profile_bloc.dart';
import 'package:recoding_platform_project/features/profile/bloc/toggle/bloc/toggle_bloc.dart';
import 'package:recoding_platform_project/src/di/app_initializer.dart';
import 'package:recoding_platform_project/src/di/service_locator.dart';
import 'package:recoding_platform_project/src/routing/router.dart';
import 'package:recoding_platform_project/src/themes/app_theme.dart';
// import 'package:recoding_platform_project/features/home/services/favorites_manager.dart';
import 'package:recoding_platform_project/features/home/services/search_analytics.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Load environment variables
    await dotenv.load(fileName: ".env");

    await AppInitializer.init();

    // Set MapTiler API key from environment variable
    final apiKey = dotenv.env['MAPTILER_API_KEY'];
    if (apiKey != null) {
      MapTilerConfig.setApiKey(apiKey);
    } else {
      debugPrint('Warning: MAPTILER_API_KEY not found in .env file');
    }

    // Initialize search services
    // await FavoritesManager.init();
    await SearchAnalytics.init();
  } catch (e) {
    debugPrint('Error during initialization: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(428, 926),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<HomeBloc>(
              create: (context) => getIt<HomeBloc>(),
            ),
            BlocProvider<ProfileBloc>(
              create: (context) => getIt<ProfileBloc>(),
            ),
            BlocProvider<ToggleBloc>(
              create: (context) => getIt<ToggleBloc>(),
            ),
          ],
          child: MaterialApp.router(
            title: 'Recoding Platform',
            theme: appTheme,
            builder: (context, child) {
              child = BotToastInit()(context, child);
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaleFactor: 1.0,
                  boldText: false,
                ),
                child: child,
              );
            },
            routerConfig: goRouter,
            debugShowCheckedModeBanner: false,
            showPerformanceOverlay: false,
            showSemanticsDebugger: false,
            checkerboardRasterCacheImages: false,
            checkerboardOffscreenLayers: false,
            localizationsDelegates: const [
              // Add localization delegates if needed
            ],
            supportedLocales: const [
              Locale('en', 'US'),
              Locale('ar', 'SA'),
            ],
          ),
        );
      },
    );
  }
}
