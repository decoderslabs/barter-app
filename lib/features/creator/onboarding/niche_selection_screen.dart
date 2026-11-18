import '../../../widgets/barter_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../providers/app_providers.dart';
import '../../../theme/barter_colors.dart';
import '../../../widgets/barter_network_image.dart';

class NicheSelectionScreen extends ConsumerStatefulWidget {
  const NicheSelectionScreen({super.key});

  @override
  ConsumerState<NicheSelectionScreen> createState() => _NicheSelectionScreenState();
}

class _NicheSelectionScreenState extends ConsumerState<NicheSelectionScreen> {
  bool _isLoading = false;
  final List<NicheOption> _niches = [
    NicheOption(
      id: '1',
      name: 'Skincare & Beauty',
      category: 'Curated',
      icon: Symbols.auto_awesome,
      isSelected: true,
    ),
    NicheOption(
      id: '2',
      name: 'Fashion & Style',
      category: 'Aesthetic',
      icon: Symbols.styler,
    ),
    NicheOption(
      id: '3',
      name: 'Tech & Productivity',
      category: 'Modern',
      icon: Symbols.devices,
    ),
    NicheOption(
      id: '4',
      name: 'Food & Beverage',
      category: 'Gourmet',
      icon: Symbols.restaurant,
    ),
    NicheOption(
      id: '5',
      name: 'Travel & Lifestyle',
      category: 'Global',
      icon: Symbols.explore,
    ),
    NicheOption(
      id: '6',
      name: 'Fitness & Wellness',
      category: 'Active',
      icon: Symbols.fitness_center,
    ),
    NicheOption(
      id: '7',
      name: 'Gaming',
      category: 'Digital',
      icon: Symbols.sports_esports,
    ),
    NicheOption(
      id: '8',
      name: 'Finance',
      category: 'Capital',
      icon: Symbols.payments,
    ),
    NicheOption(
      id: '9',
      name: 'Parenting',
      category: 'Nurture',
      icon: Symbols.family_restroom,
    ),
    NicheOption(
      id: '10',
      name: 'Music & Ent.',
      category: 'Vibe',
      icon: Symbols.music_note,
    ),
    NicheOption(
      id: '11',
      name: 'Other',
      category: 'Custom',
      icon: Symbols.add,
      isDashed: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = ref.read(authProvider).user;
      final existingNiches = user?.creatorProfile?.niches ?? [];
      if (existingNiches.isNotEmpty) {
        setState(() {
          for (var i = 0; i < _niches.length; i++) {
            final n = _niches[i];
            final matches = existingNiches.any(
              (en) => en.toLowerCase() == n.name.toLowerCase() ||
                      n.name.toLowerCase().contains(en.toLowerCase()) ||
                      en.toLowerCase().contains(n.name.toLowerCase()),
            );
            _niches[i] = n.copyWith(isSelected: matches);
          }
        });
      }
    });
  }

  Future<void> _onContinue() async {
    final selectedNiches = _niches.where((n) => n.isSelected).map((n) => n.name).toList();

    if (selectedNiches.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please select at least 1 niche'),
          backgroundColor: context.barter.error,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final session = ref.read(sessionProvider.notifier);
      await session.persistNiches(selectedNiches);
      await ref.read(authProvider.notifier).refreshUser();

      if (mounted) {
        context.push('/creator/onboarding/interests');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save niches: $e'),
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
    final selectedCount = _niches.where((n) => n.isSelected).length;

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
                    color: bc.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
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
            _ProgressBar(bc: bc, step: 2, total: 5),
            const SizedBox(height: 40),
            _Headline(bc: bc),
            const SizedBox(height: 48),
            _NicheGrid(
              niches: _niches,
              onToggle: (id) {
                setState(() {
                  final index = _niches.indexWhere((n) => n.id == id);
                  if (index != -1) {
                    if (_niches[index].isSelected) {
                      _niches[index] = _niches[index].copyWith(isSelected: false);
                    } else if (selectedCount < 5) {
                      _niches[index] = _niches[index].copyWith(isSelected: true);
                    }
                  }
                });
              },
              bc: bc,
            ),
            const SizedBox(height: 40),
            _SelectionStatus(selectedCount: selectedCount, bc: bc),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              bc.background.withValues(alpha: 0),
              bc.background,
              bc.background,
            ],
          ),
        ),
        child: SafeArea(
          child: ElevatedButton(
            onPressed: selectedCount > 0 && !_isLoading ? _onContinue : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: bc.primary,
              foregroundColor: bc.onPrimary,
              padding: const EdgeInsets.symmetric(vertical: 20),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
              elevation: 8,
              shadowColor: bc.primary.withValues(alpha: 0.2),
            ),
            child: _isLoading
                ? SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: bc.onPrimary,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    'Continue to Step 3',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
          ),
        ),
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.bc, required this.step, required this.total});

  final BarterColors bc;
  final int step;
  final int total;

  @override
  Widget build(BuildContext context) {
    final progress = step / total;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Onboarding Journey',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: bc.primary,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
            ),
            Text(
              'Step $step/$total',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: bc.onSurfaceVariant,
                    fontWeight: FontWeight.bold,
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
          child: FractionallySizedBox(
            widthFactor: progress,
            alignment: Alignment.centerLeft,
            child: Container(
              decoration: BoxDecoration(
                color: bc.primary,
                borderRadius: BorderRadius.circular(999),
              ),
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
                  height: 1.1,
                ),
            children: [
              const TextSpan(text: 'Find your '),
              TextSpan(
                text: 'Identity.',
                style: TextStyle(color: bc.primary),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Select up to 5 niches that define your content style. This helps us match you with the right editorial brands.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: bc.onSurfaceVariant,
                height: 1.6,
              ),
        ),
      ],
    );
  }
}

