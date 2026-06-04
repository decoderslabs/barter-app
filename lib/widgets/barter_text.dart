import 'package:flutter/material.dart';

import '../theme/barter_colors.dart';

class BarterSectionLabel extends StatelessWidget {
  const BarterSectionLabel({
    super.key,
    required this.label,
    this.color,
    this.fontSize = 10,
    this.letterSpacing = 2,
    this.fontWeight = FontWeight.w800,
  });

  final String label;
  final Color? color;
  final double fontSize;
  final double letterSpacing;
  final FontWeight fontWeight;

  @override
  Widget build(BuildContext context) {
    final bc = context.barter;
    return Text(
      label.toUpperCase(),
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
            fontSize: fontSize,
            letterSpacing: letterSpacing,
            fontWeight: fontWeight,
            color: color ?? bc.onSurfaceVariant.withValues(alpha: 0.7),
          ),
    );
  }
}
