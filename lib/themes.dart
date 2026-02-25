import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppColors {
  // Light Mode Colors
  static final primaryLight = const Color.fromARGB(255, 242, 164, 46);
  static const backgroundLight = Color.fromARGB(255, 236, 237, 241);
  static const secondarybackgroundLight = Color.fromARGB(255, 224, 223, 223);
  static const textFieldBgLight = Color.fromARGB(69, 206, 206, 206);
  static const lightBlue = Colors.blue;
  static const lightOrange = Color.fromARGB(255, 250, 188, 94);
  static const lightGreen = Color.fromARGB(255, 68, 214, 92);

  // Dark Mode Colors
  static final primaryDark = const Color.fromARGB(255, 251, 223, 103);
  static const backgroundDark = Color.fromARGB(255, 21, 23, 32);
  static const secondarybackgroundDark = Color.fromARGB(255, 50, 54, 69);
  static const darkBlue = Color.fromARGB(255, 34, 143, 190);
  static const darkYellow = Color.fromARGB(255, 251, 223, 103);
  static const darkOrange = Color.fromARGB(255, 235, 129, 73);
  static const darkGreen = Color.fromARGB(255, 153, 210, 82);
}

class AppThemes {
  // Light Theme Configuration
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.backgroundLight,
      brightness: Brightness.light,
      primary: AppColors.primaryLight,
    ),

    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        color: Colors.black87,
        fontFamily: 'DroidArabicKufi',
      ),
      bodyMedium: TextStyle(
        fontSize: 18,
        color: Colors.black,
        fontFamily: 'DroidArabicKufi',
      ),
      bodyLarge: TextStyle(
        fontSize: 22,
        color: Colors.black,
        fontFamily: 'DroidArabicKufi',
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.black,
    ),
    cardTheme: const CardThemeData(
      color: AppColors.secondarybackgroundLight,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: AppColors.secondarybackgroundLight,
    ),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: AppColors.textFieldBgLight,
      labelStyle: TextStyle(color: Colors.black.withAlpha(147)),
      hintStyle: TextStyle(color: Colors.grey),
    ),
    scaffoldBackgroundColor: AppColors.backgroundLight,
  );
  // Dark Theme Configuration
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.backgroundDark,
      brightness: Brightness.dark,
      primary: AppColors.primaryDark,
    ),
    scaffoldBackgroundColor: AppColors.backgroundDark,
    textTheme: const TextTheme(
      // displayLarge: TextStyle(
      //   fontSize: 32,
      //   fontWeight: FontWeight.bold,
      //   color: Colors.white,
      // ),
      bodySmall: TextStyle(
        fontSize: 14,
        color: Colors.white60,
        fontFamily: 'DroidArabicKufi',
      ),
      bodyMedium: TextStyle(
        fontSize: 18,
        color: Colors.white70,
        fontFamily: 'DroidArabicKufi',
      ),
      bodyLarge: TextStyle(
        fontSize: 22,
        color: Colors.white,
        fontFamily: 'DroidArabicKufi',
        fontWeight: FontWeight.w900,
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.white,
    ),
    cardTheme: const CardThemeData(
      color: AppColors.secondarybackgroundDark,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      // backgroundColor: AppColors.secondarybackgroundDark255,
    ),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: Color.fromARGB(50, 0, 0, 0),

      labelStyle: TextStyle(color: Colors.white.withAlpha(147)),
      hintStyle: TextStyle(color: Colors.grey),
    ),
  );

  static Color getPrimaryBg(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return isDark ? AppColors.backgroundDark : AppColors.backgroundLight;
  }

  static Color getPrimaryColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? AppColors.primaryDark : AppColors.primaryLight;
  }

  static Color getSecondaryBg(BuildContext context) {
    return isDarkMode(context)
        ? AppColors.secondarybackgroundDark
        : AppColors.secondarybackgroundLight;
  }

  static Color getYellow(BuildContext context) {
    return isDarkMode(context) ? AppColors.darkYellow : AppColors.darkYellow;
  }

  static Color getOrange(BuildContext context) {
    return isDarkMode(context) ? AppColors.darkOrange : AppColors.lightOrange;
  }

  static Color getBlue(BuildContext context) {
    return isDarkMode(context) ? AppColors.darkBlue : AppColors.lightBlue;
  }

  static Color getGreen(BuildContext context) {
    return isDarkMode(context) ? AppColors.darkGreen : AppColors.lightGreen;
  }

  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }
}
