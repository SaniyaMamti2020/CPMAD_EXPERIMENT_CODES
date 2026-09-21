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
      ),

      body: SingleChildScrollView(

        child: Column(

          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            // =================================================
            // HERO IMAGE
            // =================================================

            Hero(

              tag:
                  'product-${product.id}',

              child: Image.network(

                product.image,

                width: double.infinity,

                height: 350,

                fit: BoxFit.cover,

                errorBuilder:
                    (context, error, stackTrace) {

                  return const SizedBox(
                    height: 350,

                    child: Center(
                      child: Icon(
                        Icons.image,
                        size: 80,
                      ),
                    ),
                  );
                },
              ),
            ),

            // =================================================
            // PRODUCT DETAILS
            // =================================================

            Padding(
              padding:
                  const EdgeInsets.all(20),

              child: Column(

                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  Text(

                    product.name,

                    style:
                        const TextStyle(
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

                    style:
                        const TextStyle(
                      fontSize: 26,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 25),

                  const Text(

                    'Description',

                    style:
                        TextStyle(
                      fontSize: 21,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(

                    product.description,

                    style:
                        const TextStyle(
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // =================================================
                  // ADD TO CART BUTTON
                  // =================================================

                  SizedBox(

                    width: double.infinity,

                    height: 55,

                    child:
                        ElevatedButton.icon(

                      onPressed: () {

                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(

                          const SnackBar(
                            content: Text(
                              'Product added to cart!',
                            ),
                          ),
                        );
                      },

                      icon: const Icon(
                        Icons.shopping_cart,
                      ),

                      label: const Text(
                        'Add to Cart',
                        style: TextStyle(
                          fontSize: 17,
                        ),
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