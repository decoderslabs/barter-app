import 'package:flutter/material.dart';

import '../theme/barter_colors.dart';

/// Editorial card shadow from Stitch HTML (`0_10px_40px_rgba(26,26,46,0.06)`).
class BarterEditorialShadow extends StatelessWidget {
  const BarterEditorialShadow({
    super.key,
    required this.child,
    this.borderRadius,
    this.padding,
    this.color,
  });

  final Widget child;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final bc = context.barter;
    final r = borderRadius ?? BorderRadius.circular(16);
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? bc.surfaceContainerLowest,
        borderRadius: r,
        boxShadow: [
          BoxShadow(
            color: bc.onBackground.withValues(alpha: 0.06),
            blurRadius: 40,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(borderRadius: r, child: child),
    );
  }
}
