import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

class ServicesLocator {
  static setup() async {
    _injectBlocProviders();
  }

  static _injectBlocProviders() {}
}
