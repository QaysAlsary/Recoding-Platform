import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maptiler_flutter/maptiler_flutter.dart';
import 'package:recoding_platform_project/features/home/bloc/home_bloc.dart';
import 'package:recoding_platform_project/features/home/models/repo/home_repo.dart';
import 'package:recoding_platform_project/features/profile/bloc/profile_bloc.dart';
import 'package:recoding_platform_project/src/di/app_initializer.dart';
import 'package:recoding_platform_project/src/di/service_locator.dart';
import 'package:recoding_platform_project/src/routing/router.dart';
import 'package:recoding_platform_project/src/themes/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await AppInitializer.init();
    MapTilerConfig.setApiKey('tBWczgtWITcq8rfJeIuA');
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
              create: (context) => getIt<ProfileBloc>()..add(LoadProfile()),
            ),
          ],
          child: MaterialApp.router(
            title: 'Recoding Platform',
            theme: appTheme,
            builder: (context, child) {
              child = BotToastInit()(context, child);
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                child: child!,
              );
            },
            routerConfig: goRouter,
            debugShowCheckedModeBanner: false,
          ),
        );
      },
    );
  }
}
