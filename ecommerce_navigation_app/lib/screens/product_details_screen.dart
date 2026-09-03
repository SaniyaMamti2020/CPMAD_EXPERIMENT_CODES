import 'package:flutter/material.dart';

import '../models/product.dart';

class ProductDetailsScreen
    extends StatelessWidget {

  final Product product;

  const ProductDetailsScreen({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Product Details',
        ),

        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/cart',
                arguments: product,
              );
            },

            icon: const Icon(
              Icons.shopping_cart,
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [
            // PRODUCT IMAGE
            Image.network(
              product.image,

              width: double.infinity,

              height: 300,

              fit: BoxFit.cover,
            ),

            Padding(
              padding:
                  const EdgeInsets.all(20),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [
                  Text(
                    product.name,

                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Chip(
                    label: Text(
                      product.category,
                    ),
                  ),

                  const SizedBox(height: 15),

                  Text(
                    '₹${product.price.toStringAsFixed(2)}',

                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'Description',

                    style: TextStyle(
                      fontSize: 20,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    product.description,

                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 30),
                  
                  // ADD TO CART
                  SizedBox(
                    width: double.infinity,

                    height: 52,

                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/cart',
                          arguments: product,
                        );
                      },

                      icon: const Icon(
                        Icons.add_shopping_cart,
                      ),

                      label: const Text(
                        'Add to Cart',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}