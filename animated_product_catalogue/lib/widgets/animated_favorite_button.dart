import 'package:flutter/material.dart';

class AnimatedFavoriteButton
    extends StatefulWidget {

  const AnimatedFavoriteButton({
    super.key,
  });

  @override
  State<AnimatedFavoriteButton> createState() =>
      _AnimatedFavoriteButtonState();
}

class _AnimatedFavoriteButtonState
    extends State<AnimatedFavoriteButton>
    with SingleTickerProviderStateMixin {
  // ANIMATION CONTROLLER
  late AnimationController controller;
  // TWEEN
  late Animation<double> scaleAnimation;

  bool isFavorite = false;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(

      vsync: this,

      duration:
          const Duration(milliseconds: 400),
    );

    // ========================================================
    // TWEEN + CURVE
    // ========================================================

    scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.5,
    ).animate(

      CurvedAnimation(
        parent: controller,

        curve: Curves.elasticOut,
      ),
    );
  }
  // DISPOSE
  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }
  // FAVORITE FUNCTION
  void toggleFavorite() {

    setState(() {
      isFavorite = !isFavorite;
    });

    if (isFavorite) {
      controller.forward();
    } else {
      controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {

    return ScaleTransition(

      scale: scaleAnimation,

      child: Container(

        decoration: BoxDecoration(
          shape: BoxShape.circle,

          color: Colors.white.withOpacity(
            0.9,
          ),
        ),

        child: IconButton(

          onPressed: toggleFavorite,

          icon: Icon(

            isFavorite
                ? Icons.favorite
                : Icons.favorite_border,

            color: isFavorite
                ? Colors.red
                : Colors.grey,
          ),
        ),
      ),
    );
  }
}