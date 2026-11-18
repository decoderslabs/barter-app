import '../../../widgets/barter_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../providers/app_providers.dart';
import '../../../theme/barter_colors.dart';

class InterestsSelectionScreen extends ConsumerStatefulWidget {
  const InterestsSelectionScreen({super.key});

  @override
  ConsumerState<InterestsSelectionScreen> createState() => _InterestsSelectionScreenState();
}

class _InterestsSelectionScreenState extends ConsumerState<InterestsSelectionScreen> {
  bool _isLoading = false;
  final List<InterestOption> _interests = [
    InterestOption(
      id: '1',
      name: 'SaaS',
      subcategory: 'Digital Tools',
      icon: Symbols.cloud,
    ),
    InterestOption(
      id: '2',
      name: 'Physical',
      subcategory: 'Goods & Kits',
      icon: Symbols.package_2,
    ),
    InterestOption(
      id: '3',
      name: 'Events',
      subcategory: 'VIP Access',
      icon: Symbols.confirmation_number,
    ),
    InterestOption(
      id: '4',
      name: 'Tech',
      subcategory: 'Hardware',
      icon: Symbols.devices,
    ),
    InterestOption(
      id: '5',
      name: 'Lifestyle',
      subcategory: 'Fashion & Wellness',
      icon: Symbols.auto_awesome,
    ),
    InterestOption(
      id: '6',
      name: 'Courses',
      subcategory: 'Masterclasses',
      icon: Symbols.menu_book,
    ),
  ];

  bool _isConfirmed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = ref.read(authProvider).user;
      final sessionInterests = ref.read(sessionProvider).selectedInterests;
      final existingInterests = (user?.creatorProfile?.interests.isNotEmpty ?? false)
          ? user!.creatorProfile!.interests
          : sessionInterests.toList();

      if (existingInterests.isNotEmpty) {
        setState(() {
          for (var i = 0; i < _interests.length; i++) {
            final item = _interests[i];
            final matches = existingInterests.any(
              (ei) => ei.toLowerCase() == item.name.toLowerCase() ||
                      item.name.toLowerCase().contains(ei.toLowerCase()) ||
                      ei.toLowerCase().contains(item.name.toLowerCase()),
            );
            _interests[i] = item.copyWith(isSelected: matches);
          }
        });
      }
    });
  }

  Future<void> _onFinishOnboarding() async {
    final selectedInterests = _interests
        .where((i) => i.isSelected)
        .map((i) => i.name)
        .toList();

    if (selectedInterests.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please select at least 1 interest'),
          backgroundColor: context.barter.error,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final session = ref.read(sessionProvider.notifier);
      await session.persistInterests(selectedInterests);
      await ref.read(authProvider.notifier).refreshUser();

      if (mounted) {
        context.push('/creator/onboarding/content-types');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to finish onboarding: $e'),
            backgroundColor: context.barter.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bc = context.barter;

    return Scaffold(
      backgroundColor: bc.background,
      appBar: AppBar(
        backgroundColor: bc.background,
        leading: IconButton(
          icon: Icon(Symbols.arrow_back, color: bc.primary),
          onPressed: () => context.pop(),
        ),
        title: const BarterLogo(height: 28),
        actions: [
          TextButton(
            onPressed: () => context.push('/help'),
            child: Text(
              'Help',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: bc.primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ProgressBar(bc: bc),
            const SizedBox(height: 48),
            _Headline(bc: bc),
            const SizedBox(height: 40),
            _InterestsGrid(
              interests: _interests,
              onToggle: (id) {
                setState(() {
                  final index = _interests.indexWhere((i) => i.id == id);
                  if (index != -1) {
                    _interests[index] = _interests[index].copyWith(
                      isSelected: !_interests[index].isSelected,
                    );
                  }
                });
              },
              bc: bc,
            ),
            const SizedBox(height: 48),
            _ConfirmationCheckbox(
              isConfirmed: _isConfirmed,
              onToggle: (value) {
                setState(() {
                  _isConfirmed = value ?? false;
                });
              },
              bc: bc,
            ),
            const SizedBox(height: 120),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: bc.surface.withValues(alpha: 0.8),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: _isConfirmed && !_isLoading ? _onFinishOnboarding : null,
                icon: _isLoading
                    ? SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: bc.onPrimary,
                          strokeWidth: 2,
                        ),
                      )
                    : Icon(Symbols.rocket_launch, color: bc.onPrimary),
                label: Text(
                  _isLoading ? 'Finishing...' : 'Finish Onboarding',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: bc.primary,
                  foregroundColor: bc.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                  elevation: 8,
                  shadowColor: bc.primary.withValues(alpha: 0.25),
                  minimumSize: const Size(double.infinity, 64),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Profile will be live instantly',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: bc.onSurfaceVariant.withValues(alpha: 0.4),
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.bc});

  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Step 5 of 5',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: bc.primary,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
            ),
            Text(
              'Final Step',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: bc.onSurfaceVariant.withValues(alpha: 0.6),
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          height: 6,
          decoration: BoxDecoration(
            color: bc.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: bc.primary,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
        ),
      ],
    );
  }
}

class _Headline extends StatelessWidget {
  const _Headline({required this.bc});

  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  height: 0.9,
                ),
            children: [
              const TextSpan(text: 'What '),
              TextSpan(
                text: 'moves',
                style: TextStyle(color: bc.primary, fontStyle: FontStyle.italic),
              ),
              const TextSpan(text: ' you?'),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Select the exchange categories that align with your brand\'s aesthetic and values.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: bc.onSurfaceVariant,
                height: 1.6,
              ),
        ),
      ],
    );
  }
}

