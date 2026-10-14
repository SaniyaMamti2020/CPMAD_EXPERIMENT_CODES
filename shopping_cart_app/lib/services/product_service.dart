import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ProductService {
  static const String apiUrl =
      'https://fakestoreapi.com/products';

  Future<List<Product>> fetchProducts() async {
    final response = await http
        .get(Uri.parse(apiUrl))
        .timeout(const Duration(seconds: 20));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      return data
          .map((item) => Product.fromJson(item))
          .toList();
    } else {
      throw Exception(
        'Failed to load products: ${response.statusCode}',
      );
    }
  }
}