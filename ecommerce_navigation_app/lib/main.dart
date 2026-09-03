import 'package:flutter/material.dart';

import 'models/product.dart';
import 'screens/home_screen.dart';
import 'screens/product_details_screen.dart';
import 'screens/product_list_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/cart_screen.dart';

void main() {
  runApp(const EcommerceApp());
}

class EcommerceApp extends StatelessWidget {
  const EcommerceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'Shopping Application',

      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
      ),

      initialRoute: '/',

      routes: {
        '/': (context) => const HomeScreen(),

        '/products': (context) =>
            const ProductListScreen(),

        '/profile': (context) =>
            const ProfileScreen(),

        '/cart': (context) =>
            const CartScreen(),
      },

      onGenerateRoute: (settings) {
        if (settings.name == '/product-details') {
          final Product product =
              settings.arguments as Product;

          return MaterialPageRoute(
            builder: (context) =>
                ProductDetailsScreen(
              product: product,
            ),
          );
        }

        return null;
      },
    );
  }
}