import 'package:flutter/material.dart';
import 'screens/home_events_screen.dart';

void main() {
  runApp(const NusaEventApp());
}

class NusaEventApp extends StatelessWidget {
  const NusaEventApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NusaEvent Hub',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF5746E8),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF7F7FC),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF7F7FC),
          foregroundColor: Color(0xFF19172B),
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFFE9E8F1)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFF5746E8)),
          ),
        ),
      ),
      home: const HomeEventsScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}