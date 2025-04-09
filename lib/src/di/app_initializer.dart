import 'package:flutter/cupertino.dart';
import 'package:recoding_platform_project/src/di/service_locator.dart';

abstract class AppInitializer {
  static init() async {
    WidgetsFlutterBinding.ensureInitialized();

    /// dependency injection
    await ServicesLocator.setup();
  }
}