class _NicheGrid extends StatelessWidget {
  const _NicheGrid({
    required this.niches,
    required this.onToggle,
    required this.bc,
  });

  final List<NicheOption> niches;
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
      itemCount: niches.length,
      itemBuilder: (context, index) {
        final niche = niches[index];
        return _NicheCard(
          niche: niche,
          onToggle: onToggle,
          bc: bc,
        );
      },
    );
  }
}

class _NicheCard extends StatelessWidget {
  const _NicheCard({
    required this.niche,
    required this.onToggle,
    required this.bc,
  });

  final NicheOption niche;
  final ValueChanged<String> onToggle;
  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    final isSelected = niche.isSelected;

    return GestureDetector(
      onTap: () => onToggle(niche.id),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? bc.primary : bc.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16),
          border: niche.isDashed
              ? Border.all(
                  color: bc.outlineVariant.withValues(alpha: 0.3),
                  width: 1.5,
                )
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              niche.icon,
              size: 24,
              color: isSelected ? bc.onPrimary : bc.primary,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  niche.category,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: isSelected
                            ? bc.onPrimary.withValues(alpha: 0.8)
                            : bc.onSurfaceVariant,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        fontSize: 9,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  niche.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: isSelected ? bc.onPrimary : bc.onSurface,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
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

class _SelectionStatus extends StatelessWidget {
  const _SelectionStatus({required this.selectedCount, required this.bc});

  final int selectedCount;
  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: bc.primaryFixedDim.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Selection limit',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: bc.primary,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
              ),
              RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                  children: [
                    TextSpan(text: '$selectedCount '),
                    TextSpan(
                      text: 'of 5',
                      style: TextStyle(
                        color: bc.onSurfaceVariant.withValues(alpha: 0.4),
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: bc.surfaceContainerHighest,
                  shape: BoxShape.circle,
                  border: Border.all(color: bc.surface, width: 2),
                ),
                child: ClipOval(
                  child: BarterNetworkImage(
                    url: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCmabUiFgRQVp7k7w5rbvhJwVkwDQZgYCW5OLjdAf_Sa9MFlqGAo1-L95-GfQX4cUQwKO8OwugKjvdhzUK4Sx3C8cy4CkxpCMQCni48aq7XbJrEDMCCxZAfWK5twm-SzHR0egTx0PckHLyEiG1zylaMFVjbQkoAihLkd_54xidBPn67zimvj0SptapC2XlIYottnJXXSBgrM3AhzzqP4wNgf03g0_fCmuo4xQvt9o8Z5dfSIFwXnz6bt_5sAkDdrvI3q0CuMtGFxn0',
                    fit: BoxFit.cover,
                    memCacheWidth: 80,
                    memCacheHeight: 80,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: bc.surfaceContainerLow,
                  shape: BoxShape.circle,
                  border: Border.all(color: bc.surface, width: 2),
                ),
                child: Icon(
                  Symbols.add,
                  color: bc.onSurfaceVariant.withValues(alpha: 0.3),
                  size: 20,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class NicheOption {
  final String id;
  final String name;
  final String category;
  final IconData icon;
  final bool isSelected;
  final bool isDashed;

  NicheOption({
    required this.id,
    required this.name,
    required this.category,
    required this.icon,
    this.isSelected = false,
    this.isDashed = false,
  });

  NicheOption copyWith({
    String? id,
    String? name,
    String? category,
    IconData? icon,
    bool? isSelected,
    bool? isDashed,
  }) {
    return NicheOption(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      icon: icon ?? this.icon,
      isSelected: isSelected ?? this.isSelected,
      isDashed: isDashed ?? this.isDashed,
    );
  }
}
