import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unifier_mobile/app/shared/themes/colors.dart';

ThemeData darkTheme() {
  final accentColor = UnifierColors.primaryColor;
  final secondaryColor = UnifierColors.secondaryColor;

  return ThemeData(
    pageTransitionsTheme: PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.fuchsia: CupertinoPageTransitionsBuilder(),
      },
    ),
    iconTheme: IconThemeData(color: secondaryColor),
    brightness: Brightness.dark,
    fontFamily: GoogleFonts.openSans().fontFamily,
    textSelectionTheme: TextSelectionThemeData(cursorColor: accentColor),
    primarySwatch: MaterialColor(
      0xFF000000,
      {
        50: Color.fromRGBO(0, 0, 0, .1),
        100: Color.fromRGBO(0, 0, 0, .2),
        200: Color.fromRGBO(0, 0, 0, .3),
        300: Color.fromRGBO(0, 0, 0, .4),
        400: Color.fromRGBO(0, 0, 0, .5),
        500: Color.fromRGBO(0, 0, 0, .6),
        600: Color.fromRGBO(0, 0, 0, .7),
        700: Color.fromRGBO(0, 0, 0, .8),
        800: Color.fromRGBO(0, 0, 0, .9),
        900: Color.fromRGBO(0, 0, 0, 1),
      },
    ),
    accentColor: accentColor,
    // scaffoldBackgroundColor: Color.fromRGBO(15, 15, 15, 1),
    buttonTheme: ButtonThemeData(
      textTheme: ButtonTextTheme.normal,
    ),
    radioTheme: RadioThemeData(
      fillColor: MaterialStateProperty.all(accentColor),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        primary: UnifierColors.secondaryColor,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 4,
        primary: UnifierColors.secondaryColor,
        onPrimary: UnifierColors.tertiaryColor,
      ),
    ),
    textTheme: TextTheme(
      button: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      bodyText1: TextStyle(
        fontSize: 16,
        fontFamily: GoogleFonts.openSans().fontFamily,
      ),
      bodyText2: TextStyle(
        fontSize: 16,
        fontFamily: GoogleFonts.openSans().fontFamily,
      ),
      headline1: TextStyle(
        fontSize: 16,
        fontFamily: GoogleFonts.openSans().fontFamily,
      ),
      headline2: TextStyle(
        fontSize: 16,
        fontFamily: GoogleFonts.openSans().fontFamily,
      ),
      headline3: TextStyle(
        fontSize: 16,
        fontFamily: GoogleFonts.openSans().fontFamily,
      ),
      headline4: TextStyle(
        fontSize: 16,
        fontFamily: GoogleFonts.openSans().fontFamily,
      ),
      headline5: TextStyle(
        fontSize: 16,
        fontFamily: GoogleFonts.openSans().fontFamily,
      ),
      headline6: TextStyle(
        fontSize: 16,
        fontFamily: GoogleFonts.openSans().fontFamily,
      ),
      subtitle1: TextStyle(
        fontSize: 16,
        fontFamily: GoogleFonts.openSans().fontFamily,
      ),
    ),
  );
}
