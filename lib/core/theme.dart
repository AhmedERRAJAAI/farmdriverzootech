import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  useMaterial3: false,
  brightness: Brightness.light,
  primaryColor: Colors.blue,
  scaffoldBackgroundColor: Colors.white,
  primaryColorDark: Colors.grey.shade800,
  primaryColorLight: Colors.grey.shade300,
  buttonTheme: ButtonThemeData(
    buttonColor: Colors.white, // Background color of the button
    textTheme: ButtonTextTheme.primary, // Use the primary color for the text
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0), // Adjust the border radius as needed
    ),
  ),
  appBarTheme: const AppBarTheme(
    color: Colors.white,
    iconTheme: IconThemeData(color: Colors.blue),
    actionsIconTheme: IconThemeData(color: Colors.blue),
    elevation: 0,
  ),
  colorScheme: const ColorScheme.light(
    primary: Colors.blue,
    secondary: Color(0xFF810497),
    surface: Colors.white,
  ),
  textTheme: TextTheme(
    bodyMedium: const TextStyle(
      color: Color(0xFF282828),
      fontWeight: FontWeight.bold,
    ),
    bodyLarge: const TextStyle(
      fontSize: 19,
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
    bodySmall: TextStyle(
      fontSize: 10,
      color: Colors.grey.shade800,
    ),
    headlineSmall: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
    headlineMedium: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF252525)),
    headlineLarge: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
        if (states.contains(WidgetState.pressed)) {
          return Colors.blue.shade900; // Darker color when pressed
        }
        return Colors.blue; // Default color
      }),
      foregroundColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
        return Colors.white; // Text color
      }),
    ),
  ),
);

// Dark Mode Theme
ThemeData darkMode = ThemeData(
  useMaterial3: false,
  fontFamily: 'Roboto',
  brightness: Brightness.dark,
  primaryColor: const Color(0xFF78BEE2),
  scaffoldBackgroundColor: Colors.grey.shade900,
  primaryColorDark: Colors.grey.shade50,
  primaryColorLight: Colors.grey.shade600,
  buttonTheme: ButtonThemeData(
    buttonColor: Colors.blueGrey, // Background color of the button
    textTheme: ButtonTextTheme.primary, // Use the primary color for the text
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0), // Adjust the border radius as needed
    ),
  ),
  appBarTheme: AppBarTheme(
    color: Colors.grey.shade900,
    iconTheme: const IconThemeData(color: Colors.white),
    elevation: 0,
  ),
  colorScheme: ColorScheme.dark(
    primary: Colors.blue,
    secondary: const Color(0xFF810497),
    surface: Colors.grey.shade900,
  ),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
    bodyLarge: TextStyle(
      fontSize: 19,
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
    bodySmall: TextStyle(
      fontSize: 10,
    ),
    headlineSmall: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
    headlineMedium: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
    headlineLarge: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
        if (states.contains(WidgetState.pressed)) {
          return Colors.blue.shade700; // Darker color when pressed
        }
        return Colors.blue.shade600; // Default color
      }),
      foregroundColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
        return Colors.white; // Text color
      }),
    ),
  ),
);
