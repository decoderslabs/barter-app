import 'package:flutter/material.dart';

import '../theme/barter_colors.dart';

class BarterCard extends StatelessWidget {
  const BarterCard({
    super.key,
    required this.child,
    this.padding,
    this.borderColor,
    this.borderRadius = 24,
    this.borderWidth = 1,
    this.border,
    this.onTap,
    this.backgroundColor,
    this.shadow,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? borderColor;
  final double borderRadius;
  final double borderWidth;
  final BoxBorder? border;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final List<BoxShadow>? shadow;

  @override
  Widget build(BuildContext context) {
    final bc = context.barter;
    
    final effectiveBackgroundColor = backgroundColor ?? bc.surfaceContainerLowest;
    final effectiveShadow = shadow ?? [
      BoxShadow(
        color: bc.onBackground.withValues(alpha: 0.04),
        blurRadius: 30,
        offset: const Offset(0, 12),
      ),
    ];

    // Use border if provided, otherwise use borderColor/borderWidth
    final effectiveBorder = border ?? (borderColor != null ? Border.all(color: borderColor!, width: borderWidth) : null);

    Widget card = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: effectiveBorder,
        boxShadow: effectiveShadow,
      ),
      child: child,
    );

    if (onTap != null) {
      card = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          child: card,
        ),
      );
    }

    return card;
  }
}

class BarterCardSmall extends StatelessWidget {
  const BarterCardSmall({
    super.key,
    required this.child,
    this.padding,
    this.border,
    this.onTap,
    this.backgroundColor,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final BoxBorder? border;
  final VoidCallback? onTap;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return BarterCard(
      borderRadius: 16,
      padding: padding ?? const EdgeInsets.all(16),
      border: border,
      onTap: onTap,
      backgroundColor: backgroundColor,
      child: child,
    );
  }
}
