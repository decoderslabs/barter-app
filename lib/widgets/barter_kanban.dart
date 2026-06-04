import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../theme/barter_colors.dart';

class BarterKanbanColumn extends StatelessWidget {
  const BarterKanbanColumn({
    super.key,
    required this.title,
    required this.count,
    required this.cards,
    this.accentColor,
  });

  final String title;
  final int count;
  final List<Widget> cards;
  final Color? accentColor;

  @override
  Widget build(BuildContext context) {
    final bc = context.barter;
    final accent = accentColor ?? bc.primary;
    return Container(
      width: 300,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 0, 4, 12),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: accent,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  title.toUpperCase(),
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontSize: 11,
                        letterSpacing: 2,
                        color: bc.onSurface,
                      ),
                ),
                const Spacer(),
                Text(
                  count.toString(),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: bc.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(bottom: 24),
              children: cards,
            ),
          ),
        ],
      ),
    );
  }
}

class BarterPipelineCard extends StatelessWidget {
  const BarterPipelineCard({
    super.key,
    required this.creatorName,
    required this.offerTitle,
    required this.tags,
    this.avatarUrl,
    this.brandInitial = 'B',
  });

  final String creatorName;
  final String offerTitle;
  final List<String> tags;
  final String? avatarUrl;
  final String brandInitial;

  @override
  Widget build(BuildContext context) {
    final bc = context.barter;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bc.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: bc.onBackground.withValues(alpha: 0.05),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: bc.surfaceContainerHigh,
                child: Text(
                  brandInitial,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  creatorName,
                  style: Theme.of(context).textTheme.titleSmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(Symbols.more_horiz, color: bc.onSurfaceVariant, size: 20),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            offerTitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: tags
                .map(
                  (t) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: bc.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      t,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontSize: 9,
                            letterSpacing: 0.5,
                          ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
