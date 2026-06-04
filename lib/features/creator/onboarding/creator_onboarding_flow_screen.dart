import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../data/models/onboarding_config.dart';
import '../../../providers/app_providers.dart';
import '../../../theme/barter_colors.dart';
import '../../../theme/responsive_extension.dart';
import '../../../widgets/barter_appbar.dart';
import '../../../widgets/barter_network_image.dart';
import '../../../widgets/barter_buttons.dart';

class CreatorOnboardingFlowScreen extends ConsumerStatefulWidget {
  const CreatorOnboardingFlowScreen({super.key, this.initialStep = 0});

  final int initialStep;

  @override
  ConsumerState<CreatorOnboardingFlowScreen> createState() =>
      _CreatorOnboardingFlowScreenState();
}

class _CreatorOnboardingFlowScreenState
    extends ConsumerState<CreatorOnboardingFlowScreen> {
  late int _step = 0;
  final _name = TextEditingController();
  final _handle = TextEditingController();

  @override
  void initState() {
    super.initState();
    _step = widget.initialStep.clamp(0, 5);
  }

  @override
  void dispose() {
    _name.dispose();
    _handle.dispose();
    super.dispose();
  }

  void _next() {
    if (_step >= 5) {
      context.go('/creator/feed');
      return;
    }
    setState(() => _step++);
  }

  @override
  Widget build(BuildContext context) {
    final bc = context.barter;
    final cfgAsync = ref.watch(onboardingConfigProvider);
    final session = ref.watch(sessionProvider);

    return Scaffold(
      backgroundColor: bc.surface,
      appBar: BarterAppBar(
        backgroundColor: bc.surface,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: [
                Text(
                  'HELP',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontSize: 10,
                        letterSpacing: 2,
                      ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  radius: 16,
                  backgroundColor: bc.surfaceContainerHigh,
                  child: Icon(Symbols.help_outline, size: 18, color: bc.onSurface),
                ),
              ],
            ),
          ),
        ],
      ),
      body: cfgAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (OnboardingConfig cfg) => _buildStep(context, bc, cfg, session),
      ),
    );
  }

  Widget _buildStep(
    BuildContext context,
    BarterColors bc,
    OnboardingConfig cfg,
    SessionState session,
  ) {
    final titles = [
      'Role & niche',
      'Interests',
      'Content types',
      'Connect socials',
      'Profile setup',
      'KPI showcase',
    ];
    final progress = (_step + 1) / titles.length;
    final wide = context.isWide;
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(wide ? 24 : 16, wide ? 8 : 16, wide ? 24 : 16, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                titles[_step],
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Text(
                'Step ${_step + 1} of ${titles.length}',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: bc.primary,
                      fontSize: 12,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: bc.surfaceContainer,
              color: bc.primary,
            ),
          ),
          const SizedBox(height: 28),
          if (_step == 0) _stepRoleNiche(context, bc, cfg, session),
          if (_step == 1) _stepInterests(context, bc, cfg, session),
          if (_step == 2) _stepContentTypes(context, bc, cfg, session),
          if (_step == 3) _stepSocials(context, bc),
          if (_step == 4) _stepProfile(context, bc),
          if (_step == 5) _stepKpi(context, bc),
          const SizedBox(height: 32),
          BarterPrimaryButton(
            label: _step == 5 ? 'Enter feed' : 'Continue',
            icon: Symbols.arrow_forward,
            onPressed: _next,
          ),
        ],
      ),
    );
  }

  Widget _stepRoleNiche(
    BuildContext context,
    BarterColors bc,
    OnboardingConfig cfg,
    SessionState session,
  ) {
    final nichesWithIcons = [
      {'name': 'Skincare & Beauty', 'icon': Symbols.auto_awesome, 'label': 'Curated'},
      {'name': 'Fashion & Style', 'icon': Symbols.styler, 'label': 'Aesthetic'},
      {'name': 'Tech & Productivity', 'icon': Symbols.devices, 'label': 'Modern'},
      {'name': 'Food & Beverage', 'icon': Symbols.restaurant, 'label': 'Gourmet'},
      {'name': 'Travel & Lifestyle', 'icon': Symbols.explore, 'label': 'Global'},
      {'name': 'Fitness & Wellness', 'icon': Symbols.fitness_center, 'label': 'Active'},
      {'name': 'Gaming', 'icon': Symbols.sports_esports, 'label': 'Digital'},
      {'name': 'Finance', 'icon': Symbols.payments, 'label': 'Capital'},
      {'name': 'Parenting', 'icon': Symbols.family_restroom, 'label': 'Nurture'},
      {'name': 'Music & Ent.', 'icon': Symbols.music_note, 'label': 'Vibe'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Find your",
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.bold,
                height: 1.1,
              ),
        ),
        Text.rich(
          TextSpan(
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            children: [
              TextSpan(
                text: 'Identity.',
                style: TextStyle(
                  color: bc.primary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Select up to 5 niches that define your content style. This helps us match you with the right editorial brands.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: bc.onSurfaceVariant,
              ),
        ),
        const SizedBox(height: 28),
        Text(
          'ACCOUNT ROLE',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                letterSpacing: 3,
                fontSize: 12,
              ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _RoleTile(
                title: 'Creator',
                subtitle: 'I produce content',
                selected: ref.watch(authProvider).role == AppRole.creator,
                onTap: () {},
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _RoleTile(
                title: 'Brand',
                subtitle: 'I seek partnerships',
                selected: ref.watch(authProvider).role == AppRole.brand,
                onTap: () {},
              ),
            ),
          ],
        ),
        const SizedBox(height: 28),
        Text(
          'SELECT NICHE',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                letterSpacing: 3,
                fontSize: 12,
              ),
        ),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          mainAxisExtent: 140,
          children: nichesWithIcons.map((n) {
            final sel = session.selectedNiches.contains(n['name'] as String);
            return _NicheCard(
              name: n['name'] as String,
              icon: n['icon'] as IconData,
              label: n['label'] as String,
              selected: sel,
              onTap: () =>
                  ref.read(sessionProvider.notifier).toggleNiche(n['name'] as String),
              bc: bc,
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        Container(
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
                  const SizedBox(height: 4),
                  RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w900,
                          ),
                      children: [
                        TextSpan(text: '${session.selectedNiches.length} '),
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
                  if (session.selectedNiches.isNotEmpty)
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: bc.surfaceContainerHighest,
                        shape: BoxShape.circle,
                        border: Border.all(color: bc.surfaceContainerLowest, width: 2),
                      ),
                      child: Icon(Icons.check, color: bc.primary, size: 20),
                    ),
                  const SizedBox(width: 8),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: bc.surfaceContainerLow,
                      shape: BoxShape.circle,
                      border: Border.all(color: bc.surfaceContainerLowest, width: 2),
                    ),
                    child: Icon(Icons.add, color: bc.onSurfaceVariant.withValues(alpha: 0.3), size: 20),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _stepInterests(
    BuildContext context,
    BarterColors bc,
    OnboardingConfig cfg,
    SessionState session,
  ) {
    final interestsWithIcons = [
      {'name': 'SaaS', 'icon': Symbols.cloud, 'subtitle': 'Digital Tools'},
      {'name': 'Physical', 'icon': Symbols.package_2, 'subtitle': 'Goods & Kits'},
      {'name': 'Events', 'icon': Symbols.confirmation_number, 'subtitle': 'VIP Access'},
      {'name': 'Tech', 'icon': Symbols.devices, 'subtitle': 'Hardware'},
      {'name': 'Lifestyle', 'icon': Symbols.auto_awesome, 'subtitle': 'Fashion & Wellness'},
      {'name': 'Courses', 'icon': Symbols.menu_book, 'subtitle': 'Masterclasses'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  height: 0.9,
                ),
            children: [
              const TextSpan(text: 'What '),
              TextSpan(
                text: 'moves',
                style: TextStyle(
                  color: bc.primary,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const TextSpan(text: ' you?'),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Select the exchange categories that align with your brand\'s aesthetic and values.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: bc.onSurfaceVariant,
              ),
        ),
        const SizedBox(height: 24),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          mainAxisExtent: 120,
          children: interestsWithIcons.map((n) {
            final sel = session.selectedInterests.contains(n['name'] as String);
            return _InterestCard(
              name: n['name'] as String,
              icon: n['icon'] as IconData,
              subtitle: n['subtitle'] as String,
              selected: sel,
              onTap: () =>
                  ref.read(sessionProvider.notifier).toggleInterest(n['name'] as String),
              bc: bc,
            );
          }).toList(),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: bc.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: bc.onBackground.withValues(alpha: 0.04),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: session.selectedInterests.isNotEmpty 
                      ? bc.primary 
                      : bc.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: bc.outlineVariant, width: 2),
                ),
                child: session.selectedInterests.isNotEmpty
                    ? Icon(Icons.check, color: bc.onPrimary, size: 16)
                    : null,
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
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: bc.onSurfaceVariant,
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

  Widget _stepContentTypes(
    BuildContext context,
    BarterColors bc,
    OnboardingConfig cfg,
    SessionState session,
  ) {
    final contentTypesWithIcons = [
      {'name': 'YouTube', 'icon': Symbols.smart_display, 'subtitle': 'Long-form video'},
      {'name': 'Instagram', 'icon': Symbols.photo_camera, 'subtitle': 'Reels & Stories'},
      {'name': 'TikTok', 'icon': Symbols.music_note, 'subtitle': 'Short-form video'},
      {'name': 'LinkedIn', 'icon': Symbols.work, 'subtitle': 'Professional posts'},
      {'name': 'Twitter/X', 'icon': Symbols.tag, 'subtitle': 'Threads & posts'},
      {'name': 'Blog', 'icon': Symbols.article, 'subtitle': 'Written content'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Content formats',
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        Text(
          'Tell brands where you publish.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: bc.onSurfaceVariant,
              ),
        ),
        const SizedBox(height: 24),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          mainAxisExtent: 120,
          children: contentTypesWithIcons.map((n) {
            final sel = session.selectedContentTypes.contains(n['name'] as String);
            return _ContentTypeCard(
              name: n['name'] as String,
              icon: n['icon'] as IconData,
              subtitle: n['subtitle'] as String,
              selected: sel,
              onTap: () =>
                  ref.read(sessionProvider.notifier).toggleContentType(n['name'] as String),
              bc: bc,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _stepSocials(BuildContext context, BarterColors bc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            children: [
              const TextSpan(text: 'Connect '),
              TextSpan(
                text: 'Socials',
                style: TextStyle(color: bc.primary),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Link your platforms to verify your reach. We use this data to match you with brands that fit your audience profile perfectly.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: bc.onSurfaceVariant,
              ),
        ),
        const SizedBox(height: 24),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          mainAxisExtent: 160,
          children: [
            _SocialConnectionCard(
              icon: Symbols.photo_camera,
              name: 'Instagram',
              handle: '@creator_studio',
              followers: '124K',
              engagement: '4.2%',
              status: 'Connected',
              bc: bc,
              isConnected: true,
            ),
            _SocialConnectionCard(
              icon: Symbols.music_note,
              name: 'TikTok',
              handle: 'Fetching profile data',
              followers: '',
              engagement: '',
              status: 'Syncing...',
              bc: bc,
              isConnected: false,
              isSyncing: true,
            ),
            _SocialConnectionCard(
              icon: Symbols.smart_display,
              name: 'YouTube',
              handle: 'Connect your channel for video content exchanges.',
              followers: '',
              engagement: '',
              status: '',
              bc: bc,
              isConnected: false,
              isAction: true,
            ),
            _SocialConnectionCard(
              icon: Symbols.work,
              name: 'LinkedIn',
              handle: 'Best for professional services and B2B creators.',
              followers: '',
              engagement: '',
              status: '',
              bc: bc,
              isConnected: false,
              isAction: true,
            ),
          ],
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: bc.surfaceContainerLow,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Icon(Symbols.verified_user, color: bc.primary, size: 24),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Privacy Secured',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                            fontSize: 12,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'BARTER only requests read-only access to your analytics. We never post on your behalf without explicit permission.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: bc.onSurfaceVariant,
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

  Widget _stepProfile(BuildContext context, BarterColors bc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  height: 1.1,
                ),
            children: [
              const TextSpan(text: 'Define your '),
              TextSpan(
                text: 'Creator',
                style: TextStyle(color: bc.primary),
              ),
              const TextSpan(text: ' Identity.'),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'This is how brands will see you. Make it personal, make it professional, make it yours.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: bc.onSurfaceVariant,
              ),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Container(
              width: 128,
              height: 128,
              decoration: BoxDecoration(
                color: bc.surfaceContainerLow,
                shape: BoxShape.circle,
                border: Border.all(color: bc.surfaceContainerHighest, width: 4),
                boxShadow: [
                  BoxShadow(
                    color: bc.onBackground.withValues(alpha: 0.05),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Stack(
                children: [
                  ClipOval(
                    child: BarterNetworkImage(
                      url: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCBdAnksszAhfcQoWzgU0nGk8VDSiw3nf0n14xFNStSH18Sa4yKsjHrexhZITcrxsky5lnaiQMUIHRmI8p0q-vf06oia37Bi2EWs8YGkul32_pO3UEqWte-KyBGy7u-azhYXu1CLCPmvmyb_k-vu8F4vO9W5NacLt-x-gu7uzynQjN2iqD2g4MU9i25ZK_cYACqqsSSKKxgBJ71sPPr9MJO8n7PStAeJpqpO9qJhv9dKAjNkk6YFWxzneCZMZ9iafB0hiBSA6CiALw',
                      fit: BoxFit.cover,
                      memCacheWidth: 200,
                      memCacheHeight: 200,
                    ),
                  ),
                  Positioned(
                    bottom: -4,
                    right: -4,
                    child: Container(
                      decoration: BoxDecoration(
                        color: bc.primary,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: bc.primary.withValues(alpha: 0.4),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.edit, size: 16),
                        color: bc.onPrimary,
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Edit photo coming soon')),
                          );
                        },
                        padding: const EdgeInsets.all(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Profile Photo',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                          fontSize: 12,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Square JPG or PNG,\nmin. 400x400px',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: bc.onSurfaceVariant.withValues(alpha: 0.7),
                        ),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Image picker coming soon')),
                      );
                    },
                    child: Text(
                      'Upload new',
                      style: TextStyle(
                        color: bc.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Display Name',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                          fontSize: 12,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: bc.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: _name,
                      decoration: InputDecoration(
                        hintText: 'e.g. Elena Rossi',
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Handle',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                          fontSize: 12,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: bc.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: _handle,
                      decoration: InputDecoration(
                        hintText: 'elenarossi',
                        prefixText: '@',
                        prefixStyle: TextStyle(color: bc.primary, fontWeight: FontWeight.bold),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Professional Bio',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                        fontSize: 12,
                      ),
                ),
                Text(
                  '0 / 160',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: bc.onSurfaceVariant.withValues(alpha: 0.4),
                        fontSize: 10,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: bc.surfaceContainerLow,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                maxLines: 4,
                maxLength: 160,
                decoration: InputDecoration(
                  hintText: 'Tell brands about your niche, style, and what you\'re looking for...',
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(16),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Base Location',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                    fontSize: 12,
                  ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: bc.surfaceContainerLow,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'City, Country',
                  prefixIcon: Icon(Icons.location_on, color: bc.primary.withValues(alpha: 0.6)),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(16),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _stepKpi(BuildContext context, BarterColors bc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'KPI showcase',
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        Text(
          'Mock metrics — wire to analytics later.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: bc.onSurfaceVariant,
              ),
        ),
        const SizedBox(height: 24),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.3,
          children: [
            _KpiCard(
              label: 'Engagement',
              value: '4.9%',
              bc: bc,
            ),
            _KpiCard(
              label: 'Reach',
              value: '128K',
              bc: bc,
            ),
            _KpiCard(
              label: 'Followers',
              value: '62K',
              bc: bc,
            ),
            _KpiCard(
              label: 'Avg Views',
              value: '45K',
              bc: bc,
            ),
          ],
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: bc.surfaceContainerLow,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Performance Metrics',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              _MetricRow(label: 'Instagram', value: '62K', engagement: '4.8%', bc: bc),
              const SizedBox(height: 12),
              _MetricRow(label: 'YouTube', value: '180K', engagement: '7.2%', bc: bc),
              const SizedBox(height: 12),
              _MetricRow(label: 'TikTok', value: '12.4K', engagement: '5.1%', bc: bc),
            ],
          ),
        ),
      ],
    );
  }
}

class _SocialConnectionCard extends StatelessWidget {
  const _SocialConnectionCard({
    required this.icon,
    required this.name,
    required this.handle,
    required this.followers,
    required this.engagement,
    required this.status,
    required this.bc,
    this.isConnected = false,
    this.isSyncing = false,
    this.isAction = false,
  });

  final IconData icon;
  final String name;
  final String handle;
  final String followers;
  final String engagement;
  final String status;
  final BarterColors bc;
  final bool isConnected;
  final bool isSyncing;
  final bool isAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isConnected ? bc.surfaceContainerLowest : bc.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: isConnected 
            ? Border.all(color: bc.primary, width: 4)
            : null,
        boxShadow: isConnected
            ? [
                BoxShadow(
                  color: bc.onBackground.withValues(alpha: 0.06),
                  blurRadius: 40,
                ),
              ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isConnected 
                      ? bc.primary.withValues(alpha: 0.1)
                      : bc.onBackground.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Icon(
                  icon,
                  color: isConnected ? bc.primary : bc.onBackground,
                  size: 32,
                ),
              ),
              if (status.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: isConnected 
                        ? bc.primary.withValues(alpha: 0.1)
                        : bc.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      if (isSyncing)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: bc.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                      if (isSyncing) const SizedBox(width: 6),
                      Text(
                        status,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: isConnected ? bc.primary : bc.onSurfaceVariant,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                              fontSize: 10,
                            ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            name,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            handle,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: bc.onSurfaceVariant,
                ),
          ),
          if (isConnected) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.only(top: 16),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: bc.surfaceContainerHighest, width: 1),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Followers',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: bc.onSurfaceVariant,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                                fontSize: 10,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          followers,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w900,
                                color: bc.primary,
                              ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Engagement',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: bc.onSurfaceVariant,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                                fontSize: 10,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          engagement,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w900,
                                color: bc.primary,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (isSyncing) ...[
            const SizedBox(height: 16),
            Column(
              children: [
                Container(
                  height: 16,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: bc.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 16,
                  width: MediaQuery.of(context).size.width * 0.3,
                  decoration: BoxDecoration(
                    color: bc.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ],
          if (isAction) ...[
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Connect to $name coming soon')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: bc.onBackground,
                foregroundColor: bc.surface,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: Text(
                'Connect $name',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ContentTypeCard extends StatelessWidget {
  const _ContentTypeCard({
    required this.name,
    required this.icon,
    required this.subtitle,
    required this.selected,
    required this.onTap,
    required this.bc,
  });

  final String name;
  final IconData icon;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;
  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: bc.surfaceContainerLow,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: bc.surfaceContainerLow,
            border: Border.all(
              color: selected ? bc.primary.withValues(alpha: 0.2) : Colors.transparent,
              width: 2,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 32),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: bc.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: bc.onBackground.withValues(alpha: 0.05),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Icon(icon, color: bc.primary, size: 24),
              ),
              Text(
                name,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: bc.onSurface,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: bc.onSurfaceVariant,
                      letterSpacing: 1,
                      fontSize: 11,
                    ),
              ),
              if (selected) ...[
                const Spacer(),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Icon(Icons.check_circle, color: bc.primary, size: 20),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _InterestCard extends StatelessWidget {
  const _InterestCard({
    required this.name,
    required this.icon,
    required this.subtitle,
    required this.selected,
    required this.onTap,
    required this.bc,
  });

  final String name;
  final IconData icon;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;
  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: bc.surfaceContainerLow,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: bc.surfaceContainerLow,
            border: Border.all(
              color: selected ? bc.primary.withValues(alpha: 0.2) : Colors.transparent,
              width: 2,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 32),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: bc.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: bc.onBackground.withValues(alpha: 0.05),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Icon(icon, color: bc.primary, size: 24),
              ),
              Text(
                name,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: bc.onSurface,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: bc.onSurfaceVariant,
                      letterSpacing: 1,
                      fontSize: 11,
                    ),
              ),
              if (selected) ...[
                const Spacer(),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Icon(Icons.check_circle, color: bc.primary, size: 20),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _NicheCard extends StatelessWidget {
  const _NicheCard({
    required this.name,
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
    required this.bc,
  });

  final String name;
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? bc.primary : bc.surfaceContainerLow,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: selected ? bc.primary : bc.surfaceContainerLow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                icon,
                color: selected ? bc.onPrimary : bc.primary,
                size: 32,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: selected 
                              ? bc.onPrimary.withValues(alpha: 0.8) 
                              : bc.onSurfaceVariant,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                          fontSize: 10,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: selected ? bc.onPrimary : bc.onSurface,
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

class _RoleTile extends StatelessWidget {
  const _RoleTile({
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bc = context.barter;
    return Material(
      color: bc.surfaceContainerLowest,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected ? bc.primary : Colors.transparent,
              width: 2,
            ),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: bc.primary.withValues(alpha: 0.08),
                      blurRadius: 16,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Icon(
                selected ? Symbols.check_circle : Symbols.radio_button_unchecked,
                color: selected ? bc.primary : bc.outline,
                fill: selected ? 1.0 : 0.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SocialRow extends StatelessWidget {
  const _SocialRow({
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bc.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: bc.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Icon(icon, color: bc.onSurface),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          Text(
            'Connect',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: bc.primary,
                ),
          ),
        ],
      ),
    );
  }
}

class _MetricRow extends StatelessWidget {
  const _MetricRow({
    required this.label,
    required this.value,
    required this.engagement,
    required this.bc,
  });

  final String label;
  final String value;
  final String engagement;
  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        Row(
          children: [
            Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(width: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: bc.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                engagement,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: bc.primary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _KpiCard extends StatelessWidget {
  const _KpiCard({
    required this.label,
    required this.value,
    required this.bc,
  });

  final String label;
  final String value;
  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bc.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: bc.onBackground.withValues(alpha: 0.04),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: Theme.of(context).textTheme.labelLarge?.copyWith(fontSize: 10),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
          ),
        ],
      ),
    );
  }
}
