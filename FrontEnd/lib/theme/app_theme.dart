/*import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF6A7BF7);
  static const Color secondaryColor = Color(0xFFB5C2FF);
  static const Color lightBlue = Color(0xFFD6E0FF);
  static const Color backgroundGradientStart = Color(0xFFD6E0FF);
  static const Color backgroundGradientEnd = Color(0xFFF8D6FF);
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color grey = Color(0xFFF5F5F5);
  static const Color textGrey = Color(0xFF9E9E9E);

  // Text styles using Google Fonts (OpenSans)
  static final TextStyle headingStyle = GoogleFonts.openSans(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: primaryColor,
  );

  static final TextStyle subheadingStyle = GoogleFonts.openSans(
    fontSize: 16,
    color: textGrey,
  );

  static final TextStyle buttonTextStyle = GoogleFonts.openSans(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: white,
  );

  static final TextStyle linkStyle = GoogleFonts.openSans(
    fontSize: 14,
    color: primaryColor,
    fontWeight: FontWeight.w500,
  );

  static final ThemeData lightTheme = ThemeData(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: white,
    colorScheme: ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      background: white,
    ),
    textTheme: GoogleFonts.openSansTextTheme(),
    appBarTheme: AppBarTheme(
      backgroundColor: primaryColor,
      elevation: 0,
      centerTitle: true,
      iconTheme: const IconThemeData(color: white),
      titleTextStyle: GoogleFonts.openSans(
        color: white,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: white,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        textStyle: buttonTextStyle,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: grey,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: primaryColor),
      ),
      hintStyle: subheadingStyle,
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryColor,
        textStyle: linkStyle,
      ),
    ),
  );
}*/
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Updated elegant color palette for medical app
  static const Color primaryColor = Color(0xCC6A7BF7);
  static const Color secondaryColor = Color(0xFFB5C2FF);
  static const Color lightBlue = Color(0xFFD6E0FF);
  static const Color backgroundGradientStart = Color(0xB3D6E0FF);
  static const Color backgroundGradientEnd = Color(0x99F8D6FF);
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color grey = Color(0xFFF5F5F5);
  static const Color textGrey = Color(0xFF9E9E9E);
  static const Color errorColor = Color(0xFFE57373); // Soft red
  static const Color cardBgColor = Color(0xFFFAFAFA); // Off-white
  static const Color accentColor = Color(0xFF5ABB8A); // Soft green

  // Text styles using Google Fonts (Poppins for a modern, clean look)
  static final TextStyle headingStyle = GoogleFonts.poppins(
    fontSize: 26,
    fontWeight: FontWeight.w600,
    color: primaryColor,
    letterSpacing: 0.2,
  );

  static final TextStyle subheadingStyle = GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: textGrey,
    letterSpacing: 0.1,
  );

  static final TextStyle buttonTextStyle = GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: white,
    letterSpacing: 0.2,
  );

  static final TextStyle linkStyle = GoogleFonts.poppins(
    fontSize: 16,
    color: primaryColor,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
  );

  static final TextStyle cardTitleStyle = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: black,
    letterSpacing: 0.1,
  );

  static final ThemeData lightTheme = ThemeData(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: white,
    colorScheme: ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      tertiary: accentColor,
      surface: white,
      error: errorColor,
    ),
    textTheme: GoogleFonts.poppinsTextTheme(),
    appBarTheme: AppBarTheme(
      backgroundColor: primaryColor,
      elevation: 0,
      centerTitle: true,
      iconTheme: const IconThemeData(color: white),
      titleTextStyle: GoogleFonts.poppins(
        color: white,
        fontSize: 18,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.2,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: white,
        minimumSize: const Size(double.infinity, 50),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: buttonTextStyle,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: grey,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryColor, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: errorColor, width: 1.5),
      ),
      hintStyle: GoogleFonts.poppins(
        fontSize: 14,
        color: textGrey,
        fontWeight: FontWeight.w400,
      ),
      errorStyle: GoogleFonts.poppins(
        fontSize: 12,
        color: errorColor,
        fontWeight: FontWeight.w400,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryColor,
        textStyle: linkStyle,
      ),
    ),
    cardTheme: CardTheme(
      color: cardBgColor,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    dividerTheme: const DividerThemeData(
      color: Color(0xFFEEEEEE),
      thickness: 1,
      space: 1,
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryColor;
        }
        return Colors.transparent;
      }),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    ),
  );
}
