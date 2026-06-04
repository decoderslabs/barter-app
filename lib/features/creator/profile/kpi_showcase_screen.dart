import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../theme/barter_colors.dart';
import '../../../widgets/barter_appbar.dart';
import '../../../widgets/barter_network_image.dart';

class KPIShowcaseScreen extends StatelessWidget {
  const KPIShowcaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bc = context.barter;

    return Scaffold(
      backgroundColor: bc.background,
      appBar: BarterAppBar(
        leading: const BarterBackButton(),
        actions: [
          IconButton(
            icon: Icon(Symbols.more_vert, color: bc.primary),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (_) => SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(leading: const Icon(Icons.share), title: const Text('Share Profile'), onTap: () => Navigator.pop(context)),
                      ListTile(leading: const Icon(Icons.edit), title: const Text('Edit Profile'), onTap: () => Navigator.pop(context)),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _HeroSection(bc: bc),
            const SizedBox(height: 48),
            _KPIBentoGrid(bc: bc),
            const SizedBox(height: 48),
            _ExpertiseSection(bc: bc),
            const SizedBox(height: 48),
            _PortfolioSection(bc: bc),
            const SizedBox(height: 120),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 100),
        child: ElevatedButton.icon(
          onPressed: () => context.push('/creator/feed'),
          icon: Icon(Symbols.handshake, color: bc.onPrimary),
          label: Text(
            'Start Exchange',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: bc.primary,
            foregroundColor: bc.onPrimary,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
            elevation: 24,
            shadowColor: bc.primary.withValues(alpha: 0.2),
          ),
        ),
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection({required this.bc});

  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: bc.onBackground.withValues(alpha: 0.2),
                blurRadius: 24,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(32),
            child: Stack(
              children: [
                BarterNetworkImage(
                  url: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDsLxBezek163nUahIo7zu95w--ajopqaqTVikKcTYZE9_nbFTGnSOkEGG8ck9gF6hHewPq7VulCpg6yNdTN9yk3S2NZGvalKPrUL8aTGoVu69j2QNy7PhApJRM_HLPfujLzOWLgdJaoJaMMVbaHNSpk9oVzMuZt0MKndicq0tG8MCvkS_TxHApriw0P_ewp5jzAvn5Y9dYbpukM4zsRYnPy-D7ijwrUzP-K18T6yOgYo5PvydyK6FDDN5M3QsYoW_8thYJRHgHjmA',
                  fit: BoxFit.cover,
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          bc.onSurface,
                          Colors.transparent,
                        ],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: bc.tertiaryContainer,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Symbols.verified,
                                    color: bc.onTertiaryContainer,
                                    size: 12,
                                    fill: 1,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Verified Creator',
                                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                          color: bc.onTertiaryContainer,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.5,
                                          fontSize: 10,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Kabir Singh',
                          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                color: bc.surface,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '@kabir_tech',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: bc.surface.withValues(alpha: 0.8),
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 32),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                'Deep-diving into the tools that power the modern creator. | YouTube & Tech Reviewer',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: bc.onSurfaceVariant,
                      height: 1.6,
                    ),
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Location',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: bc.onSurfaceVariant.withValues(alpha: 0.6),
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                        fontSize: 10,
                      ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Symbols.location_on,
                      color: bc.onSurface,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Delhi, India',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: bc.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: bc.onBackground.withValues(alpha: 0.06),
                blurRadius: 40,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Barter Score',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: bc.onSurfaceVariant,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        '96',
                        style: Theme.of(context).textTheme.displayMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              letterSpacing: -2,
                            ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Symbols.trending_up,
                              color: Colors.green,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '+2.4',
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: bc.primary.withValues(alpha: 0.05),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: bc.primary.withValues(alpha: 0.1),
                    width: 4,
                  ),
                ),
                child: Icon(
                  Symbols.analytics,
                  color: bc.primary,
                  size: 32,
                  fill: 1,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _KPIBentoGrid extends StatelessWidget {
  const _KPIBentoGrid({required this.bc});

  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Performance Metrics',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Container(height: 1, color: bc.surfaceContainerHighest),
            ),
          ],
        ),
        const SizedBox(height: 24),
        GridView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            mainAxisExtent: 260,
          ),
          children: [
            _InstagramCard(bc: bc),
            _YouTubeCard(bc: bc),
            _LinkedInCard(bc: bc),
            _TikTokCard(bc: bc),
          ],
        ),
      ],
    );
  }
}

