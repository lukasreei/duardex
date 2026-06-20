import 'package:flutter/material.dart';

import 'pages/home_page.dart';

void main() {
  runApp(const LunaApp());
}

class LunaApp extends StatelessWidget {
  const LunaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Luna',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF07070A),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF6B9A),
          brightness: Brightness.dark,
          primary: const Color(0xFFFF6B9A),
          surface: const Color(0xFF111116),
        ),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(fontWeight: FontWeight.w700),
          headlineSmall: TextStyle(fontWeight: FontWeight.w700),
          titleLarge: TextStyle(fontWeight: FontWeight.w700),
          titleMedium: TextStyle(fontWeight: FontWeight.w700),
          bodyMedium: TextStyle(height: 1.45),
          bodyLarge: TextStyle(height: 1.5),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF07070A),
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
        ),
      ),
      home: const HomePage(),
    );
  }
}
