import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../providers/app_providers.dart';
import '../../../theme/barter_colors.dart';

class ContentTypesScreen extends ConsumerStatefulWidget {
  const ContentTypesScreen({super.key});

  @override
  ConsumerState<ContentTypesScreen> createState() => _ContentTypesScreenState();
}

class _ContentTypesScreenState extends ConsumerState<ContentTypesScreen> {
  bool _isLoading = false;
  final List<ContentTypeOption> _contentTypes = [
    ContentTypeOption(
      id: '1',
      name: 'Reels',
      subcategory: 'Instagram',
      icon: Symbols.movie,
      isSelected: true,
    ),
    ContentTypeOption(
      id: '2',
      name: 'TikTok Videos',
      subcategory: 'Short-form',
      icon: Symbols.bolt,
    ),
    ContentTypeOption(
      id: '3',
      name: 'YouTube Videos',
      subcategory: 'Long-form',
      icon: Symbols.play_circle,
    ),
    ContentTypeOption(
      id: '4',
      name: 'Stories',
      subcategory: 'Ephemeral',
      icon: Symbols.history,
      isSelected: true,
    ),
    ContentTypeOption(
      id: '5',
      name: 'UGC Photos',
      description: 'High-quality lifestyle imagery for brand assets',
      icon: Symbols.photo_camera,
      isFullWidth: true,
    ),
    ContentTypeOption(
      id: '6',
      name: 'LinkedIn Posts',
      subcategory: 'Professional',
      icon: Symbols.work,
    ),
    ContentTypeOption(
      id: '7',
      name: 'Blog Posts',
      subcategory: 'Written Word',
      icon: Symbols.article,
    ),
    ContentTypeOption(
      id: '8',
      name: 'Event Coverage',
      description: 'On-site reporting, live streaming, and VIP access content',
      icon: Symbols.confirmation_number,
      isFullWidth: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = ref.read(authProvider).user;
      final existingTypes = user?.creatorProfile?.contentTypes ?? [];
      if (existingTypes.isNotEmpty) {
        setState(() {
          for (var i = 0; i < _contentTypes.length; i++) {
            final c = _contentTypes[i];
            final matches = existingTypes.any(
              (et) => et.toLowerCase() == c.name.toLowerCase() ||
                      c.name.toLowerCase().contains(et.toLowerCase()) ||
                      et.toLowerCase().contains(c.name.toLowerCase()),
            );
            _contentTypes[i] = c.copyWith(isSelected: matches);
          }
        });
      }
    });
  }

  Future<void> _onContinue() async {
    final selectedContentTypes = _contentTypes
        .where((c) => c.isSelected)
        .map((c) => c.name)
        .toList();

    if (selectedContentTypes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please select at least 1 content type'),
          backgroundColor: context.barter.error,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final session = ref.read(sessionProvider.notifier);
      await session.persistContentTypes(selectedContentTypes);
      await ref.read(authProvider.notifier).refreshUser();

      if (mounted) {
        context.push('/creator/onboarding/socials');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save content types: $e'),
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
        title: Text(
          'BARTER',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: bc.primary,
                fontWeight: FontWeight.w900,
                letterSpacing: -1,
              ),
        ),
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
            _ContentTypesGrid(
              contentTypes: _contentTypes,
              onToggle: (id) {
                setState(() {
                  final index = _contentTypes.indexWhere((c) => c.id == id);
                  if (index != -1) {
                    _contentTypes[index] = _contentTypes[index].copyWith(
                      isSelected: !_contentTypes[index].isSelected,
                    );
                  }
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
          color: bc.surfaceContainerHighest.withValues(alpha: 0.8),
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => context.pop(),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: bc.surfaceContainerHigh,
                    foregroundColor: bc.onSurface,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                  ),
                  child: Text(
                    'Save Draft',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _onContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: bc.primary,
                    foregroundColor: bc.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                    elevation: 10,
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
                          'Continue',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
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
              'Step 4 of 5',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: bc.primary,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
            ),
            Text(
              'Content Expertise',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: bc.secondary,
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
          child: FractionallySizedBox(
            widthFactor: 0.8,
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
              const TextSpan(text: 'What do you '),
              TextSpan(
                text: 'create',
                style: TextStyle(color: bc.primary, fontStyle: FontStyle.italic),
              ),
              const TextSpan(text: '?'),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Select the content types you specialize in. This helps brands find the perfect match for their campaign aesthetic.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: bc.onSurfaceVariant,
                height: 1.6,
              ),
        ),
      ],
    );
  }
}

class _ContentTypesGrid extends StatelessWidget {
  const _ContentTypesGrid({
    required this.contentTypes,
    required this.onToggle,
    required this.bc,
  });

  final List<ContentTypeOption> contentTypes;
  final ValueChanged<String> onToggle;
  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.1,
      ),
      itemCount: contentTypes.length,
      itemBuilder: (context, index) {
        final contentType = contentTypes[index];
        if (contentType.isFullWidth) {
          return _FullWidthCard(
            contentType: contentType,
            onToggle: onToggle,
            bc: bc,
          );
        }
        return _ContentTypeCard(
          contentType: contentType,
          onToggle: onToggle,
          bc: bc,
        );
      },
    );
  }
}

