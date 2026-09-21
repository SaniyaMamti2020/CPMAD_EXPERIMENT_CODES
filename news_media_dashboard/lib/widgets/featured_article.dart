import 'package:flutter/material.dart';

import '../models/news_article.dart';

class FeaturedArticle extends StatelessWidget {
  final NewsArticle article;

  const FeaturedArticle({
    super.key,
    required this.article,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),

      clipBehavior:
          Clip.antiAlias,

      child: SizedBox(
        height: 260,

        child: Stack(
          fit: StackFit.expand,

          children: [
            // IMAGE

            Image.network(
              article.image,

              fit: BoxFit.cover,

              errorBuilder:
                  (context, error, stackTrace) {
                return const Center(
                  child: Icon(
                    Icons.image,
                    size: 70,
                  ),
                );
              },
            ),

            // DARK OVERLAY

            Container(
              decoration:
                  const BoxDecoration(
                gradient: LinearGradient(
                  begin:
                      Alignment.topCenter,

                  end:
                      Alignment.bottomCenter,

                  colors: [
                    Colors.transparent,
                    Colors.black87,
                  ],
                ),
              ),
            ),

            // ARTICLE INFORMATION

            Positioned(
              left: 16,
              right: 16,
              bottom: 16,

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [
                  Container(
                    padding:
                        const EdgeInsets
                            .symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),

                    decoration:
                        BoxDecoration(
                      color: Colors.indigo,
                      borderRadius:
                          BorderRadius.circular(
                        20,
                      ),
                    ),

                    child: Text(
                      article.category,

                      style:
                          const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    article.title,

                    maxLines: 2,

                    overflow:
                        TextOverflow.ellipsis,

                    style:
                        const TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    '${article.author} • ${article.time}',

                    style:
                        const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}