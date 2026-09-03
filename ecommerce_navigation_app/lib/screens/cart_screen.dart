import 'package:flutter/material.dart';

import '../models/product.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() =>
      _CartScreenState();
}

class _CartScreenState
    extends State<CartScreen> {

  final List<Product> cartProducts = [];

  bool argumentLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!argumentLoaded) {
      final Object? argument =
          ModalRoute.of(context)
              ?.settings
              .arguments;

      if (argument is Product) {
        cartProducts.add(argument);
      }

      argumentLoaded = true;
    }
  }

  double get total {
    double total = 0;

    for (final product in cartProducts) {
      total += product.price;
    }

    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Shopping Cart',
        ),
      ),

      body: cartProducts.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center,

                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 80,
                  ),

                  SizedBox(height: 10),

                  Text(
                    'Your cart is empty',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            )

          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount:
                        cartProducts.length,

                    itemBuilder:
                        (context, index) {
                      final product =
                          cartProducts[index];

                      return Card(
                        margin:
                            const EdgeInsets
                                .symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),

                        child: ListTile(
                          leading:
                              Image.network(
                            product.image,

                            width: 60,
                            height: 60,

                            fit: BoxFit.cover,
                          ),

                          title: Text(
                            product.name,
                          ),

                          subtitle: Text(
                            '₹${product.price}',
                          ),

                          trailing:
                              IconButton(
                            icon: const Icon(
                              Icons.delete,
                            ),

                            onPressed: () {
                              setState(() {
                                cartProducts
                                    .removeAt(
                                  index,
                                );
                              });
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // TOTAL
                Container(
                  width: double.infinity,

                  padding:
                      const EdgeInsets.all(20),

                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment
                            .spaceBetween,

                    children: [
                      const Text(
                        'Total',

                        style: TextStyle(
                          fontSize: 20,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      Text(
                        '₹${total.toStringAsFixed(2)}',

                        style:
                            const TextStyle(
                          fontSize: 22,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}