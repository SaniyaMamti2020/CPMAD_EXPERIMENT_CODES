import 'package:flutter/material.dart';

import 'screens/news_dashboard_screen.dart';

void main() {
  runApp(const NewsDashboardApp());
}

class NewsDashboardApp extends StatelessWidget {
  const NewsDashboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'News Dashboard',

      theme: ThemeData(
        useMaterial3: true,

        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
        ),
      ),

      home: const NewsDashboardScreen(),
    );
  }
}