class _InstagramCard extends StatelessWidget {
  const _InstagramCard({required this.bc});

  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bc.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: bc.surface.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF8C00), Color(0xFFE1306C), Color(0xFF833AB4)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Symbols.photo_camera, color: bc.surface, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Instagram',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: bc.onSurfaceVariant,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                              fontSize: 11,
                            ),
                      ),
                      Text(
                        '62K Followers',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Eng.',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: bc.onSurfaceVariant,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                          fontSize: 10,
                        ),
                  ),
                  Text(
                    '4.8%',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: bc.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: bc.surface.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Story Views',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: bc.onSurfaceVariant.withValues(alpha: 0.6),
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                              fontSize: 8,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '8K+',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: bc.surface.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Top Cities',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: bc.onSurfaceVariant.withValues(alpha: 0.6),
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                              fontSize: 8,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Delhi, Mumbai...',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _YouTubeCard extends StatelessWidget {
  const _YouTubeCard({required this.bc});

  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bc.onSurface,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: bc.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Symbols.play_circle, color: bc.surface, size: 20, fill: 1),
          ),
          const SizedBox(height: 16),
          Text(
            'YouTube',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: bc.surface.withValues(alpha: 0.4),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                  fontSize: 10,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            '180K',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: bc.surface,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Avg Views',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: bc.surface.withValues(alpha: 0.6),
                          fontSize: 10,
                        ),
                  ),
                  Text(
                    '45K',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: bc.surface,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Engagement',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: bc.surface.withValues(alpha: 0.6),
                          fontSize: 10,
                        ),
                  ),
                  Text(
                    '7.2%',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: bc.surface,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LinkedInCard extends StatelessWidget {
  const _LinkedInCard({required this.bc});

  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bc.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF0077B5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Symbols.work, color: bc.surface, size: 20, fill: 1),
          ),
          const SizedBox(height: 16),
          Text(
            'LinkedIn',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: bc.onSurfaceVariant.withValues(alpha: 0.6),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                  fontSize: 10,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            '28K',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: bc.primaryFixed,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                'High Reach',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: bc.primary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TikTokCard extends StatelessWidget {
  const _TikTokCard({required this.bc});

  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bc.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: bc.surfaceContainer),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                  border: Border.all(color: bc.surface, width: 3),
                ),
                child: Icon(Symbols.music_note, color: bc.surface, size: 20),
              ),
              const SizedBox(width: 10),
              Text(
                'TikTok',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: bc.onSurfaceVariant.withValues(alpha: 0.6),
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                      fontSize: 10,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '12.4K',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          Text(
            'Fans',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: bc.onSurfaceVariant,
                  fontSize: 10,
                ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Symbols.visibility, color: bc.primary, size: 16),
              const SizedBox(width: 6),
              Text(
                'Trending',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.bold,
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

class _ExpertiseSection extends StatelessWidget {
  const _ExpertiseSection({required this.bc});

  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Expertise & Reach',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 24),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Niche Focus',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: bc.onSurfaceVariant.withValues(alpha: 0.6),
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                    fontSize: 11,
                  ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _Pill(label: 'Tech & Productivity', bc: bc),
                _Pill(label: 'Personal Finance', bc: bc),
                _Pill(label: 'Creator Economy', bc: bc),
              ],
            ),
          ],
        ),
        const SizedBox(height: 24),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Content Formats',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: bc.onSurfaceVariant.withValues(alpha: 0.6),
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                    fontSize: 11,
                  ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _ContentFormatPill(
                  icon: Symbols.smart_display,
                  label: 'YouTube Deep-Dives',
                  bc: bc,
                ),
                _ContentFormatPill(
                  icon: Symbols.history,
                  label: 'Instagram Reels',
                  bc: bc,
                ),
                _ContentFormatPill(
                  icon: Symbols.article,
                  label: 'LinkedIn Posts',
                  bc: bc,
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: bc.surfaceContainerLow,
            borderRadius: BorderRadius.circular(40),
            border: Border.all(color: bc.surface),
          ),
          child: Column(
            children: [
              Text(
                'Partnership Track Record',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: bc.onSurfaceVariant.withValues(alpha: 0.6),
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                      fontSize: 11,
                    ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text(
                        '42',
                        style: Theme.of(context).textTheme.displaySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        'Deals Done',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: bc.onSurfaceVariant.withValues(alpha: 0.6),
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                              fontSize: 10,
                            ),
                      ),
                    ],
                  ),
                  Container(width: 1, height: 48, color: bc.outlineVariant.withValues(alpha: 0.2)),
                  Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            '4.9',
                            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                  color: bc.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          Icon(Symbols.star, color: bc.primary, size: 20, fill: 1),
                        ],
                      ),
                      Text(
                        'Avg Rating',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: bc.onSurfaceVariant.withValues(alpha: 0.6),
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                              fontSize: 10,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.only(top: 24),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: bc.outlineVariant.withValues(alpha: 0.1),
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Top Categories',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: bc.onSurfaceVariant.withValues(alpha: 0.8),
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      'SaaS, Tech, Courses',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label, required this.bc});

  final String label;
  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: bc.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: bc.outlineVariant.withValues(alpha: 0.1)),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}

class _ContentFormatPill extends StatelessWidget {
  const _ContentFormatPill({
    required this.icon,
    required this.label,
    required this.bc,
  });

  final IconData icon;
  final String label;
  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: bc.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: bc.primary, size: 16),
          const SizedBox(width: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: bc.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}

