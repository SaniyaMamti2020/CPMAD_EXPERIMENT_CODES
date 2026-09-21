import 'package:flutter/material.dart';

import '../models/product.dart';
import '../widgets/animated_product_card.dart';
import 'product_details_screen.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Animated Product Catalogue',
        ),

        centerTitle: true,
      ),

      body: GridView.builder(
        padding: const EdgeInsets.all(12),

        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,

          crossAxisSpacing: 12,

          mainAxisSpacing: 12,

          childAspectRatio: 0.68,
        ),

        itemCount: products.length,

        itemBuilder: (context, index) {
          final product = products[index];

          return AnimatedProductCard(
            product: product,

            onTap: () {
              Navigator.push(
                context,

                _createRoute(
                  ProductDetailsScreen(
                    product: product,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// ============================================================
// CUSTOM PAGE TRANSITION
// ============================================================

Route _createRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (
      context,
      animation,
      secondaryAnimation,
    ) {
      return page;
    },

    transitionsBuilder: (
      context,
      animation,
      secondaryAnimation,
      child,
    ) {
      const begin = Offset(1.0, 0.0);

      const end = Offset.zero;

      const curve = Curves.easeInOut;

      final tween = Tween(
        begin: begin,
        end: end,
      ).chain(
        CurveTween(
          curve: curve,
        ),
      );

      return SlideTransition(
        position: animation.drive(tween),

        child: FadeTransition(
          opacity: animation,

          child: child,
        ),
      );
    },

    transitionDuration:
        const Duration(milliseconds: 600),
  );
}