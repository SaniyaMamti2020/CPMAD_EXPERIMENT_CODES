import 'package:flutter/material.dart';

import '../models/news_article.dart';
import '../widgets/category_card.dart';
import '../widgets/featured_article.dart';
import '../widgets/news_list_tile.dart';

class NewsDashboardScreen
    extends StatefulWidget {
  const NewsDashboardScreen({super.key});

  @override
  State<NewsDashboardScreen> createState() =>
      _NewsDashboardScreenState();
}

class _NewsDashboardScreenState
    extends State<NewsDashboardScreen> {
  // REFRESH FUNCTION
  Future<void> refreshNews() async {
    await Future.delayed(
      const Duration(seconds: 2),
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: RefreshIndicator(
        onRefresh: refreshNews,

        child: CustomScrollView(
          physics:
              const AlwaysScrollableScrollPhysics(),

          slivers: [
            // SLIVER APP BAR
            SliverAppBar(
              expandedHeight: 220,

              pinned: true,

              floating: false,

              stretch: true,

              title: const Text(
                'News Dashboard',
              ),

              actions: [
                IconButton(
                  onPressed: () {},

                  icon: const Icon(
                    Icons.search,
                  ),
                ),
              ],

              // COLLAPSING HEADER

              flexibleSpace:
                  FlexibleSpaceBar(

                titlePadding:
                    const EdgeInsets.only(
                  left: 16,
                  bottom: 16,
                ),

                background: Stack(
                  fit: StackFit.expand,

                  children: [

                    Image.network(
                      'https://images.unsplash.com/photo-1504711434969-e33886168f5c',

                      fit: BoxFit.cover,

                      errorBuilder:
                          (context, error, stackTrace) {
                        return Container(
                          color:
                              Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                        );
                      },
                    ),

                    Container(
                      decoration:
                          const BoxDecoration(
                        gradient:
                            LinearGradient(
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
                  ],
                ),
              ),
            ),
            // FEATURED ARTICLE
            SliverToBoxAdapter(
              child: FeaturedArticle(
                article: newsArticles[0],
              ),
            ),
            // CATEGORY TITLE
            const SliverToBoxAdapter(
              child: Padding(
                padding:
                    EdgeInsets.fromLTRB(
                  16,
                  10,
                  16,
                  10,
                ),

                child: Text(
                  'Categories',

                  style: TextStyle(
                    fontSize: 22,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),
            ),
            // SLIVER GRID
            SliverGrid(
              delegate:
                  SliverChildBuilderDelegate(
                (context, index) {

                  final category =
                      categories[index];

                  final icons = [
                    Icons.computer,
                    Icons.business,
                    Icons.sports_soccer,
                    Icons.health_and_safety,
                    Icons.travel_explore,
                  ];

                  return CategoryCard(
                    category: category,
                    icon: icons[index],
                  );
                },

                childCount:
                    categories.length,
              ),

              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(

                crossAxisCount: 2,

                mainAxisSpacing: 8,

                crossAxisSpacing: 8,

                mainAxisExtent: 110,
              ),
            ),
            // NEWS TITLE
            const SliverToBoxAdapter(
              child: Padding(
                padding:
                    EdgeInsets.fromLTRB(
                  16,
                  25,
                  16,
                  10,
                ),

                child: Text(
                  'Latest News',

                  style: TextStyle(
                    fontSize: 22,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),
            ),
            // SLIVER LIST
            SliverList(
              delegate:
                  SliverChildBuilderDelegate(
                (context, index) {

                  final article =
                      newsArticles[index];

                  return NewsListTile(
                    article: article,
                  );
                },

                childCount:
                    newsArticles.length,
              ),
            ),
            // BOTTOM SPACE
            const SliverToBoxAdapter(
              child: SizedBox(
                height: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }
}