class _ContentTypeCard extends StatelessWidget {
  const _ContentTypeCard({
    required this.contentType,
    required this.onToggle,
    required this.bc,
  });

  final ContentTypeOption contentType;
  final ValueChanged<String> onToggle;
  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    final isSelected = contentType.isSelected;

    return GestureDetector(
      onTap: () => onToggle(contentType.id),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isSelected ? bc.surfaceContainerLowest : bc.surfaceContainerLow,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(
            color: isSelected ? bc.primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  contentType.icon,
                  size: 32,
                  color: isSelected ? bc.primary : bc.onSurface,
                ),
                if (isSelected)
                  Icon(
                    Symbols.check_circle,
                    color: bc.primary,
                    fill: 1,
                    size: 20,
                  ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  contentType.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: isSelected ? bc.onSurface : bc.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  contentType.subcategory ?? '',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: bc.onSurfaceVariant,
                        letterSpacing: 1,
                    fontSize: 11,
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

class _FullWidthCard extends StatelessWidget {
  const _FullWidthCard({
    required this.contentType,
    required this.onToggle,
    required this.bc,
  });

  final ContentTypeOption contentType;
  final ValueChanged<String> onToggle;
  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    final isSelected = contentType.isSelected;

    return GestureDetector(
      onTap: () => onToggle(contentType.id),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isSelected ? bc.surfaceContainerLowest : bc.surfaceContainerLow,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(
            color: isSelected ? bc.primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: bc.surface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                contentType.icon,
                size: 40,
                color: isSelected ? bc.primary : bc.onSurface,
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    contentType.name,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    contentType.description ?? '',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: bc.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Symbols.check_circle,
                color: bc.primary,
                fill: 1,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}

class ContentTypeOption {
  final String id;
  final String name;
  final String? subcategory;
  final String? description;
  final IconData icon;
  final bool isSelected;
  final bool isFullWidth;

  ContentTypeOption({
    required this.id,
    required this.name,
    this.subcategory,
    this.description,
    required this.icon,
    this.isSelected = false,
    this.isFullWidth = false,
  });

  ContentTypeOption copyWith({
    String? id,
    String? name,
    String? subcategory,
    String? description,
    IconData? icon,
    bool? isSelected,
    bool? isFullWidth,
  }) {
    return ContentTypeOption(
      id: id ?? this.id,
      name: name ?? this.name,
      subcategory: subcategory ?? this.subcategory,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      isSelected: isSelected ?? this.isSelected,
      isFullWidth: isFullWidth ?? this.isFullWidth,
    );
  }
}
