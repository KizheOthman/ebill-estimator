import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const ElectricityBillApp());
}

class ElectricityBillApp extends StatelessWidget {
  const ElectricityBillApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-Bill Estimator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE65100),
          primary: const Color(0xFFE65100),
          secondary: const Color(0xFFFF8F00),
          surface: const Color(0xFFFFF8F0),
          background: const Color(0xFFFFF8F0),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFE65100),
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 4,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.2,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFE65100),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE65100), width: 2),
          ),
          labelStyle: const TextStyle(color: Color(0xFFE65100)),
          prefixIconColor: const Color(0xFFE65100),
          filled: true,
          fillColor: Colors.white,
        ),
        cardTheme: CardThemeData(
  elevation: 3,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(16),
  ),
  color: Colors.white,
),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFFE65100),
          foregroundColor: Colors.white,
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: const Color(0xFFE65100),
          contentTextStyle: const TextStyle(color: Colors.white),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          behavior: SnackBarBehavior.floating,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}