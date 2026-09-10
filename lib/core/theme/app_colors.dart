import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Core Brand Colors (Light)
  static const Color primary = Colors.blue;
  static const Color secondary = Colors.orange;
  static const Color background = Colors.white;
  static const Color surface = Color(0xffF5F5F5);
  static const Color text = Colors.black;
  static const Color grey = Colors.grey;
  static const Color success = Colors.green;
  static const Color error = Colors.red;
  static const Color warning = Colors.amber;

  // Luxury Dark & Gold Palette (Matching User Design)
  static const Color darkBackground = Color(0xFF0B0E14); // Deep Obsidian Black
  static const Color darkSurface = Color(0xFF131922);    // Inputs & Nested Surfaces
  static const Color darkCard = Color(0xFF17202C);       // Card Background
  static const Color darkCardElevated = Color(0xFF1E2838); // Floating / Active Card
  static const Color darkBorder = Color(0xFF243042);     // Slate Border
  static const Color darkBorderGold = Color(0x33E5A93C); // Subtle Gold Tinted Border

  // Luxury Metallic Gold
  static const Color gold = Color(0xFFE5A93C);           // Core Metallic Gold
  static const Color goldLight = Color(0xFFF7D179);      // Bright Gold Highlight
  static const Color goldDark = Color(0xFFC4891A);       // Deep Amber Gold
  static const Color goldGlow = Color(0x4DE5A93C);       // Golden Ambient Glow

  // Dark Mode Text Colors
  static const Color darkTextPrimary = Colors.white;
  static const Color darkTextSecondary = Color(0xFF8F9FB3); // Silvery Slate
  static const Color darkTextMuted = Color(0xFF5A6778);     // Muted Hint Text

  // Gradients
  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFF5C768), Color(0xFFD49220)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkCardGradient = LinearGradient(
    colors: [Color(0xFF1E2838), Color(0xFF121822)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkBannerGradient = LinearGradient(
    colors: [Color(0xFF222C3D), Color(0xFF121720)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}