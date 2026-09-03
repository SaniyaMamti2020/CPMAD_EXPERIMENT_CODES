import 'package:flutter/material.dart';

import '../models/product.dart';
import '../widgets/product_card.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,

      child: Column(
        children: [
          const TabBar(
            isScrollable: true,

            tabs: [
              Tab(
                text: 'All',
                icon: Icon(Icons.apps),
              ),

              Tab(
                text: 'Electronics',
                icon: Icon(Icons.devices),
              ),

              Tab(
                text: 'Fashion',
                icon: Icon(Icons.checkroom),
              ),

              Tab(
                text: 'Home',
                icon: Icon(Icons.home),
              ),
            ],
          ),

          Expanded(
            child: TabBarView(
              children: [
                ProductGrid(
                  products: products,
                ),

                ProductGrid(
                  products: products
                      .where(
                        (product) =>
                            product.category ==
                            'Electronics',
                      )
                      .toList(),
                ),

                ProductGrid(
                  products: products
                      .where(
                        (product) =>
                            product.category ==
                            'Fashion',
                      )
                      .toList(),
                ),

                ProductGrid(
                  products: products
                      .where(
                        (product) =>
                            product.category ==
                            'Home',
                      )
                      .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// PRODUCT GRID
// ============================================================

class ProductGrid extends StatelessWidget {
  final List<Product> products;

  const ProductGrid({
    super.key,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),

      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,

        crossAxisSpacing: 10,

        mainAxisSpacing: 10,

        childAspectRatio: 0.72,
      ),

      itemCount: products.length,

      itemBuilder: (context, index) {
        return ProductCard(
          product: products[index],
        );
      },
    );
  }
}