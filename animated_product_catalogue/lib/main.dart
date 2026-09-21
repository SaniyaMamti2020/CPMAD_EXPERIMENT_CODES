import 'package:flutter/material.dart';

import 'screens/product_list_screen.dart';

void main() {
  runApp(const AnimatedProductApp());
}

class AnimatedProductApp extends StatelessWidget {
  const AnimatedProductApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'Animated Product Catalogue',

      theme: ThemeData(
        useMaterial3: true,

        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
      ),

      home: const ProductListScreen(),
    );
  }
}