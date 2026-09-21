import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final String category;
  final IconData icon;

  const CategoryCard({
    super.key,
    required this.category,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,

      child: InkWell(
        borderRadius:
            BorderRadius.circular(12),

        onTap: () {
          ScaffoldMessenger.of(context)
              .showSnackBar(
            SnackBar(
              content: Text(
                '$category selected',
              ),
            ),
          );
        },

        child: Padding(
          padding:
              const EdgeInsets.all(12),

          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center,

            children: [
              Icon(
                icon,
                size: 38,
                color: Theme.of(context)
                    .colorScheme
                    .primary,
              ),

              const SizedBox(height: 8),

              Text(
                category,

                textAlign:
                    TextAlign.center,

                style: const TextStyle(
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}