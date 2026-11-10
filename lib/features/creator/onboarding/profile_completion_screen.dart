import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../data/dto/user_dto.dart';
import '../../../providers/app_providers.dart';
import '../../../theme/barter_colors.dart';
import '../../../widgets/barter_appbar.dart';

class ProfileCompletionScreen extends ConsumerWidget {
  const ProfileCompletionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bc = context.barter;
    final auth = ref.watch(authProvider);
    final user = auth.user;
    final completion = user?.profileCompletion;

    if (completion == null) {
      return Scaffold(
        backgroundColor: bc.background,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final pct = completion.percentage;
    final required = completion.requiredPercentage;
    final canContinue = completion.canAccessMembership;

    return Scaffold(
      backgroundColor: bc.background,
      appBar: BarterAppBar(
        showBrandTitle: false,
        title: 'Complete Your Profile',
      ),
      body: Column(
        children: [
          _ProgressHeader(
            percentage: pct,
            required: required,
            canContinue: canContinue,
            bc: bc,
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
              children: [
                Text(
                  'Complete these steps to unlock membership tasks',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: bc.onSurfaceVariant),
                ),
                const SizedBox(height: 20),
                ...completion.tasks.map(
                  (task) => _TaskTile(task: task, bc: bc),
                ),
              ],
            ),
          ),
          _BottomCta(
            canContinue: canContinue,
            bc: bc,
            onContinue: () => context.go('/creator/membership/earn'),
          ),
        ],
      ),
    );
  }
}

class _ProgressHeader extends StatelessWidget {
  const _ProgressHeader({
    required this.percentage,
    required this.required,
    required this.canContinue,
    required this.bc,
  });

  final int percentage;
  final int required;
  final bool canContinue;
  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    final progress = (percentage / 100).clamp(0.0, 1.0);
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
      decoration: BoxDecoration(
        color: bc.surfaceContainerLowest,
        boxShadow: [
          BoxShadow(
            color: bc.onBackground.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$percentage% complete',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: canContinue ? bc.primary : bc.onSurface,
                    ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: canContinue
                      ? bc.primary.withValues(alpha: 0.12)
                      : bc.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  canContinue ? 'Unlocked!' : '$required% required',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: canContinue ? bc.primary : bc.onSurfaceVariant,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: bc.surfaceContainerLow,
              valueColor: AlwaysStoppedAnimation(
                canContinue ? bc.primary : bc.tertiary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TaskTile extends StatelessWidget {
  const _TaskTile({required this.task, required this.bc});

  final ProfileTaskDto task;
  final BarterColors bc;

  String _routeFor(String id) {
    switch (id) {
      case 'profile_photo':
      case 'bio':
      case 'location':
        return '/creator/onboarding/profile';
      case 'niches':
        return '/creator/onboarding/niche';
      case 'content_types':
        return '/creator/onboarding/content-types';
      case 'social_accounts':
        return '/creator/onboarding/socials';
      default:
        return '/creator/onboarding/profile';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: task.completed ? null : () => context.push(_routeFor(task.id)),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: bc.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: task.completed
                  ? bc.primary.withValues(alpha: 0.3)
                  : bc.outlineVariant.withValues(alpha: 0.25),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: task.completed
                      ? bc.primary.withValues(alpha: 0.12)
                      : bc.surfaceContainerLow,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  task.completed ? Symbols.check_circle : Symbols.circle,
                  size: 22,
                  color: task.completed ? bc.primary : bc.onSurfaceVariant,
                  fill: task.completed ? 1 : 0,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.label,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            decoration: task.completed
                                ? TextDecoration.lineThrough
                                : null,
                            color: task.completed
                                ? bc.onSurfaceVariant
                                : bc.onSurface,
                          ),
                    ),
                    if (task.id == 'social_accounts' &&
                        task.current != null &&
                        task.required != null)
                      Text(
                        '${task.current}/${task.required} connected',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: bc.onSurfaceVariant,
                            ),
                      )
                    else
                      Text(
                        '+${task.weight}%',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: bc.onSurfaceVariant,
                            ),
                      ),
                  ],
                ),
              ),
              if (!task.completed)
                Icon(Symbols.chevron_right, color: bc.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomCta extends StatelessWidget {
  const _BottomCta({
    required this.canContinue,
    required this.bc,
    required this.onContinue,
  });

  final bool canContinue;
  final BarterColors bc;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
        decoration: BoxDecoration(
          color: bc.surfaceContainerLowest,
          boxShadow: [
            BoxShadow(
              color: bc.onBackground.withValues(alpha: 0.06),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: canContinue ? onContinue : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: bc.primary,
              foregroundColor: bc.onPrimary,
              disabledBackgroundColor: bc.surfaceContainerLow,
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            child: Text(
              canContinue
                  ? 'Continue to Membership Tasks'
                  : 'Complete profile to unlock',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: canContinue ? bc.onPrimary : bc.onSurfaceVariant,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
