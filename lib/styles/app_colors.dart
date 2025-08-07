import 'package:flutter/material.dart';

class AppColors {
  // 🌑 Backgrounds
  static const background = Color(0xFF121212); // Main dark background
  static const cardGreen = Color(0xFFA8E6CF); // Design category
  static const cardYellow = Color(0xFFFFD3B6); // Network category
  static const cardPink = Color(0xFFFFAAA5); // Security category
  static const cardBlue = Color(0xFFDCEDFF); // Other category

  // 🖋️ Text
  static const textPrimary = Color(0xFFFFFFFF); // Headings, main text
  static const textSecondary = Color(0xFFB0B0B0); // Subtext
  static const textAccentBlue = Color(0xFF64B5F6); // Links, interactive
  static const textAccentYellow = Color(0xFFFFD700); // Highlights

  // 🔘 UI Elements
  static const underlineBlue = Color(0xFF64B5F6); // Underlines
  static const badgeYellow = Color(0xFFFFC107); // Skill badge

  // 🧩 Legacy keys for compatibility (💡 mapped to new scheme)
  static const primary = textAccentBlue;         // For buttons or CTAs
  static const font = textPrimary;               // Primary text
  static const font2 = textSecondary;            // Secondary text
  static const black = Color(0xFF000000);
  static const white = Color(0xFFFFFFFF);
  static const disabledFont = Color(0xFF757575); // Muted text
  static const disabledButton = Color(0xFF424242); // Inactive buttons

  // ✍️ Input Field Background
  static final fieldColor = cardBlue.withOpacity(0.15);
}
