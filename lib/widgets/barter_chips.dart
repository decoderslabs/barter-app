import 'package:flutter/material.dart';

import '../theme/barter_colors.dart';

enum BarterChipVariant { sort, filter, niche, platform, status, mini }

class BarterChip extends StatelessWidget {
  const BarterChip({
    super.key,
    required this.label,
    required this.variant,
    this.selected = false,
    this.onTap,
    this.icon,
    this.showClose = false,
    this.bgColor,
    this.fgColor,
    this.padding,
  });

  final String label;
  final BarterChipVariant variant;
  final bool selected;
  final VoidCallback? onTap;
  final IconData? icon;
  final bool showClose;
  final Color? bgColor;
  final Color? fgColor;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final bc = context.barter;
    
    Color backgroundColor;
    Color foregroundColor;
    BorderRadius borderRadius;
    EdgeInsetsGeometry defaultPadding;
    bool showDropdownIcon = false;
    
    switch (variant) {
      case BarterChipVariant.sort:
        backgroundColor = selected ? bc.primary : bc.surfaceContainerHighest;
        foregroundColor = selected ? bc.onPrimary : bc.onSurfaceVariant;
        borderRadius = BorderRadius.circular(999);
        defaultPadding = const EdgeInsets.symmetric(horizontal: 22, vertical: 10);
        break;
      case BarterChipVariant.filter:
        backgroundColor = selected ? bc.primaryFixed : bc.surfaceContainerLow;
        foregroundColor = selected ? bc.primary : bc.onSurface;
        borderRadius = BorderRadius.circular(8);
        defaultPadding = const EdgeInsets.symmetric(horizontal: 10, vertical: 8);
        showDropdownIcon = true;
        break;
      case BarterChipVariant.niche:
        backgroundColor = selected ? bc.primary : bc.surfaceContainerLow;
        foregroundColor = selected ? bc.onPrimary : bc.onSurface;
        borderRadius = BorderRadius.circular(999);
        defaultPadding = const EdgeInsets.symmetric(horizontal: 22, vertical: 12);
        break;
      case BarterChipVariant.platform:
        backgroundColor = selected ? bc.primary : bc.surfaceContainerLow;
        foregroundColor = selected ? bc.onPrimary : bc.onSurfaceVariant;
        borderRadius = BorderRadius.circular(999);
        defaultPadding = const EdgeInsets.symmetric(horizontal: 20, vertical: 12);
        break;
      case BarterChipVariant.status:
        backgroundColor = bgColor ?? bc.surfaceContainerLow;
        foregroundColor = fgColor ?? bc.onSurface;
        borderRadius = BorderRadius.circular(999);
        defaultPadding = const EdgeInsets.symmetric(horizontal: 10, vertical: 6);
        break;
      case BarterChipVariant.mini:
        backgroundColor = bgColor ?? (selected ? bc.primaryFixed : bc.surfaceContainerLow);
        foregroundColor = fgColor ?? (selected ? bc.primary : bc.tertiary);
        borderRadius = BorderRadius.circular(999);
        defaultPadding = const EdgeInsets.symmetric(horizontal: 10, vertical: 6);
        break;
    }

    return Material(
      color: backgroundColor,
      borderRadius: borderRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius,
        child: Padding(
          padding: padding ?? defaultPadding,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: variant == BarterChipVariant.mini ? 14 : 18,
                  color: foregroundColor,
                  fill: selected ? 1.0 : 0.0,
                ),
                const SizedBox(width: 8),
              ],
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: variant == BarterChipVariant.niche 
                          ? FontWeight.w800 
                          : FontWeight.w600,
                      letterSpacing: variant == BarterChipVariant.sort ? 0.5 : null,
                      color: foregroundColor,
                    ),
              ),
              if (showClose && selected) ...[
                const SizedBox(width: 6),
                Icon(Icons.close, size: 16, color: foregroundColor),
              ],
              if (showDropdownIcon) ...[
                const SizedBox(width: 4),
                Icon(Icons.expand_more, size: 18, color: foregroundColor),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
