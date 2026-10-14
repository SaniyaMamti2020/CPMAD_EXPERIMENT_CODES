import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/cart_provider.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cart, child) {
        final quantity = cart.quantityOf(product.id);
        final wished = cart.isWishlisted(product.id);

        return Card(
          elevation: 3,
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      Center(
                        child: Image.network(
                          product.image,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) =>
                              const Icon(
                            Icons.image_not_supported,
                            size: 50,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          onPressed: () =>
                              cart.toggleWishlist(product.id),
                          icon: Icon(
                            wished
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  product.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '₹${product.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '⭐ ${product.rating}',
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 5),
                SizedBox(
                  width: double.infinity,
                  child: quantity == 0
                      ? ElevatedButton(
                          onPressed: () => cart.addToCart(product),
                          child: const Text('Add to Cart'),
                        )
                      : Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () =>
                                  cart.removeOne(product.id),
                              icon: const Icon(
                                Icons.remove_circle_outline,
                              ),
                            ),
                            Text(
                              '$quantity',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              onPressed: () =>
                                  cart.addToCart(product),
                              icon: const Icon(
                                Icons.add_circle_outline,
                              ),
                            ),
                          ],
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}