class _InterestsGrid extends StatelessWidget {
  const _InterestsGrid({
    required this.interests,
    required this.onToggle,
    required this.bc,
  });

  final List<InterestOption> interests;
  final ValueChanged<String> onToggle;
  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final crossAxisCount = width > 900 ? 4 : (width > 600 ? 3 : 2);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.45,
      ),
      itemCount: interests.length,
      itemBuilder: (context, index) {
        final interest = interests[index];
        return _InterestCard(
          interest: interest,
          onToggle: onToggle,
          bc: bc,
        );
      },
    );
  }
}

class _InterestCard extends StatelessWidget {
  const _InterestCard({
    required this.interest,
    required this.onToggle,
    required this.bc,
  });

  final InterestOption interest;
  final ValueChanged<String> onToggle;
  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    final isSelected = interest.isSelected;

    return GestureDetector(
      onTap: () => onToggle(interest.id),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? bc.primary : bc.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? bc.primary : bc.primary.withValues(alpha: 0.15),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: bc.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    interest.icon,
                    color: bc.primary,
                    size: 18,
                  ),
                ),
                if (isSelected)
                  Icon(
                    Symbols.check_circle,
                    color: bc.onPrimary,
                    fill: 1,
                    size: 18,
                  ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  interest.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: isSelected ? bc.onPrimary : bc.onSurface,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                ),
                Text(
                  interest.subcategory,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: isSelected
                            ? bc.onPrimary.withValues(alpha: 0.8)
                            : bc.onSurfaceVariant,
                        letterSpacing: 0.5,
                        fontSize: 10,
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

class _ConfirmationCheckbox extends StatelessWidget {
  const _ConfirmationCheckbox({
    required this.isConfirmed,
    required this.onToggle,
    required this.bc,
  });

  final bool isConfirmed;
  final ValueChanged<bool?> onToggle;
  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: bc.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: bc.primary.withValues(alpha: 0.15),
          width: 2,
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: Checkbox(
              value: isConfirmed,
              onChanged: onToggle,
              fillColor: MaterialStateProperty.all(bc.primary),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Confirm Readiness',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'I confirm that my profile content is accurate and I am ready to start bartering with brands.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: bc.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class InterestOption {
  final String id;
  final String name;
  final String subcategory;
  final IconData icon;
  final bool isSelected;

  InterestOption({
    required this.id,
    required this.name,
    required this.subcategory,
    required this.icon,
    this.isSelected = false,
  });

  InterestOption copyWith({
    String? id,
    String? name,
    String? subcategory,
    IconData? icon,
    bool? isSelected,
  }) {
    return InterestOption(
      id: id ?? this.id,
      name: name ?? this.name,
      subcategory: subcategory ?? this.subcategory,
      icon: icon ?? this.icon,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
