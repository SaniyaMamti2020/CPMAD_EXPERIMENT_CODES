import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cart, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('My Cart'),
          ),
          body: cart.cartProducts.isEmpty
              ? const Center(
                  child: Text(
                    'Your cart is empty!',
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: cart.cartProducts.length,
                        itemBuilder: (context, index) {
                          final product = cart.cartProducts[index];
                          final quantity =
                              cart.quantityOf(product.id);

                          return Card(
                            margin: const EdgeInsets.all(8),
                            child: ListTile(
                              leading: Image.network(
                                product.image,
                                width: 50,
                                height: 50,
                                fit: BoxFit.contain,
                                errorBuilder: (_, __, ___) =>
                                    const Icon(Icons.image),
                              ),
                              title: Text(
                                product.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '₹${product.price.toStringAsFixed(2)} each',
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () =>
                                            cart.removeOne(product.id),
                                        icon: const Icon(
                                          Icons.remove_circle_outline,
                                        ),
                                      ),
                                      Text('$quantity'),
                                      IconButton(
                                        onPressed: () =>
                                            cart.addToCart(product),
                                        icon: const Icon(
                                          Icons.add_circle_outline,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              trailing: IconButton(
                                onPressed: () =>
                                    cart.removeFromCart(product.id),
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      child: Column(
                        children: [
                          _priceRow(
                            'Total Quantity',
                            '${cart.totalQuantity}',
                          ),
                          _priceRow(
                            'Subtotal',
                            '₹${cart.subtotal.toStringAsFixed(2)}',
                          ),
                          const Divider(),
                          _priceRow(
                            'Total',
                            '₹${cart.total.toStringAsFixed(2)}',
                            bold: true,
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Checkout demo completed!',
                                    ),
                                  ),
                                );
                              },
                              child: const Text('Proceed to Checkout'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }

  Widget _priceRow(
    String label,
    String value, {
    bool bold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}