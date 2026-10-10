
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/quote.dart';

class QuoteService {
  static const String apiUrl =
      'https://dummyjson.com/quotes/random';

  Future<Quote> fetchQuote() async {
    final response = await http.get(
      Uri.parse(apiUrl),
    );

    if (response.statusCode == 200) {
      final dynamic decodedData =
          jsonDecode(response.body);

      if (decodedData is! Map<String, dynamic>) {
        throw Exception('Invalid API response.');
      }

      final quote = Quote.fromJson(decodedData);

      if (quote.quote.trim().isEmpty) {
        throw Exception('No quote available.');
      }

      return quote;
    } else {
      throw Exception(
        'Failed to load quote. '
        'Status code: ${response.statusCode}',
      );
    }
  }
}