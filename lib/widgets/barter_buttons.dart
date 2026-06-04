import 'package:flutter/material.dart';

import '../theme/barter_colors.dart';

class BarterPrimaryButton extends StatelessWidget {
  const BarterPrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.expanded = true,
    this.inverted = false,
    this.padding = const EdgeInsets.symmetric(vertical: 16),
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool expanded;
  final bool inverted;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final bc = context.barter;
    final bg = inverted ? bc.onBackground : bc.primary;
    final fg = bc.onPrimary;
    final shadow = [
      BoxShadow(
        color: (inverted ? bc.onBackground : bc.primary).withValues(alpha: 0.2),
        blurRadius: 24,
        offset: const Offset(0, 8),
      ),
    ];
    final labelWidget = Text(
      label,
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: fg,
            letterSpacing: 2,
            fontSize: 11,
          ),
    );
    final child = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        labelWidget,
        if (icon != null) ...[
          const SizedBox(width: 8),
          Icon(icon, color: fg, size: 20),
        ],
      ],
    );
    final inner = Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(999),
        child: Ink(
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(999),
            boxShadow: shadow,
          ),
          child: Padding(
            padding: padding,
            child: expanded
                ? Center(child: child)
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: child,
                  ),
          ),
        ),
      ),
    );
    if (expanded) {
      return SizedBox(width: double.infinity, child: inner);
    }
    return inner;
  }
}

class BarterTextButton extends StatelessWidget {
  const BarterTextButton({
    super.key,
    required this.label,
    this.onPressed,
  });

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final bc = context.barter;
    return TextButton(
      onPressed: onPressed,
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: bc.tertiary,
              fontWeight: FontWeight.w600,
              decoration: TextDecoration.underline,
              decorationThickness: 2,
            ),
      ),
    );
  }
}

class BarterIconCircleButton extends StatelessWidget {
  const BarterIconCircleButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.filled = false,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final bc = context.barter;
    return IconButton(
      onPressed: onPressed,
      style: IconButton.styleFrom(
        backgroundColor: filled ? bc.surfaceContainerHigh : null,
        foregroundColor: bc.onSurface,
      ),
      icon: Icon(icon, fill: filled ? 1.0 : 0.0),
    );
  }
}
