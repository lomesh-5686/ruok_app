import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashCurveWidget extends StatelessWidget {
  final double? left;
  final double? top;
  final double? right;
  final double? bottom;
  final String asset;
  final double width;
  final double height;

  const SplashCurveWidget({
    super.key,
    this.left,
    this.top,
    this.right,
    this.bottom,
    required this.asset,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      top: top,
      right: right,
      bottom: bottom,
      child: SvgPicture.asset(
        asset,
        width: width,
        height: height,
        fit: BoxFit.fill,
      ),
    );
  }
}
