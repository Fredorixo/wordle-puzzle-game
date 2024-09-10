import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";

class AppTheme {
  static final TextTheme _textTheme = GoogleFonts.poppinsTextTheme();

  static ThemeData light() {
    return ThemeData.light().copyWith(
      primaryColor: Colors.deepPurple.shade300,
      scaffoldBackgroundColor: Colors.grey.shade200,
      appBarTheme: AppBarTheme(
        iconTheme: IconThemeData(
          color: Colors.black.withOpacity(0.75),
        ),
        backgroundColor: Colors.grey.shade100,
        titleTextStyle: _textTheme.titleMedium?.copyWith(
          color: Colors.deepPurple.shade400,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
        actionsIconTheme: IconThemeData(
          color: Colors.black.withOpacity(0.75),
        ),
      ),
      iconTheme: IconThemeData(
        color: Colors.black.withOpacity(0.75),
      ),
      snackBarTheme: const SnackBarThemeData(
        contentTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 18.0,
        ),
        behavior: SnackBarBehavior.floating,
      ),
      errorColor: Colors.red.shade400,
      textTheme: _textTheme,
      primaryTextTheme: _textTheme,
    );
  }

  static ThemeData dark() {
    return ThemeData.dark().copyWith(
      primaryColor: Colors.deepPurple.shade300,
      appBarTheme: AppBarTheme(
        titleTextStyle: _textTheme.titleMedium?.copyWith(
          color: Colors.deepPurple.shade400,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      snackBarTheme: const SnackBarThemeData(
        contentTextStyle: TextStyle(
          fontSize: 18.0,
        ),
        behavior: SnackBarBehavior.floating,
      ),
      errorColor: Colors.red.shade400,
      primaryTextTheme: _textTheme.apply(
        bodyColor: Colors.white,
      ),
      textTheme: _textTheme.apply(
        bodyColor: Colors.white,
      ),
    );
  }
}
