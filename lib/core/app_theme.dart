import 'package:flutter/material.dart';

abstract class AppColors {
  static const Color background = Color(0xFFF6F7FB);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color primary = Color(0xFF3F51B5);
  static const Color primaryButton = Color(0xFF4B4E85);
  static const Color text = Color(0xFF11131A);
  static const Color mutedText = Color(0xFF989EAA);
  static const Color profileAvatarBackground = Color(0xFFE8ECF6);
  static const Color cardShadow = Color(0x0F11131A);

  static const Color taskBlue = Color(0xFF2196F3);
  static const Color taskGreen = Color(0xFF4CAF50);
  static const Color taskOrange = Color(0xFFFF9800);
  static const Color taskPurple = Color(0xFF9C27B0);
  static const Color taskRed = Color(0xFFF44336);
  static const Color taskTeal = Color(0xFF009688);
}

abstract class AppTheme {
  static ThemeData get light {
    final ColorScheme colorScheme =
        ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.light,
        ).copyWith(
          primary: AppColors.primary,
          onPrimary: Colors.white,
          surface: AppColors.surface,
          onSurface: AppColors.text,
        );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: 'Roboto',
      splashFactory: InkRipple.splashFactory,
      popupMenuTheme: PopupMenuThemeData(
        color: AppColors.surface,
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.text,
        contentTextStyle: const TextStyle(color: Colors.white, fontSize: 13),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
