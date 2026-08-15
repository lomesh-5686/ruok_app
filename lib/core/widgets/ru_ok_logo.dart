import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../constants/app_assets.dart';

class RuOkLogo extends StatelessWidget {
  final double? width;
  final double? height;
  final bool showText;

  const RuOkLogo({
    super.key,
    this.width,
    this.height,
    this.showText = true,
  });

  @override
  Widget build(BuildContext context) {
    final double targetWidth = width ?? 160.w;
    final double targetHeight = height ?? 190.h;

    return SvgPicture.asset(
      AppAssets.appLogo,
      width: targetWidth,
      height: targetHeight,
      fit: BoxFit.contain,
    );
  }
}
