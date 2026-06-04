import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../theme/barter_colors.dart';
import '../../theme/responsive_extension.dart';
import '../../widgets/barter_card.dart';
import '../../widgets/barter_chips.dart';

class DealBriefScreen extends ConsumerWidget {
  const DealBriefScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bc = context.barter;
    final wide = context.isWide;

    return Scaffold(
      backgroundColor: bc.background,
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(wide ? 48 : 20, wide ? 40 : 24, wide ? 48 : 20, 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Deal Brief',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Review and manage deal briefs and contracts.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: bc.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 32),
            _BriefCard(
              title: 'Summer Drops 2024 - Sarah Chen',
              campaign: 'Summer Drops 2024',
              status: 'Active',
              statusColor: bc.success,
              deliverables: ['IG Reel', 'Story Series'],
              value: '4200',
              bc: bc,
            ),
            const SizedBox(height: 16),
            _BriefCard(
              title: 'Back to School - Marcus Johnson',
              campaign: 'Back to School Collab',
              status: 'Pending',
              statusColor: bc.warning,
              deliverables: ['YouTube Video'],
              value: '3800',
              bc: bc,
            ),
            const SizedBox(height: 16),
            _BriefCard(
              title: 'Holiday Collection - Priya Sharma',
              campaign: 'Holiday Collection',
              status: 'Draft',
              statusColor: bc.tertiary,
              deliverables: ['Blog Post', 'IG Carousel'],
              value: '5200',
              bc: bc,
            ),
          ],
        ),
      ),
    );
  }
}

class _BriefCard extends StatelessWidget {
  const _BriefCard({
    required this.title,
    required this.campaign,
    required this.status,
    required this.statusColor,
    required this.deliverables,
    required this.value,
    required this.bc,
  });

  final String title;
  final String campaign;
  final String status;
  final Color statusColor;
  final List<String> deliverables;
  final String value;
  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return BarterCard(
      padding: const EdgeInsets.all(24),
      borderColor: bc.outlineVariant.withValues(alpha: 0.15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              BarterChip(
                label: status.toUpperCase(),
                variant: BarterChipVariant.status,
                bgColor: statusColor.withValues(alpha: 0.1),
                fgColor: statusColor,
              ),
              const Spacer(),
              Icon(
                Symbols.description,
                color: bc.onSurfaceVariant.withValues(alpha: 0.45),
                size: 20,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            'Campaign: $campaign',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: bc.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: deliverables
                .map(
                  (d) => BarterChip(label: d, variant: BarterChipVariant.mini),
                )
                .toList(),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                'Deal Value: ',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: bc.onSurfaceVariant,
                    ),
              ),
              Text(
                '$value INR',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: bc.primary,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
