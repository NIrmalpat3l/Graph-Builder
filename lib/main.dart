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
      title: 'Graph Builder',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const GraphBuilderScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
