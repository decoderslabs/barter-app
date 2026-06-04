import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../data/models/membership_model.dart';
import '../../../providers/app_providers.dart';
import '../../../theme/barter_colors.dart';
import '../../../widgets/barter_appbar.dart';
import '../../../widgets/barter_chips.dart';
import '../../../widgets/barter_network_image.dart';

class EarnMembershipScreen extends ConsumerStatefulWidget {
  const EarnMembershipScreen({super.key});

  @override
  ConsumerState<EarnMembershipScreen> createState() => _EarnMembershipScreenState();
}

class _EarnMembershipScreenState extends ConsumerState<EarnMembershipScreen> {
  final _selected = <String>{};

  @override
  Widget build(BuildContext context) {
    final bc = context.barter;
    final membership = ref.watch(membershipProvider);
    return Scaffold(
      backgroundColor: bc.background,
      appBar: BarterAppBar(
        showBrandTitle: false,
        title: 'Earn Pro',
        leading: const BarterBackButton(),
      ),
      body: membership.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (payload) => _buildBody(context, bc, payload),
      ),
      bottomNavigationBar: membership.maybeWhen(
        data: (payload) => _BottomSummary(
          selectedCount: _selected.length,
          selectedPoints: payload.tasks
              .where((task) => _selected.contains(task.id))
              .fold<int>(0, (sum, task) => sum + task.points),
          enabled: _selected.isNotEmpty,
          bc: bc,
          onConfirm: () {
            final first = _selected.first;
            context.push('/creator/membership/submit/$first');
          },
        ),
        orElse: () => null,
      ),
    );
  }

  Widget _buildBody(BuildContext context, BarterColors bc, MembershipPayload payload) {
    final status = payload.status;
    final tasks = [...payload.tasks]..sort((a, b) {
        if (a.isFeatured == b.isFeatured) return 0;
        return a.isFeatured ? -1 : 1;
      });
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.w900,
                          height: 1.05,
                        ),
                    children: [
                      const TextSpan(text: 'Earn Your '),
                      TextSpan(text: 'Pro', style: TextStyle(color: bc.primary)),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Pick content tasks, post live, submit your URL, and unlock collaboration access without paying cash.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: bc.onSurfaceVariant,
                        height: 1.45,
                      ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: bc.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: bc.tertiaryContainer,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          status.tier,
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                color: bc.onTertiaryContainer,
                                fontWeight: FontWeight.w900,
                              ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'As a ${status.tier} creator, you can complete ${status.periodTaskLimit} task(s) per ${status.periodLabel}.',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: bc.onSurfaceVariant,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _PointsProgress(status: status, bc: bc),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 160),
          sliver: SliverList.separated(
            itemBuilder: (context, index) {
              final task = tasks[index];
              return _TaskCard(
                task: task,
                selected: _selected.contains(task.id),
                bc: bc,
                onToggle: task.isAvailable
                    ? () {
                        setState(() {
                          if (_selected.contains(task.id)) {
                            _selected.remove(task.id);
                          } else {
                            _selected.add(task.id);
                          }
                        });
                      }
                    : null,
                onBrief: () => showTaskBrief(context, task),
              );
            },
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemCount: tasks.length,
          ),
        ),
      ],
    );
  }
}

class _PointsProgress extends StatelessWidget {
  const _PointsProgress({required this.status, required this.bc});

  final MembershipStatus status;
  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    final nextTarget = status.totalPoints + status.pointsToNextMilestone;
    final progress = nextTarget == 0 ? 0.0 : status.totalPoints / nextTarget;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: bc.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Points balance', style: Theme.of(context).textTheme.labelLarge),
              Text('${status.totalPoints} pts', style: TextStyle(color: bc.primary, fontWeight: FontWeight.w900)),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progress.clamp(0, 1),
              minHeight: 8,
              backgroundColor: bc.surfaceContainerHigh,
              color: bc.primary,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "You're ${status.pointsToNextMilestone} pts away from ${status.nextMilestoneLabel}!",
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: bc.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

class _TaskCard extends StatelessWidget {
  const _TaskCard({
    required this.task,
    required this.selected,
    required this.bc,
    required this.onToggle,
    required this.onBrief,
  });

  final MembershipTask task;
  final bool selected;
  final BarterColors bc;
  final VoidCallback? onToggle;
  final VoidCallback onBrief;

