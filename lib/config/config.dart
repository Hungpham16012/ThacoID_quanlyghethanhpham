import 'package:flutter/material.dart';

class Config {
  static const appName = "Ghế thành phẩm";
  static const supportEmail = "phamvanhung3@thaco.com.vn";
  static const apiUrl = "http://117.2.133.128:81";

  //app theme color
  final Color appThemeColor = const Color(0xFF00529C);
  final Color buttonColor = const Color(0xFF0469B9);

  // mau isNemGhe
  final Color nemAoTrue = const Color.fromARGB(255, 42, 9, 142);
  final Color nemAoFalse = const Color.fromARGB(255, 6, 110, 4);
  final Color defaultSelected = Colors.black;
  final Color selected = const Color(0xFF00529C);
  final Color buttonFalse = Color.fromARGB(255, 200, 85, 77);

  // Icons
  static const String appIcon = 'assets/images/icon.png';
  static const String logo = 'assets/images/logo.png';
  static const String logoId = 'assets/images/logoId.png';
  static const String logoIdFull = 'assets/images/logoIdFull.png';
  static const String splash = 'assets/images/splash.png';

  // languages
  static const List<String> languages = ['English', 'Tiếng Việt'];
}
