import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'constants/colors.dart';
import 'screens/home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized;
  runApp(const MarkItDown());
}

class MarkItDown extends StatelessWidget {
  const MarkItDown({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          actionsIconTheme: IconThemeData(
            color: dark,
            size: 32,
          ),
          backgroundColor: light,
          centerTitle: false,
          foregroundColor: dark,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: dark,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: background,
        brightness: Brightness.light,
        buttonTheme: const ButtonThemeData(
          buttonColor: primary,
          textTheme: ButtonTextTheme.accent,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: primary,
          foregroundColor: light,
        ),
        fontFamily: GoogleFonts.openSans().fontFamily,
        inputDecorationTheme: const InputDecorationTheme(
          suffixIconColor: greyMute,
          focusColor: primaryLight,
          contentPadding: EdgeInsets.all(16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(
              color: primaryLight,
              width: 2,
            ),
          ),
          filled: true,
          fillColor: light,
          hintStyle: TextStyle(
            color: greyMute,
          ),
        ),
        primaryColor: primary,
      ),
      home: const HomeScreen(),
    );
  }
}