  @override
  Widget build(BuildContext context) {
    final disabled = !task.isAvailable;
    return Opacity(
      opacity: disabled ? 0.55 : 1,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: bc.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: selected ? bc.primary : Colors.transparent, width: 2),
          boxShadow: [
            BoxShadow(color: bc.onBackground.withValues(alpha: 0.04), blurRadius: 18),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: SizedBox(
                    width: 48,
                    height: 48,
                    child: BarterNetworkImage(url: task.brandLogoUrl),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(task.brandName, style: Theme.of(context).textTheme.labelLarge),
                      Text(task.title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                    ],
                  ),
                ),
                Checkbox(value: selected, onChanged: onToggle == null ? null : (_) => onToggle!()),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                BarterChip(label: task.platform, variant: BarterChipVariant.mini, icon: Symbols.movie),
                BarterChip(label: '${task.points} pts', variant: BarterChipVariant.mini, icon: Symbols.workspace_premium, selected: true),
                if (task.isFeatured) BarterChip(label: 'Featured', variant: BarterChipVariant.mini, icon: Symbols.star),
              ],
            ),
            if (disabled && task.availableAgainOn != null) ...[
              const SizedBox(height: 12),
              Text('Available again on ${task.availableAgainOn}', style: TextStyle(color: bc.error, fontWeight: FontWeight.w700)),
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onBrief,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: bc.onSurface,
                      side: BorderSide(color: bc.outlineVariant.withValues(alpha: 0.35)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                    ),
                    child: const Text('View Brief'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: disabled ? null : () => context.push('/creator/membership/submit/${task.id}'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: bc.primary,
                      foregroundColor: bc.onPrimary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                    ),
                    child: const Text('Submit Task'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomSummary extends StatelessWidget {
  const _BottomSummary({
    required this.selectedCount,
    required this.selectedPoints,
    required this.enabled,
    required this.bc,
    required this.onConfirm,
  });

  final int selectedCount;
  final int selectedPoints;
  final bool enabled;
  final BarterColors bc;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      decoration: BoxDecoration(
        color: bc.surfaceContainerLowest,
        boxShadow: [BoxShadow(color: bc.onBackground.withValues(alpha: 0.08), blurRadius: 24)],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('$selectedCount selected', style: Theme.of(context).textTheme.labelLarge),
                Text('$selectedPoints pts', style: TextStyle(color: bc.primary, fontWeight: FontWeight.w900)),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: enabled ? onConfirm : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: bc.primary,
                  foregroundColor: bc.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                ),
                child: const Text('Confirm selected tasks'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> showTaskBrief(BuildContext context, MembershipTask task) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _TaskBriefSheet(task: task),
  );
}

class _TaskBriefSheet extends StatelessWidget {
  const _TaskBriefSheet({required this.task});

  final MembershipTask task;

  @override
  Widget build(BuildContext context) {
    final bc = context.barter;
    return DraggableScrollableSheet(
      initialChildSize: 0.82,
      maxChildSize: 0.92,
      minChildSize: 0.45,
      builder: (context, controller) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: bc.surfaceContainerLowest,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: ListView(
          controller: controller,
          children: [
            Text(task.title, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900)),
            const SizedBox(height: 8),
            Text(task.brief.whatToCreate, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: bc.onSurfaceVariant, height: 1.45)),
            const SizedBox(height: 24),
            _BriefList(title: 'Key messages', items: task.brief.keyMessages, bc: bc),
            const SizedBox(height: 20),
            _BriefList(title: "Don'ts", items: task.brief.donts, bc: bc),
            const SizedBox(height: 20),
            _BriefList(title: 'Required tags', items: task.brief.requiredTags, bc: bc),
            const SizedBox(height: 28),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: bc.primary,
                foregroundColor: bc.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
              ),
              child: const Text("Got it — I'll create this"),
            ),
          ],
        ),
      ),
    );
  }
}

class _BriefList extends StatelessWidget {
  const _BriefList({required this.title, required this.items, required this.bc});

  final String title;
  final List<String> items;
  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title.toUpperCase(), style: Theme.of(context).textTheme.labelSmall?.copyWith(letterSpacing: 2, fontWeight: FontWeight.w900, color: bc.primary)),
        const SizedBox(height: 10),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Symbols.check_circle, size: 18, color: bc.tertiary),
                const SizedBox(width: 8),
                Expanded(child: Text(item)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
