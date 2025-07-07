import 'package:flutter/material.dart';

extension ConvertToMaterial on Color {
  toMaterialColor() {
    Map<int, Color> values = const {
      50: Color.fromRGBO(251, 140, 20, .1),
      100: Color.fromRGBO(251, 140, 20, .2),
      200: Color.fromRGBO(251, 140, 20, .3),
      300: Color.fromRGBO(251, 140, 20, .4),
      400: Color.fromRGBO(251, 140, 20, .5),
      500: Color.fromRGBO(251, 140, 20, .6),
      600: Color.fromRGBO(251, 140, 20, .7),
      700: Color.fromRGBO(251, 140, 20, .8),
      800: Color.fromRGBO(251, 140, 20, .9),
      900: Color.fromRGBO(251, 140, 20, 1.0),
    };
    return MaterialColor(value, values);
  }
}

extension AssetsPath on String {
  String get imageAssetPath => 'assets/images/$this';

  String get iconAssetPath => 'assets/icons/$this';
}