class _PortfolioSection extends StatelessWidget {
  const _PortfolioSection({required this.bc});

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
              'Portfolio',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              'View All',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: bc.primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        GridView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 1,
          ),
          children: [
            _PortfolioItem(
              imageUrl:
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuBCJponSovOLVuxSAzVDemUAxo_Iz0hMKqsF-VUu8A1IOp17EQk1q0OEC4Z9J52PdplR15tWV34CSNwsMxCYj87Sl5hJSjVrelafY1LqtE6p-PUiSHE_piqzY_kGyPT4cpcXAKi27lLP5Ey1phEecTEiQaqauQ0qJEYHZjpePBN6bjVSW0QdA0Ql8TZn35kX6eoR8TEBM4a4NcQ1dMpuqQ9LRLY6RIGkTj2MESsaRi43nHAdTfU9udG2ZeCu6-FdatQE5SfJkqJzS0',
              isVideo: true,
              bc: bc,
            ),
            _PortfolioItem(
              imageUrl:
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuCRysby51QlqT1VMDRiKB0Prnz2dK6g0v05c4oTRV6U2fvx0uk1gqH9ZoKsQx6usbix2mvcEjqaPWytp5GU1U9xMKuwGRhbF7bxhBUsyRWl4AQVp4g8c5FGpnznLTHQTZ-zTR6Tgh0ujDgkd0tdJ_toGMnQxasWByZTWmtZNuWyBSXzoL9srDo2KunzWVrRxs4znp_apMZg-GurEtk1-ipb8gv9MM5ubgJb23qBAQJeLB4UkhEGN7x0qsHs-vogaS6DvLTIS6zJxak',
              isVideo: false,
              bc: bc,
            ),
            _PortfolioItem(
              imageUrl:
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuCnIW7KtKCvAPFpeORful6prf5cjCcfGjZxrKXiCFUkqT0KtWcJZbtMzI0BnV0fSUe7VNH4SOS7f7NcNrAq5oqHuXtFrV4tFa1u5czGKQWBmBlWSPzUy-tGBcPni7_o5JSynhDynnOX7EYArVy0jR2vvZi49QOoX7pqpI3UwCs8JvXXRNjjIx1xKh1_1dlw7-Q-dTFnFZGi8k7xe_xxyvGmTfvEqFH6GErSESWE2BDEqtYi7Xm6m6cGD0vZ_0TgqAOdt0DhEzq7828',
              isVideo: true,
              bc: bc,
            ),
            _PortfolioItem(
              imageUrl:
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuA95fRxiVxkB5pwx4m-Y0vWpt-gxQGX4Ih9mcdQAk4AYcT9_Ws8YoEs7iS45_2iioCTiRqx9uWxhcbpMgBVoUuMkqgNs4wMknjhysDcJF-w8Pv7qYmEwmwCPLSRPVRfPgEzIhSRK6G37EbPIUIeZ3CMiUKcGvVd5htFLPDW3lKnd2Yw69YrGI52R5pXY__erS-SNt7rmy87W_ejvZP0nHcaPSdiaHC_DXh5a5HArybCulGsmSzprHHlg3zNuyOVgQEMV_C7PLnl8Pg',
              isVideo: false,
              bc: bc,
            ),
            _PortfolioItem(
              imageUrl:
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuBPbsyrgkHBhSHTz7ummjMIt3J-TwWlWAv8cOqu2d3SvE_Z_C5iYeJdJNo6PTbirmUruqSA-pG06P2YvknbOoWTkHBz7tucpvPtyEdn04_D4DFGGFBM0UUE96VAg0l_wPvGn6obQdLsuqEaimWE6eSvMSQctQ8R6F1s6AQWONXPva4hIXd_oQUkedECclE89XKFxLxF1PP4DMki2-x8mNqMN_qEL9NZ_eDa6cuhpT49CCVQK5dkZQa2syvTytMmHC5g8_mjXzB3Yg',
              isVideo: false,
              bc: bc,
            ),
            _PortfolioItem(
              imageUrl:
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuDa8MWnNueRJqok_s_49_4E8tvoQZ7sB6PoFUox1yHV477d5CGSjfBVwDjQlB_ZC-rcIVoZn6JIWITJFCeBESB9jqKYWvZrv0NxSPKqDd5lEYofXBvPmbF-Nw1kSqifMAs78IJ9od2GsRv7-fpwjPNPYoT-H0rbLJj-YkBHG77gQhH0JPFvhU9z1qw6Y9LBbUaiyh27_MZ_T1y-BDbmUgDLseqGZUDprkDMy3EGDnCkD_59oKIwPaTxuS0g4OJvGNDRjJREAq-RIBk',
              isVideo: false,
              bc: bc,
            ),
          ],
        ),
      ],
    );
  }
}

class _PortfolioItem extends StatelessWidget {
  const _PortfolioItem({required this.imageUrl, required this.isVideo, required this.bc});

  final String imageUrl;
  final bool isVideo;
  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            BarterNetworkImage(
              url: imageUrl,
              fit: BoxFit.cover,
            ),
            if (isVideo)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Symbols.play_circle,
                    color: bc.surface,
                    size: 12,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
