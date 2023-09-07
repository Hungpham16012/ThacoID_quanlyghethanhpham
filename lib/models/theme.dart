import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:ghethanhpham_thaco/config/config.dart';

class ThemeModel {
  final lightTheme = ThemeData(
    visualDensity: VisualDensity.adaptivePlatformDensity,
    primarySwatch: Colors.pink,
    primaryColor: Config().appThemeColor,
    scaffoldBackgroundColor: Colors.grey[100],
    shadowColor: Colors.grey[200],
    brightness: Brightness.light,
    fontFamily: 'MyriadPro',
    textTheme: TextTheme(
      titleLarge: TextStyle(
        color: Config().appThemeColor,
        fontWeight: FontWeight.bold,
      ),
      titleMedium: TextStyle(color: Config().appThemeColor),
    ),
    colorScheme: ColorScheme.light(
      primary: Colors.black, //text
      secondary: Colors.grey[300]!, //text
      onPrimary: Colors.white, //card -1
      onSecondary: Colors.grey[100]!, //card -2
      // primaryVariant: Colors.grey[200]!, //card color -3
      // secondaryVariant: Color.fromARGB(255, 72, 64, 64)!, //card color -4
      surface: Colors.grey[300]!, //shadow color -1
      onBackground: Colors.grey[300]!, //loading card color
    ),
    dividerColor: Colors.grey[300],
    iconTheme: IconThemeData(color: Colors.grey[900]),
    primaryIconTheme: IconThemeData(
      color: Colors.grey[900],
    ),
    appBarTheme: AppBarTheme(
      color: Colors.white,
      elevation: 0,
      titleTextStyle: TextStyle(
        fontFamily: 'MyriadPro',
        fontSize: 18,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.7,
        color: Colors.grey[900],
      ),
      iconTheme: IconThemeData(
        color: Colors.grey[900],
      ),
      actionsIconTheme: IconThemeData(
        color: Colors.grey[900],
      ),
      centerTitle: false,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: Config().appThemeColor,
      unselectedItemColor: Colors.blueGrey[200],
    ),
    popupMenuTheme: PopupMenuThemeData(
      textStyle: TextStyle(
        fontFamily: 'MyriadPro',
        color: Colors.grey[900],
        fontWeight: FontWeight.w500,
      ),
    ),
  );

  final darkTheme = ThemeData(
    visualDensity: VisualDensity.adaptivePlatformDensity,
    primarySwatch: Colors.pink,
    primaryColor: Colors.white,
    scaffoldBackgroundColor: const Color(0xff303030),
    shadowColor: Colors.grey[850],
    brightness: Brightness.dark,
    fontFamily: 'MyriadPro',
    textTheme: const TextTheme(
      titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      titleMedium: TextStyle(color: Colors.white),
    ),
    colorScheme: ColorScheme.dark(
      primary: Colors.white, //text
      secondary: Colors.grey[200]!, //text
      onPrimary: Colors.grey[800]!, //card color -1
      onSecondary: Colors.grey[800]!, //card color -2
      // primaryVariant: Colors.grey[800]!, //card color -3
      // secondaryVariant: Colors.grey[800]!, //card color -4
      surface: const Color(0xff303030), //shadow color - 1
      onBackground: Colors.grey[800]!, //loading card color
    ),
    dividerColor: Colors.grey[300],
    iconTheme: const IconThemeData(
      color: Colors.white,
    ),
    primaryIconTheme: const IconThemeData(
      color: Colors.white,
    ),
    appBarTheme: AppBarTheme(
      color: Colors.grey[800],
      elevation: 0,
      titleTextStyle: const TextStyle(
        fontFamily: 'MyriadPro',
        fontSize: 18,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.7,
        color: Colors.white,
      ),
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
      actionsIconTheme: const IconThemeData(
        color: Colors.white,
      ),
      centerTitle: false,
      systemOverlayStyle: SystemUiOverlayStyle.light,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.grey[800],
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.grey[500],
    ),
    popupMenuTheme: const PopupMenuThemeData(
      textStyle: TextStyle(
        fontFamily: 'MyriadPro',
        color: Colors.white,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}
