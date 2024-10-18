import 'package:flutter/material.dart';

class AnimatedImageWidget extends StatelessWidget {
  final Animation<double> animation;
  final String assetPath;
  final double top;
  final double left;
  final double size;

  const AnimatedImageWidget({
    Key? key,
    required this.animation,
    required this.assetPath,
    required this.top,
    required this.left,
    this.size = 150.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Positioned(
          top: top,
          left: left,
          child: Opacity(
            opacity: animation.value,
            child: ClipOval(
              child: SizedBox(
                width: size,
                height: size,
                child: Image.asset(
                  assetPath,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
