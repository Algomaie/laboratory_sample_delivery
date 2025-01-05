import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class ThemeModel {
  final lightMode = ThemeData(
    primarySwatch: Colors.grey,
    primaryColor: HexColor('#233c4b'),
    iconTheme: IconThemeData(color: HexColor('#233c4b')),
    fontFamily: 'Cairo',
    scaffoldBackgroundColor: HexColor('#233c4b'),
    brightness: Brightness.light,
    primaryColorLight: Colors.white,
    secondaryHeaderColor: Colors.grey[600],
    shadowColor: Colors.grey[200],
    // backgroundColor: HexColor('#233c4b'),
    appBarTheme: AppBarTheme(
      elevation: 0,
      iconTheme: IconThemeData(
        color: Colors.grey[900],
      ),
      actionsIconTheme: const IconThemeData(color: Colors.white),
    ),

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white70,
    ),
  );
}
