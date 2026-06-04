import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../theme/barter_colors.dart';
import '../../theme/responsive_extension.dart';

class BrandCampaignsScreen extends ConsumerWidget {
  const BrandCampaignsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bc = context.barter;
    final wide = context.isWide;

    return Scaffold(
      backgroundColor: bc.background,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/brand/campaigns/create'),
        backgroundColor: bc.primary,
        foregroundColor: bc.onPrimary,
        icon: const Icon(Symbols.add),
        label: const Text('NEW CAMPAIGN'),
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.fromLTRB(wide ? 48 : 20, wide ? 40 : 24, wide ? 48 : 20, 32),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Campaigns',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (_) => SafeArea(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(title: const Text('Filter by Status'), onTap: () => Navigator.pop(context)),
                                  ListTile(title: const Text('Filter by Date'), onTap: () => Navigator.pop(context)),
                                  ListTile(title: const Text('Filter by Budget'), onTap: () => Navigator.pop(context)),
                                ],
                              ),
                            ),
                          );
                        },
                        icon: Icon(Symbols.tune, color: bc.onSurfaceVariant),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Manage your active and draft campaigns.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: bc.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
          ),
          // Lazy-loaded campaign cards
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: wide ? 48 : 20),
            sliver: SliverList.separated(
              itemCount: 3,
              itemBuilder: (context, index) {
                final campaigns = [
                  (
                    title: 'Summer Drops 2024',
                    status: 'Active',
                    statusColor: bc.success,
                    creatorsCount: 24,
                    deadline: 'Aug 15, 2024',
                  ),
                  (
                    title: 'Back to School Collab',
                    status: 'Draft',
                    statusColor: bc.warning,
                    creatorsCount: 0,
                    deadline: 'Sep 1, 2024',
                  ),
                  (
                    title: 'Holiday Collection',
                    status: 'Planning',
                    statusColor: bc.tertiary,
                    creatorsCount: 8,
                    deadline: 'Nov 20, 2024',
                  ),
                ];
                final c = campaigns[index];
                return _CampaignCard(
                  title: c.title,
                  status: c.status,
                  statusColor: c.statusColor,
                  creatorsCount: c.creatorsCount,
                  deadline: c.deadline,
                  onTap: () => context.go('/brand/drops'),
                );
              },
              separatorBuilder: (_, __) => const SizedBox(height: 16),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 120)),
        ],
      ),
    );
  }
}

class _CampaignCard extends StatelessWidget {
  const _CampaignCard({
    required this.title,
    required this.status,
    required this.statusColor,
    required this.creatorsCount,
    required this.deadline,
    this.onTap,
  });

  final String title;
  final String status;
  final Color statusColor;
  final int creatorsCount;
  final String deadline;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final bc = context.barter;
    return Material(
      color: bc.surfaceContainerLowest,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: bc.outlineVariant.withValues(alpha: 0.15),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      status.toUpperCase(),
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontSize: 10,
                            color: statusColor,
                          ),
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Symbols.more_vert,
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
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(
                    Symbols.group,
                    size: 16,
                    color: bc.onSurfaceVariant.withValues(alpha: 0.6),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '$creatorsCount creators',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: bc.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(width: 20),
                  Icon(
                    Symbols.calendar_today,
                    size: 16,
                    color: bc.onSurfaceVariant.withValues(alpha: 0.6),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    deadline,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: bc.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );  
  }
}
