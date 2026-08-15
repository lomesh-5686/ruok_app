import 'package:flutter/material.dart';

class SplashGlowOrb extends StatelessWidget {
  final double? left;
  final double? top;
  final double? right;
  final double? bottom;
  final Color color;
  final double size;

  const SplashGlowOrb({
    super.key,
    this.left,
    this.top,
    this.right,
    this.bottom,
    required this.color,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      top: top,
      right: right,
      bottom: bottom,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
      ),
    );
  }
}
