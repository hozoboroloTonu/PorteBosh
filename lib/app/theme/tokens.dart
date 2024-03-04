import 'package:flutter/material.dart';

/// Semantic color tokens designed specifically for PorteBosh
class AppColors {
  // Light Theme
  static const Color backgroundLight = Color(0xFFF7F7F4);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceVariantLight = Color(0xFFE8EBE7);
  static const Color accentLight = Color(0xFF176B5B); // Muted Emerald
  static const Color textPrimaryLight = Color(0xFF252923);
  static const Color textSecondaryLight = Color(0xFF6A7167);
  static const Color dividerLight = Color(0xFFDFE3DE);

  // Dark Theme
  static const Color backgroundDark = Color(0xFF141714);
  static const Color surfaceDark = Color(0xFF1D221D);
  static const Color surfaceVariantDark = Color(0xFF262C26);
  static const Color accentDark = Color(0xFF289B84);
  static const Color textPrimaryDark = Color(0xFFE8EDE7);
  static const Color textSecondaryDark = Color(0xFF9EA69D);
  static const Color dividerDark = Color(0xFF2C332C);

  // Status & Priority
  static const Color overdue = Color(0xFFB83A32);
  static const Color upcoming = Color(0xFFB5771E);
  static const Color completed = Color(0xFF287C4C);
  static const Color neutral = Color(0xFF788077);

  // Academic Course Palette
  static const List<Color> coursePalette = [
    Color(0xFF176B5B), // Emerald
    Color(0xFF235789), // Ocean Blue
    Color(0xFF723D46), // Muted Wine
    Color(0xFFC76D2B), // Amber Copper
    Color(0xFF5D4E6D), // Slate Purple
    Color(0xFF2E6F40), // Forest Green
    Color(0xFF8C3F5D), // Rosewood
    Color(0xFF386875), // Deep Teal
  ];
}

class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
}

class AppRadii {
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const Radius rSm = Radius.circular(sm);
  static const Radius rMd = Radius.circular(md);
  static const Radius rLg = Radius.circular(lg);
}
