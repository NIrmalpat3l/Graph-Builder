import 'package:flutter/material.dart';
import 'graph_builder_screen.dart';

void main() {
  runApp(const GraphBuilderApp());
}

class GraphBuilderApp extends StatelessWidget {
  const GraphBuilderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Graph Builder Pro',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF6366F1), // Modern indigo
          primaryContainer: Color(0xFF4F46E5),
          secondary: Color(0xFF10B981), // Professional green
          secondaryContainer: Color(0xFF059669),
          surface: Color(0xFF1F2937), // Dark gray surface
          background: Color(0xFF111827), // Very dark background
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: Color(0xFFE5E7EB),
          onBackground: Color(0xFFE5E7EB),
        ),
        cardTheme: const CardThemeData(
          color: Color(0xFF374151),
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1F2937),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF6366F1),
          foregroundColor: Colors.white,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const GraphBuilderScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}