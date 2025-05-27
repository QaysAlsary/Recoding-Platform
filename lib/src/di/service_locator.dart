import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:recoding_platform_project/features/Register/data/repo/Register_repo.dart';
import 'package:recoding_platform_project/features/login/bloc/login_bloc.dart';
import 'package:recoding_platform_project/features/login/data/repo/login_repo.dart';
import 'package:recoding_platform_project/features/register/bloc/bloc/register_bloc.dart';

final getIt = GetIt.instance;

void setup() {
  getIt.registerLazySingleton<Dio>(() => Dio());
  getIt.registerLazySingleton<LoginRepository>(
      () => LoginRepository(dio: getIt<Dio>()));
  getIt.registerFactory<LoginBloc>(
      () => LoginBloc(loginRepository: getIt<LoginRepository>()));

  getIt.registerLazySingleton<RegisterRepository>(
      () => RegisterRepository(dio: getIt<Dio>()));
  getIt.registerFactory<RegisterBloc>(
      () => RegisterBloc(registerRepository: getIt<RegisterRepository>()));
}
