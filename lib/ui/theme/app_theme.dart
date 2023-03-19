import 'package:fitness/const/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  ThemeData lightTheme(context) => ThemeData(
        brightness: Brightness.light,
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.amber,
          titleTextStyle: TextStyle(color: Colors.black, fontSize: 20),
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
        ),
        tabBarTheme: TabBarTheme(
          labelColor: Colors.black,
          labelStyle: TextStyle(fontSize: 18),
        ),
        colorScheme: ColorScheme.light(),
        // primarySwatch: Colors.blue,
        textTheme: GoogleFonts.darkerGrotesqueTextTheme(
          Theme.of(context).textTheme.apply(
                bodyColor: Colors.black,
              ),
        ),
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      );

  ThemeData darkTheme(context) => ThemeData(
        tabBarTheme: TabBarTheme(
           labelStyle: TextStyle(fontSize: 18),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.amber,
          titleTextStyle: TextStyle(color: Colors.black, fontSize: 20),
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
        ),
        brightness: Brightness.dark,
        colorScheme: ColorScheme.dark(),
        //  primarySwatch: Colors.amber,
        textTheme: GoogleFonts.darkerGrotesqueTextTheme(
          Theme.of(context).textTheme.apply(
                bodyColor: Colors.white,
              ),
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      );
}
