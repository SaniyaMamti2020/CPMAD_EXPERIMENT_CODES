import 'package:flutter/material.dart';

import '../models/product.dart';
import 'animated_favorite_button.dart';

class AnimatedProductCard
    extends StatefulWidget {

  final Product product;

  final VoidCallback onTap;

  const AnimatedProductCard({
    super.key,
    required this.product,
    required this.onTap,
  });

  @override
  State<AnimatedProductCard> createState() =>
      _AnimatedProductCardState();
}

class _AnimatedProductCardState
    extends State<AnimatedProductCard> {

  bool isHovered = false;

  @override
  Widget build(BuildContext context) {

    return GestureDetector(

      onTap: widget.onTap,

      onLongPress: () {

        setState(() {
          isHovered = !isHovered;
        });
      },

      child: AnimatedContainer(

        duration:
            const Duration(milliseconds: 500),

        curve: Curves.easeInOutBack,

        transform: Matrix4.identity()
          ..scale(
            isHovered ? 1.04 : 1.0,
          ),

        decoration: BoxDecoration(

          borderRadius:
              BorderRadius.circular(18),

          boxShadow: [
            BoxShadow(
              blurRadius:
                  isHovered ? 15 : 5,

              spreadRadius:
                  isHovered ? 3 : 0,

              color:
                  Colors.black.withOpacity(
                0.15,
              ),
            ),
          ],
        ),

        child: Card(

          clipBehavior:
              Clip.antiAlias,

          child: Column(

            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [
              // PRODUCT IMAGE + HERO
              Expanded(

                child: Stack(

                  children: [

                    Positioned.fill(

                      child: Hero(

                        tag:
                            'product-${widget.product.id}',

                        child: Image.network(

                          widget.product.image,

                          fit: BoxFit.cover,

                          errorBuilder:
                              (context, error, stackTrace) {

                            return const Center(
                              child: Icon(
                                Icons.image,
                                size: 60,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    // FAVORITE BUTTON
                    Positioned(
                      top: 8,
                      right: 8,

                      child:
                          AnimatedFavoriteButton(),
                    ),
                  ],
                ),
              ),
              // PRODUCT INFORMATION
              Padding(
                padding:
                    const EdgeInsets.all(10),

                child: Column(

                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    Text(
                      widget.product.name,

                      maxLines: 1,

                      overflow:
                          TextOverflow.ellipsis,

                      style:
                          const TextStyle(
                        fontSize: 16,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      widget.product.category,

                      style: TextStyle(
                        color:
                            Colors.grey.shade600,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      '₹${widget.product.price.toStringAsFixed(0)}',

                      style:
                          const TextStyle(
                        fontSize: 17,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}