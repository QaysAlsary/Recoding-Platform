import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:recoding_platform_project/features/register/data/repo/register_repo.dart';
import 'package:recoding_platform_project/features/home/bloc/home_bloc.dart';
import 'package:recoding_platform_project/features/home/models/repo/home_repo.dart';
import 'package:recoding_platform_project/features/login/bloc/login_bloc.dart';
import 'package:recoding_platform_project/features/login/data/repo/login_repo.dart';
import 'package:recoding_platform_project/features/profile/bloc/profile_bloc.dart';
import 'package:recoding_platform_project/features/profile/bloc/toggle/bloc/toggle_bloc.dart';
import 'package:recoding_platform_project/features/profile/data/repo/user_repo.dart';
import 'package:recoding_platform_project/features/register/bloc/bloc/register_bloc.dart';
import 'package:recoding_platform_project/src/core/api/api_consumer.dart';
import 'package:recoding_platform_project/src/core/api/dio_consumer.dart';
import 'package:recoding_platform_project/src/routing/custom_navigation_observer.dart';

final getIt = GetIt.instance;

Future<void> setup() async {
  try {
    _setupCoreServices();
    _setupRepositories();
    _setupBlocs();
    getIt.registerLazySingleton<CustomNavigationObserver>(
        () => CustomNavigationObserver());
  } catch (e) {
    rethrow;
  }
}

void _setupCoreServices() {
  getIt.registerLazySingleton<Dio>(() {
    final dio = Dio();
    dio.options.connectTimeout = const Duration(seconds: 30);
    dio.options.receiveTimeout = const Duration(seconds: 30);
    dio.options.sendTimeout = const Duration(seconds: 30);
    return dio;
  });
  getIt.registerLazySingleton<ApiConsumer>(
    () => DioConsumer(dio: getIt<Dio>()),
  );
}

void _setupRepositories() {
  getIt.registerLazySingleton<UserRepo>(
    () => UserRepo(api: getIt<ApiConsumer>()),
  );
  getIt.registerLazySingleton<LoginRepository>(
    () => LoginRepository(apiConsumer: getIt<ApiConsumer>()),
  );
  getIt.registerLazySingleton<RegisterRepository>(
    () => RegisterRepository(dio: getIt<Dio>()),
  );
  getIt.registerLazySingleton<HomeRepo>(
    () => HomeRepo(api: getIt<ApiConsumer>()),
  );
}

void _setupBlocs() {
  getIt.registerFactory<ProfileBloc>(
    () => ProfileBloc(userRepo: getIt<UserRepo>()),
  );
  getIt.registerFactory<LoginBloc>(
    () => LoginBloc(loginRepository: getIt<LoginRepository>()),
  );
  getIt.registerFactory<RegisterBloc>(
    () => RegisterBloc(registerRepository: getIt<RegisterRepository>()),
  );
  getIt.registerFactory<HomeBloc>(
    () => HomeBloc(homeRepo: getIt<HomeRepo>()),
  );
  getIt.registerFactory<ToggleBloc>(
    () => ToggleBloc(),
  );
}

extension BlocAccess on GetIt {
  ProfileBloc get profileBloc => get<ProfileBloc>();
  LoginBloc get loginBloc => get<LoginBloc>();
  RegisterBloc get registerBloc => get<RegisterBloc>();
  HomeBloc get homeBloc => get<HomeBloc>();
  ToggleBloc get toggleBloc => get<ToggleBloc>();
}
