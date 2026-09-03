import 'package:flutter/material.dart';

import 'product_list_screen.dart';
import 'profile_screen.dart';
import 'cart_screen.dart';
import '../models/product.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() =>
      _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  final List<Widget> pages = const [
    HomeContent(),
    ProductListScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Shopping Application',
        ),
        centerTitle: true,

        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/cart',
              );
            },
            icon: const Icon(
              Icons.shopping_cart,
            ),
          ),
        ],
      ),

      // =========================
      // DRAWER
      // =========================

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const UserAccountsDrawerHeader(
              accountName: Text(
                'Student',
              ),
              accountEmail: Text(
                'student@example.com',
              ),
              currentAccountPicture:
                  CircleAvatar(
                child: Icon(
                  Icons.person,
                  size: 35,
                ),
              ),
            ),

            ListTile(
              leading: const Icon(
                Icons.home,
              ),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);

                setState(() {
                  currentIndex = 0;
                });
              },
            ),

            ListTile(
              leading: const Icon(
                Icons.shopping_bag,
              ),
              title: const Text('Products'),
              onTap: () {
                Navigator.pop(context);

                setState(() {
                  currentIndex = 1;
                });
              },
            ),

            ListTile(
              leading: const Icon(
                Icons.person,
              ),
              title: const Text('Profile'),
              onTap: () {
                Navigator.pop(context);

                setState(() {
                  currentIndex = 2;
                });
              },
            ),

            const Divider(),

            ListTile(
              leading: const Icon(
                Icons.shopping_cart,
              ),
              title: const Text('Cart'),
              onTap: () {
                Navigator.pop(context);

                Navigator.pushNamed(
                  context,
                  '/cart',
                );
              },
            ),
          ],
        ),
      ),

      // =========================
      // BODY
      // =========================

      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),

      // =========================
      // BOTTOM NAVIGATION
      // =========================

      bottomNavigationBar:
          BottomNavigationBar(
        currentIndex: currentIndex,

        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Products',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// ============================================================
// HOME CONTENT
// ============================================================

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          // =========================
          // WELCOME CONTAINER
          // =========================

          Container(
            width: double.infinity,

            padding: const EdgeInsets.all(25),

            decoration: BoxDecoration(
              color: Theme.of(context)
                  .colorScheme
                  .primaryContainer,

              borderRadius:
                  BorderRadius.circular(20),
            ),

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                const Text(
                  'Welcome to Our Store',

                  style: TextStyle(
                    fontSize: 26,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  'Discover amazing products '
                  'at great prices.',
                ),

                const SizedBox(height: 15),

                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/products',
                    );
                  },

                  child: const Text(
                    'Shop Now',
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 25),

          const Text(
            'Featured Product',

            style: TextStyle(
              fontSize: 22,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          // =========================
          // FEATURED PRODUCT
          // =========================

          GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                '/product-details',
                arguments: products[0],
              );
            },

            child: Card(
              child: Padding(
                padding:
                    const EdgeInsets.all(12),

                child: Row(
                  children: [
                    Image.network(
                      products[0].image,

                      width: 100,
                      height: 100,

                      fit: BoxFit.cover,
                    ),

                    const SizedBox(width: 15),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,

                        children: [
                          Text(
                            products[0].name,

                            style:
                                const TextStyle(
                              fontSize: 18,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 5),

                          Text(
                            products[0].category,
                          ),

                          const SizedBox(height: 5),

                          Text(
                            '₹${products[0].price}',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}