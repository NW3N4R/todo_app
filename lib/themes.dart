import 'package:flutter/material.dart';

class AppColors {
  // Light Mode Colors
  static final primaryLight = const Color.fromARGB(255, 5, 153, 239);
  static const backgroundLight = Color.fromARGB(255, 251, 251, 251);
  static const secondarybackgroundLight = Color.fromARGB(255, 255, 255, 255);
  static const mutedTextLight = Color.fromARGB(255, 111, 111, 111);
  static const textFieldBgLight = Color.fromARGB(69, 206, 206, 206);

  // Dark Mode Colors
  static final primaryDark = const Color.fromARGB(255, 139, 208, 118);
  static const backgroundDark = Color.fromARGB(255, 34, 37, 49);
  static const secondarybackgroundDark = Color.fromARGB(100, 50, 54, 69);
  // static const secondarybackgroundDark255 = Color.fromARGB(255, 32, 34, 42);
  static const mutedTextDark = Color.fromARGB(255, 185, 185, 185);
  static const textFieldBgDark = Color.fromARGB(50, 0, 0, 0);

  static const List<Color> primaryLightColors = [
    Color.fromARGB(255, 242, 185, 99),
    Color.fromARGB(255, 232, 131, 250),
    Colors.blue,
  ];
  static List<Color> secondaryLightColors = [
    Colors.purple,
    Colors.blue,
    Colors.orange,
  ];

  static const List<Color> primaryDarkColors = [
    Color.fromARGB(255, 102, 10, 94),
    Color.fromARGB(255, 1, 93, 36),
    Color.fromARGB(255, 1, 88, 159),
  ];
  static List<Color> secondaryDarkColors = [
    Color.fromARGB(255, 79, 1, 93),
    Color.fromARGB(255, 1, 52, 94),
    Color.fromARGB(255, 102, 10, 94),
  ];
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
      bodyMedium: TextStyle(fontSize: 16, color: Colors.black87),
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
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      bodyMedium: TextStyle(fontSize: 16, color: Colors.white70),
      bodyLarge: TextStyle(fontSize: 22, color: Colors.white),
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

  static List<BoxShadow> lightShadow = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.08),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];
  // Dark Mode Shadow: Darker and tighter (shadows are less visible in dark mode)
  static List<BoxShadow> darkShadow = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.4),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];

  static Color getPrimaryBg(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return isDark ? AppColors.backgroundDark : AppColors.backgroundLight;
  }

  static Color getPrimaryColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? AppColors.primaryDark : AppColors.primaryLight;
  }

  static Color getSecondaryBg(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return isDark
        ? AppColors.secondarybackgroundDark
        : AppColors.secondarybackgroundLight;
  }

  static Color mutedText(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? AppColors.mutedTextDark : AppColors.mutedTextLight;
  }

  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }
}
