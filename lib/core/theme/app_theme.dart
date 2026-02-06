import 'package:flutter/material.dart';
import 'app_pallete.dart';

class AppTheme {
  static get darkTheme => ThemeData.dark().copyWith(
    popupMenuTheme: const PopupMenuThemeData(
      color: AppPallete.backgroundColor
    ),
    appBarTheme: const AppBarTheme(
      actionsIconTheme: IconThemeData(color: AppPallete.whiteColor),
      backgroundColor: AppPallete.appBarColor,
      elevation: 0,
      titleTextStyle: TextStyle(
        fontFamily: 'Lato',
        fontSize: 30,
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
    ),
    tabBarTheme: const TabBarThemeData(
      labelStyle: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Lato'),
      unselectedLabelStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontFamily: 'Lato',
      ),
      indicatorColor: AppPallete.tabColor,
      labelColor: AppPallete.whiteColor,
      unselectedLabelColor: AppPallete.whiteColor,
    ),
    scaffoldBackgroundColor: AppPallete.backgroundColor,
    inputDecorationTheme: const InputDecorationTheme(
      fillColor: AppPallete.backgroundColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        textStyle: const TextStyle(fontFamily: "Lato"),
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        foregroundColor: AppPallete.whiteColor,
        elevation: 5,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      elevation: 0,
      foregroundColor: Colors.white,
      backgroundColor: AppPallete.appBarColor
      
    ),
  );
  static get lightTheme => ThemeData.light().copyWith(
    appBarTheme:const AppBarTheme(
      actionsIconTheme: IconThemeData(color: AppPallete.blackColor),
      iconTheme: IconThemeData(color: AppPallete.blackColor),
      backgroundColor: AppPallete.whatsAppColor,
      elevation: 0,
      titleTextStyle: TextStyle(
        fontFamily: 'Lato',
        fontSize: 30,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    ),
    tabBarTheme: const TabBarThemeData(
      labelStyle: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Lato'),
      unselectedLabelStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontFamily: 'Lato',
      ),
      indicatorColor: AppPallete.whiteColor,
      labelColor: AppPallete.whiteColor,
      unselectedLabelColor: AppPallete.whiteColor,
    ),
    scaffoldBackgroundColor: AppPallete.whiteColor,
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        textStyle: const TextStyle(fontFamily: "Lato"),
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        foregroundColor: Colors.white,
        elevation: 5,
      ),
    ),
    floatingActionButtonTheme:const FloatingActionButtonThemeData(
      foregroundColor: Colors.white,
      backgroundColor: AppPallete.tabColor,
    ),
  );
}
