import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  AppTheme._();

  // Color Palette - Urban Farming Forest Green
  static const Color primaryLight = Color(0xFF104B36); // Deep Forest Green
  static const Color onPrimaryLight = Color(0xFFFFFFFF);
  static const Color primaryContainerLight = Color(0xFFEAF3E7); // Fresh Mint Sage
  static const Color onPrimaryContainerLight = Color(0xFF104B36);

  static const Color secondaryLight = Color(0xFF196B4A); // Emerald Accent
  static const Color onSecondaryLight = Color(0xFFFFFFFF);
  static const Color secondaryContainerLight = Color(0xFFE9F3DF);
  static const Color onSecondaryContainerLight = Color(0xFF17352B);

  static const Color tertiaryLight = Color(0xFF526921); // Olive Sage
  static const Color onTertiaryLight = Color(0xFFFFFFFF);

  static const Color backgroundLight = Color(0xFFFAFBF7); // Clean Nature Background
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceContainerLight = Color(0xFFF3F6F1);
  static const Color surfaceContainerHighLight = Color(0xFFE8EDE8);
  static const Color onSurfaceLight = Color(0xFF17352B); // Deep Pine Charcoal
  static const Color onSurfaceVariantLight = Color(0xFF72827C);

  static const Color outlineLight = Color(0xFFDFE6DA);
  static const Color outlineVariantLight = Color(0xFFE2E8E3);

  // Dark Mode Palette
  static const Color primaryDark = Color(0xFF7CD9B5);
  static const Color onPrimaryDark = Color(0xFF003825);
  static const Color primaryContainerDark = Color(0xFF104B36);
  static const Color onPrimaryContainerDark = Color(0xFFC7F2DF);

  static const Color secondaryDark = Color(0xFFB5E2C4);
  static const Color onSecondaryDark = Color(0xFF1B4E32);
  static const Color secondaryContainerDark = Color(0xFF265A3D);
  static const Color onSecondaryContainerDark = Color(0xFFD8F2E1);

  static const Color backgroundDark = Color(0xFF111714);
  static const Color surfaceDark = Color(0xFF17201B);
  static const Color surfaceContainerDark = Color(0xFF1E2A23);
  static const Color surfaceContainerHighDark = Color(0xFF26352C);
  static const Color onSurfaceDark = Color(0xFFE2E8E4);
  static const Color onSurfaceVariantDark = Color(0xFFA1ADA5);

  static const Color outlineDark = Color(0xFF334239);
  static const Color outlineVariantDark = Color(0xFF25312A);

  static ThemeData get lightTheme {
    const colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: primaryLight,
      onPrimary: onPrimaryLight,
      primaryContainer: primaryContainerLight,
      onPrimaryContainer: onPrimaryContainerLight,
      secondary: secondaryLight,
      onSecondary: onSecondaryLight,
      secondaryContainer: secondaryContainerLight,
      onSecondaryContainer: onSecondaryContainerLight,
      tertiary: tertiaryLight,
      onTertiary: onTertiaryLight,
      surface: surfaceLight,
      onSurface: onSurfaceLight,
      onSurfaceVariant: onSurfaceVariantLight,
      outline: outlineLight,
      outlineVariant: outlineVariantLight,
      error: Color(0xFFBA1A1A),
      onError: Color(0xFFFFFFFF),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: backgroundLight,
      canvasColor: surfaceLight,
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundLight,
        foregroundColor: onSurfaceLight,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
        titleTextStyle: TextStyle(
          color: onSurfaceLight,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
        ),
      ),
      cardTheme: const CardThemeData(
        color: surfaceLight,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          side: BorderSide(color: outlineVariantLight, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      dividerTheme: const DividerThemeData(
        color: outlineVariantLight,
        thickness: 1,
        space: 1,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surfaceLight,
        elevation: 0,
        height: 68,
        indicatorColor: primaryContainerLight,
        surfaceTintColor: Colors.transparent,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: primaryLight, size: 22);
          }
          return const IconThemeData(color: onSurfaceVariantLight, size: 22);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: primaryLight,
            );
          }
          return const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: onSurfaceVariantLight,
          );
        }),
      ),
      drawerTheme: const DrawerThemeData(
        backgroundColor: surfaceLight,
        surfaceTintColor: Colors.transparent,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryLight,
          foregroundColor: onPrimaryLight,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.1,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryLight,
          side: const BorderSide(color: outlineLight, width: 1),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceLight,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: outlineVariantLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: outlineVariantLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryLight, width: 1.5),
        ),
        hintStyle: const TextStyle(
          color: onSurfaceVariantLight,
          fontSize: 13,
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    const colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: primaryDark,
      onPrimary: onPrimaryDark,
      primaryContainer: primaryContainerDark,
      onPrimaryContainer: onPrimaryContainerDark,
      secondary: secondaryDark,
      onSecondary: onSecondaryDark,
      secondaryContainer: secondaryContainerDark,
      onSecondaryContainer: onSecondaryContainerDark,
      surface: surfaceDark,
      onSurface: onSurfaceDark,
      onSurfaceVariant: onSurfaceVariantDark,
      outline: outlineDark,
      outlineVariant: outlineVariantDark,
      error: Color(0xFFFFB4AB),
      onError: Color(0xFF690005),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: backgroundDark,
      canvasColor: surfaceDark,
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundDark,
        foregroundColor: onSurfaceDark,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: onSurfaceDark,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
      cardTheme: const CardThemeData(
        color: surfaceDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          side: BorderSide(color: outlineDark, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      navigationBarTheme: const NavigationBarThemeData(
        backgroundColor: surfaceDark,
        elevation: 0,
        indicatorColor: primaryContainerDark,
        surfaceTintColor: Colors.transparent,
      ),
    );
  }
}
