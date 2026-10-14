import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import '../widgets/product_card.dart';
import 'cart_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String searchText = '';
  String selectedCategory = 'All';
  bool showWishlist = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cart, child) {
        final categories = [
          'All',
          ...cart.products
              .map((product) => product.category)
              .toSet()
              .toList()
            ..sort(),
        ];

        final sourceProducts = showWishlist
            ? cart.wishlistProducts
            : cart.products;

        final filteredProducts = sourceProducts.where((product) {
          final matchesSearch = product.title
              .toLowerCase()
              .contains(searchText.toLowerCase());

          final matchesCategory = selectedCategory == 'All' ||
              product.category == selectedCategory;

          return matchesSearch && matchesCategory;
        }).toList();

        return Scaffold(
          appBar: AppBar(
            title: const Text('Shopping Cart'),
            actions: [
              IconButton(
                tooltip: 'Wishlist',
                onPressed: () {
                  setState(() {
                    showWishlist = !showWishlist;
                  });
                },
                icon: Icon(
                  showWishlist
                      ? Icons.favorite
                      : Icons.favorite_border,
                ),
              ),
              Stack(
                alignment: Alignment.topRight,
                children: [
                  IconButton(
                    tooltip: 'Cart',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CartScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.shopping_cart),
                  ),
                  if (cart.totalQuantity > 0)
                    Positioned(
                      right: 4,
                      top: 2,
                      child: CircleAvatar(
                        radius: 9,
                        backgroundColor: Colors.red,
                        child: Text(
                          '${cart.totalQuantity}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
          body: _buildBody(
            cart,
            categories,
            filteredProducts,
          ),
        );
      },
    );
  }

  Widget _buildBody(
    CartProvider cart,
    List<String> categories,
    List<dynamic> filteredProducts,
  ) {
    if (cart.isLoading && cart.products.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (cart.errorMessage != null && cart.products.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Unable to load products.\n${cart.errorMessage}',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: cart.loadProducts,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            decoration: const InputDecoration(
              hintText: 'Search products...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              setState(() {
                searchText = value;
              });
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: DropdownButtonFormField<String>(
            value: categories.contains(selectedCategory)
                ? selectedCategory
                : 'All',
            decoration: const InputDecoration(
              labelText: 'Filter by category',
              border: OutlineInputBorder(),
            ),
            items: categories.map((category) {
              return DropdownMenuItem(
                value: category,
                child: Text(category),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedCategory = value ?? 'All';
              });
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            showWishlist ? 'My Wishlist' : 'All Products',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: filteredProducts.isEmpty
              ? const Center(
                  child: Text('No products found.'),
                )
              : GridView.builder(
                  padding: const EdgeInsets.all(8),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.56,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: filteredProducts.length,
                  itemBuilder: (context, index) {
                    return ProductCard(
                      product: filteredProducts[index],
                    );
                  },
                ),
        ),
      ],
    );
  }
}