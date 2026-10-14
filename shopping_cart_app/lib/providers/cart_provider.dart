import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/product.dart';
import '../services/product_service.dart';

class CartProvider extends ChangeNotifier {
  final ProductService _service = ProductService();

  List<Product> products = [];
  bool isLoading = false;
  String? errorMessage;

  // Product ID -> quantity
  final Map<int, int> _cart = {};

  // Store wishlist product IDs.
  final Set<int> _wishlist = {};

  Map<int, int> get cart => Map.unmodifiable(_cart);

  Set<int> get wishlist => Set.unmodifiable(_wishlist);

  int get totalQuantity =>
      _cart.values.fold(0, (sum, quantity) => sum + quantity);

  double get subtotal {
    double amount = 0;

    for (final entry in _cart.entries) {
      final product = products.firstWhere(
        (p) => p.id == entry.key,
        orElse: () => Product(
          id: entry.key,
          title: '',
          price: 0,
          description: '',
          category: '',
          image: '',
          rating: 0,
        ),
      );

      amount += product.price * entry.value;
    }

    return amount;
  }

  // Example: total equals subtotal, with no extra charges.
  double get total => subtotal;

  List<Product> get cartProducts => products
      .where((product) => _cart.containsKey(product.id))
      .toList();

  List<Product> get wishlistProducts => products
      .where((product) => _wishlist.contains(product.id))
      .toList();

  int quantityOf(int productId) => _cart[productId] ?? 0;

  bool isWishlisted(int productId) =>
      _wishlist.contains(productId);

  Future<void> loadProducts() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      products = await _service.fetchProducts();
      await restoreCart();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void addToCart(Product product) {
    _cart[product.id] = quantityOf(product.id) + 1;
    _saveCart();
    notifyListeners();
  }

  void removeOne(int productId) {
    if (!_cart.containsKey(productId)) return;

    if (_cart[productId]! > 1) {
      _cart[productId] = _cart[productId]! - 1;
    } else {
      _cart.remove(productId);
    }

    _saveCart();
    notifyListeners();
  }

  void removeFromCart(int productId) {
    _cart.remove(productId);
    _saveCart();
    notifyListeners();
  }

  void toggleWishlist(int productId) {
    if (_wishlist.contains(productId)) {
      _wishlist.remove(productId);
    } else {
      _wishlist.add(productId);
    }

    notifyListeners();
  }

  Future<void> _saveCart() async {
    final prefs = await SharedPreferences.getInstance();

    final cartData = _cart.map(
      (key, value) => MapEntry(key.toString(), value),
    );

    await prefs.setString(
      'shopping_cart',
      cartData.entries
          .map((entry) => '${entry.key}:${entry.value}')
          .join(','),
    );
  }

  Future<void> restoreCart() async {
    final prefs = await SharedPreferences.getInstance();
    final savedCart = prefs.getString('shopping_cart');

    if (savedCart == null || savedCart.isEmpty) return;

    _cart.clear();

    for (final item in savedCart.split(',')) {
      final parts = item.split(':');

      if (parts.length == 2) {
        final id = int.tryParse(parts[0]);
        final quantity = int.tryParse(parts[1]);

        if (id != null &&
            quantity != null &&
            quantity > 0 &&
            products.any((p) => p.id == id)) {
          _cart[id] = quantity;
        }
      }
    }

    notifyListeners();
  }
}