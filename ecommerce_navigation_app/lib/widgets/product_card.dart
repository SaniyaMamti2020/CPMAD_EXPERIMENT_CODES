import 'package:flutter/material.dart';

import '../models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // TAP
      onTap: () {
        Navigator.pushNamed(
          context,
          '/product-details',
          arguments: product,
        );
      },
      // LONG PRESS
      onLongPress: () {
        ScaffoldMessenger.of(context)
            .showSnackBar(
          SnackBar(
            content: Text(
              '${product.name} selected',
            ),
          ),
        );
      },

      child: Card(
        clipBehavior:
            Clip.antiAlias,

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [
            // IMAGE

            Expanded(
              child: Image.network(
                product.image,

                width: double.infinity,

                fit: BoxFit.cover,

                errorBuilder:
                    (context, error, stackTrace) {
                  return const Center(
                    child: Icon(
                      Icons.image,
                      size: 50,
                    ),
                  );
                },
              ),
            ),

            // PRODUCT INFORMATION
            Padding(
              padding:
                  const EdgeInsets.all(10),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [
                  Text(
                    product.name,

                    maxLines: 1,

                    overflow:
                        TextOverflow.ellipsis,

                    style: const TextStyle(
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    product.category,
                  ),

                  const SizedBox(height: 5),

                  Text(
                    '₹${product.price.toStringAsFixed(0)}',

                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight:
                          FontWeight.bold,
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