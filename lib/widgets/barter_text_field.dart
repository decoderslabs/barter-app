import 'package:flutter/material.dart';

import '../theme/barter_colors.dart';

class BarterSearchField extends StatelessWidget {
  const BarterSearchField({
    super.key,
    this.controller,
    this.hint,
    this.onChanged,
    this.prefixIcon,
  });

  final TextEditingController? controller;
  final String? hint;
  final ValueChanged<String>? onChanged;
  final Widget? prefixIcon;

  @override
  Widget build(BuildContext context) {
    final bc = context.barter;
    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: Theme.of(context).textTheme.bodyLarge,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: bc.onSurfaceVariant.withValues(alpha: 0.45),
            ),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 12, right: 8),
          child: prefixIcon ??
              Icon(Icons.search, color: bc.onSurfaceVariant, size: 22),
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 48, minHeight: 48),
        filled: true,
        fillColor: bc.surfaceContainerLow,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
      ),
    );
  }
}

class BarterLabeledField extends StatelessWidget {
  const BarterLabeledField({
    super.key,
    required this.label,
    this.controller,
    this.hint,
    this.maxLines = 1,
    this.keyboardType,
  });

  final String label;
  final TextEditingController? controller;
  final String? hint;
  final int maxLines;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    final bc = context.barter;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 6),
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontSize: 11,
                  letterSpacing: 2,
                  color: bc.onSurfaceVariant.withValues(alpha: 0.7),
                ),
          ),
        ),
        TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          style: Theme.of(context).textTheme.bodyMedium,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: bc.onSurfaceVariant.withValues(alpha: 0.35),
            ),
          ),
        ),
      ],
    );
  }
}
