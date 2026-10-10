
import 'package:flutter/material.dart';
import 'models/quote.dart';
import 'services/quote_service.dart';

void main() {
  runApp(const QuoteApp());
}

class QuoteApp extends StatelessWidget {
  const QuoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quote App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
        useMaterial3: true,
      ),
      home: const QuoteHomePage(),
    );
  }
}

class QuoteHomePage extends StatefulWidget {
  const QuoteHomePage({super.key});

  @override
  State<QuoteHomePage> createState() =>
      _QuoteHomePageState();
}

class _QuoteHomePageState extends State<QuoteHomePage> {
  final QuoteService quoteService = QuoteService();

  late Future<Quote> quoteFuture;

  @override
  void initState() {
    super.initState();

    // Fetch the first quote when the screen opens.
    quoteFuture = quoteService.fetchQuote();
  }

  // Fetch another quote.
  void getAnotherQuote() {
    setState(() {
      quoteFuture = quoteService.fetchQuote();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Quotes'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),

      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFEDE7F6),
              Color(0xFFF3E5F5),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

        child: FutureBuilder<Quote>(
          future: quoteFuture,

          builder: (context, snapshot) {
            // Loading state
            if (snapshot.connectionState ==
                ConnectionState.waiting) {
              return const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Loading quote...'),
                  ],
                ),
              );
            }

            // Error state
            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Unable to load quote.',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Please check your internet '
                      'connection and try again.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: getAnotherQuote,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Try Again'),
                    ),
                  ],
                ),
              );
            }

            // Empty-response state
            if (!snapshot.hasData ||
                snapshot.data == null ||
                snapshot.data!.quote.trim().isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.format_quote,
                      size: 64,
                    ),
                    const SizedBox(height: 12),
                    const Text('No quote available.'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: getAnotherQuote,
                      child: const Text('Try Again'),
                    ),
                  ],
                ),
              );
            }

            // Successful-response state
            final Quote quote = snapshot.data!;

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.format_quote,
                  size: 65,
                  color: Colors.deepPurple,
                ),

                const SizedBox(height: 20),

                Card(
                  elevation: 6,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),

                  child: Padding(
                    padding: const EdgeInsets.all(24),

                    child: Column(
                      children: [
                        Text(
                          quote.quote,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 22,
                            height: 1.6,
                            fontStyle: FontStyle.italic,
                          ),
                        ),

                        const SizedBox(height: 24),

                        const Divider(),

                        const SizedBox(height: 12),

                        Text(
                          '— ${quote.author}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                ElevatedButton.icon(
                  onPressed: getAnotherQuote,
                  icon: const Icon(Icons.refresh),
                  label: const Text('New Quote'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 16,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}