import 'package:get_it/get_it.dart';

import '../../features/profile/bloc/profile_bloc.dart';

final sl = GetIt.instance;

class ServicesLocator {
  static setup() async {
    _injectBlocProviders();
  }

  static _injectBlocProviders() {
    sl.registerLazySingleton<ProfileBloc>(() => ProfileBloc());
  }
}
