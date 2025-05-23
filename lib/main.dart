import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recoding_platform_project/src/di/app_initializer.dart';
import 'package:recoding_platform_project/src/di/service_locator.dart';
import 'package:recoding_platform_project/src/routing/router.dart';
import 'package:recoding_platform_project/src/themes/app_theme.dart';

import 'features/profile/bloc/profile_bloc.dart';

void main() async {
  await AppInitializer.init();
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
        builder: (
          BuildContext context,
          Widget? child,
        ) =>
            MultiBlocProvider(
              providers: [
                BlocProvider<ProfileBloc>(
                  create: (_) => sl<ProfileBloc>(),
                ),
              ],
              child: MaterialApp.router(
                title: 'Recoding Platform',
                theme: appTheme,
                builder: BotToastInit(),
                routerConfig: goRouter,
                debugShowCheckedModeBanner: false,
              ),
            ));
  }
}
