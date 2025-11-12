import 'package:flutter/material.dart';

class ThemeState {
  final ThemeData themeData;
  final bool isDarkMode;
  final bool isCustomFont;
  final Color buttonColor;

  ThemeState({
    required this.themeData,
    required this.isDarkMode,
    required this.isCustomFont,
    required this.buttonColor,
  });

  ThemeState copyWith({
    ThemeData? themeData,
    bool? isDarkMode,
    bool? isCustomFont,
    Color? buttonColor,
  }) {
    return ThemeState(
      themeData: themeData ?? this.themeData,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      isCustomFont: isCustomFont ?? this.isCustomFont,
      buttonColor: buttonColor ?? this.buttonColor,
    );
  }
}
