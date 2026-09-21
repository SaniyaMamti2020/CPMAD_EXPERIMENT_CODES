import 'package:flutter/material.dart';

import '../models/news_article.dart';

class NewsListTile extends StatelessWidget {
  final NewsArticle article;

  const NewsListTile({
    super.key,
    required this.article,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),

      child: ListTile(
        contentPadding: const EdgeInsets.all(10),

        // News image
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),

          child: Image.network(
            article.image,

            width: 90,
            height: 80,

            fit: BoxFit.cover,

            errorBuilder: (
              context,
              error,
              stackTrace,
            ) {
              return const SizedBox(
                width: 90,
                height: 80,
                child: Icon(
                  Icons.image,
                ),
              );
            },
          ),
        ),

        // News title
        title: Text(
          article.title,

          maxLines: 2,

          overflow: TextOverflow.ellipsis,

          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        // Category and time
        subtitle: Padding(
          padding: const EdgeInsets.only(
            top: 5,
          ),

          child: Text(
            '${article.category} • ${article.time}',

            maxLines: 1,

            overflow: TextOverflow.ellipsis,
          ),
        ),

        // Arrow
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
        ),

        // Click event
        onTap: () {
          ScaffoldMessenger.of(context)
              .showSnackBar(
            SnackBar(
              content: Text(
                article.title,
              ),
            ),
          );
        },
      ),
    );
  }
}