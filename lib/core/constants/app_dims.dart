import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Mirrors the shared CSS values (--r, --sh).
class AppDims {
  AppDims._();

  static const double radius = 14;
  static const double radiusSm = 10;
  static const double radiusLg = 20;

  static final List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.07),
      blurRadius: 10,
      offset: const Offset(0, 2),
    ),
  ];

  static BoxDecoration card({
    Color color = Colors.white,
    double radius = AppDims.radius,
    Color? borderColor,
    bool shadow = true,
    BorderRadiusGeometry? borderRadius,
  }) {
    return BoxDecoration(
      color: color,
      borderRadius: borderRadius ?? BorderRadius.circular(radius),
      border: Border.all(color: borderColor ?? AppColors.border),
      boxShadow: shadow ? cardShadow : null,
    );
  }
}
