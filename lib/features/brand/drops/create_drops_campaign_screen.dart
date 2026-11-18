import '../../../widgets/barter_logo.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../theme/barter_colors.dart';
import '../../../theme/responsive_extension.dart';
import '../../../widgets/barter_network_image.dart';

class CreateDropsCampaignScreen extends StatefulWidget {
  const CreateDropsCampaignScreen({super.key});

  @override
  State<CreateDropsCampaignScreen> createState() => _CreateDropsCampaignScreenState();
}

class _CreateDropsCampaignScreenState extends State<CreateDropsCampaignScreen> {
  int _slotCount = 100;

  @override
  Widget build(BuildContext context) {
    final bc = context.barter;

    return Scaffold(
      backgroundColor: bc.background,
      appBar: AppBar(
        backgroundColor: bc.background,
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: bc.primary,
            shape: BoxShape.circle,
          ),
          child: Icon(Symbols.token, color: bc.surface, fill: 1),
        ),
        title: const BarterLogo(height: 28),
        actions: [
          IconButton(
            icon: Icon(Symbols.notifications, color: bc.onSurface),
            onPressed: () => context.push('/notifications/center'),
          ),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: bc.primaryFixed, width: 2),
            ),
            child: ClipOval(
              child: BarterNetworkImage(
                url: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCXjsQ_GGuZdSiiSpH_Ss9j579WkpdQaRPQRiVeP3s8Rae6l_IVZiqAKz4BLBIzckric1whg9p4w23cluUo-H8hgtEAMkQnAlFmKyvYXm4xvIPsZ33ocB96O6lDekdbN8Aacp8lntpAQ1sjZ7PJBxALbDgcI1aVoazFs2J5rLeiIDFFxPul5JzUXty9vS9NK-m8fYfPKsrHWFgXXk_a51ibtg9w3qXMZ_fl_8Sq0oxDeICq_uMv37xTjFPWcJL3G3GhUUuUQO4wxmw',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
      body: Builder(builder: (context) {
        final wide = context.isWide;
        final mainContent = [
          _CampaignIdentitySection(bc: bc),
          const SizedBox(height: 24),
          _DropMechanicsSection(
            slotCount: _slotCount,
            onSlotCountChanged: (value) => setState(() => _slotCount = value),
            bc: bc,
          ),
          const SizedBox(height: 24),
          _NavigationSection(bc: bc),
        ];
        final sideContent = [
          _ValueEngineTip(bc: bc),
          const SizedBox(height: 16),
          _PreviewCard(slotCount: _slotCount, bc: bc),
          const SizedBox(height: 16),
          _HelperTip(bc: bc),
        ];
        return SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(wide ? 48 : 16, wide ? 40 : 16, wide ? 48 : 16, 120),
          child: Column(
            children: [
              _HeaderSection(bc: bc),
              SizedBox(height: wide ? 48 : 24),
              if (wide)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 8, child: Column(children: mainContent)),
                    const SizedBox(width: 48),
                    Expanded(flex: 4, child: Column(children: sideContent)),
                  ],
                )
              else
                Column(children: [...mainContent, const SizedBox(height: 24), ...sideContent]),
            ],
          ),
        );
      }),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  const _HeaderSection({required this.bc});

  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    final wide = context.isWide;
    if (!wide) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Campaign Suite',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: bc.primary,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
          ),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    height: 1.1,
                  ),
              children: [
                const TextSpan(text: 'Launch '),
                TextSpan(text: 'New', style: TextStyle(color: bc.primary)),
                const TextSpan(text: ' Drops.'),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Scale your reach by gifting curated products to the most compatible creators.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: bc.secondary),
          ),
          const SizedBox(height: 16),
          _ProgressIndicator(bc: bc),
        ],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Campaign Suite',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: bc.primary,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
              ),
              const SizedBox(height: 8),
              RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        height: 1,
                        letterSpacing: -2,
                      ),
                  children: [
                    const TextSpan(text: 'Launch '),
                    TextSpan(text: 'New', style: TextStyle(color: bc.primary)),
                    const TextSpan(text: '\nDrops.'),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Scale your reach by gifting curated products to the most compatible creators in our network.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: bc.secondary,
                    ),
              ),
            ],
          ),
        ),
        _ProgressIndicator(bc: bc),
      ],
    );
  }
}

class _ProgressIndicator extends StatelessWidget {
  const _ProgressIndicator({required this.bc});

  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    final wide = context.isWide;
    return Row(
      mainAxisSize: wide ? MainAxisSize.min : MainAxisSize.max,
      mainAxisAlignment: wide ? MainAxisAlignment.start : MainAxisAlignment.center,
      children: [
        _Step(number: 1, label: 'Details', isActive: true, bc: bc),
        Flexible(child: Container(height: 2, constraints: const BoxConstraints(maxWidth: 48, minWidth: 16), color: bc.primaryFixed)),
        _Step(number: 2, label: 'Inventory', isActive: false, bc: bc),
        Flexible(child: Container(height: 2, constraints: const BoxConstraints(maxWidth: 48, minWidth: 16), color: bc.primaryFixed)),
        _Step(number: 3, label: 'Review', isActive: false, bc: bc),
      ],
    );
  }
}

class _Step extends StatelessWidget {
  const _Step({
    required this.number,
    required this.label,
    required this.isActive,
    required this.bc,
  });

  final int number;
  final String label;
  final bool isActive;
  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isActive ? bc.primary : Colors.transparent,
            border: Border.all(
              color: isActive ? bc.primary : bc.secondary,
              width: 2,
            ),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number.toString(),
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: isActive ? bc.surface : bc.secondary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: isActive ? bc.primary : bc.secondary.withValues(alpha: 0.4),
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
                fontSize: 10,
              ),
        ),
      ],
    );
  }
}

class _CampaignIdentitySection extends StatelessWidget {
  const _CampaignIdentitySection({required this.bc});

  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.isWide ? 32 : 20),
      decoration: BoxDecoration(
        color: bc.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: bc.onBackground.withValues(alpha: 0.06),
            blurRadius: 80,
            offset: const Offset(0, 40),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Symbols.edit_note, color: bc.primary),
              const SizedBox(width: 12),
              Text(
                'Campaign Identity',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          TextField(
            decoration: InputDecoration(
              labelText: 'Campaign Name',
              hintText: 'e.g. Summer Essentials 2024',
              filled: true,
              fillColor: bc.surfaceContainerLow,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            ),
          ),
          const SizedBox(height: 16),
          if (context.isWide)
            Row(children: [
              Expanded(child: _goalField(bc)),
              const SizedBox(width: 24),
              Expanded(child: _deadlineField(bc)),
            ])
          else
            Column(children: [
              _goalField(bc),
              const SizedBox(height: 16),
              _deadlineField(bc),
            ]),
        ],
      ),
    );
  }

  Widget _goalField(BarterColors bc) => DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: 'Goal',
          filled: true,
          fillColor: bc.surfaceContainerLow,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
        items: const [
          DropdownMenuItem(value: 'launch', child: Text('Product Launch')),
          DropdownMenuItem(value: 'awareness', child: Text('Brand Awareness')),
          DropdownMenuItem(value: 'ugc', child: Text('User Generated Content')),
          DropdownMenuItem(value: 'seasonal', child: Text('Seasonal Push')),
        ],
        onChanged: (value) {},
      );

  Widget _deadlineField(BarterColors bc) => TextField(
        decoration: InputDecoration(
          labelText: 'Application Deadline',
          filled: true,
          fillColor: bc.surfaceContainerLow,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      );
}

class _DropMechanicsSection extends StatelessWidget {
  const _DropMechanicsSection({
    required this.slotCount,
    required this.onSlotCountChanged,
    required this.bc,
  });

  final int slotCount;
  final ValueChanged<int> onSlotCountChanged;
  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    final wide = context.isWide;
    return Container(
      padding: EdgeInsets.all(wide ? 32 : 20),
      decoration: BoxDecoration(
        color: bc.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: bc.onBackground.withValues(alpha: 0.06),
            blurRadius: 80,
            offset: const Offset(0, 40),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Symbols.settings_suggest, color: bc.primary),
              const SizedBox(width: 12),
              Text(
                'Drop Mechanics',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          if (wide)
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Slot Count',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: bc.onSurfaceVariant,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: bc.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () => onSlotCountChanged(slotCount - 1),
                            icon: Icon(Symbols.remove),
                          ),
                          Expanded(
                            child: Text(
                              slotCount.toString(),
                              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          IconButton(
                            onPressed: () => onSlotCountChanged(slotCount + 1),
                            icon: Icon(Symbols.add),
                            style: IconButton.styleFrom(
                              backgroundColor: bc.primary,
                              foregroundColor: bc.onPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Maximum slots determined by tier',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: bc.onSurfaceVariant.withValues(alpha: 0.6),
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                            fontSize: 10,
                          ),
                    ),
                  ],
                ),
              ),
                const SizedBox(width: 32),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Approval Mode',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: bc.onSurfaceVariant,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: bc.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Manual review selected')),
                                );
                              },
                              icon: Icon(Symbols.verified, size: 18),
                              label: Text('Manual'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: bc.surface,
                                foregroundColor: bc.onSurface,
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Auto-approve selected')),
                                );
                              },
                              icon: Icon(Symbols.bolt, size: 18),
                              label: Text('Auto'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: bc.onSurfaceVariant.withValues(alpha: 0.6),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Review every applicant individually',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: bc.onSurfaceVariant.withValues(alpha: 0.6),
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                            fontSize: 10,
                          ),
                    ),
                  ],
                ),
              ),
              ],
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Total Slot Count', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: bc.onSurfaceVariant, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: bc.surfaceContainerLow, borderRadius: BorderRadius.circular(16)),
                  child: Row(children: [
                    IconButton(onPressed: () => onSlotCountChanged(slotCount - 1), icon: Icon(Symbols.remove)),
                    Expanded(child: Text(slotCount.toString(), style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
                    IconButton(onPressed: () => onSlotCountChanged(slotCount + 1), icon: Icon(Symbols.add), style: IconButton.styleFrom(backgroundColor: bc.primary, foregroundColor: bc.onPrimary)),
                  ]),
                ),
                const SizedBox(height: 20),
                Text('Approval Mode', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: bc.onSurfaceVariant, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(color: bc.surfaceContainerLow, borderRadius: BorderRadius.circular(16)),
                  child: Row(children: [
                    Expanded(child: ElevatedButton.icon(onPressed: () {}, icon: Icon(Symbols.verified, size: 18), label: const Text('Manual'), style: ElevatedButton.styleFrom(backgroundColor: bc.surface, foregroundColor: bc.onSurface, elevation: 4, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))))),
                    const SizedBox(width: 8),
                    Expanded(child: OutlinedButton.icon(onPressed: () {}, icon: Icon(Symbols.bolt, size: 18), label: const Text('Auto'), style: OutlinedButton.styleFrom(foregroundColor: bc.onSurfaceVariant, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))))),
                  ]),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _NavigationSection extends StatelessWidget {
  const _NavigationSection({required this.bc});

  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    final wide = context.isWide;
    final cancelBtn = OutlinedButton(
      onPressed: () => context.canPop() ? context.pop() : context.go('/brand/drops'),
      style: OutlinedButton.styleFrom(
        foregroundColor: bc.secondary,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      ),
      child: Text('Cancel Draft', style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold)),
    );
    final continueBtn = ElevatedButton.icon(
      onPressed: () => context.go('/brand/drops'),
      icon: const Icon(Symbols.arrow_forward),
      label: Text('Continue', style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold)),
      style: ElevatedButton.styleFrom(
        backgroundColor: bc.primary,
        foregroundColor: bc.onPrimary,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
        elevation: 10,
        shadowColor: bc.primary.withValues(alpha: 0.2),
      ),
    );
    if (!wide) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          continueBtn,
          const SizedBox(height: 12),
          cancelBtn,
        ],
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [cancelBtn, continueBtn],
    );
  }
}

class _ValueEngineTip extends StatelessWidget {
  const _ValueEngineTip({required this.bc});

  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: bc.primary,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: bc.surface.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Symbols.insights, color: bc.surface, fill: 1),
          ),
          const SizedBox(height: 24),
          Text(
            'Barter Value Engine™',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: bc.surface,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          Text(
            'Our algorithm suggests a Value Score of 84 for this configuration. This ensures high-quality creators apply to your drop.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: bc.surface.withValues(alpha: 0.8),
                  height: 1.6,
                ),
          ),
          const SizedBox(height: 24),
          Container(
            height: 8,
            decoration: BoxDecoration(
              color: bc.surface.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              widthFactor: 0.84,
              alignment: Alignment.centerLeft,
              child: Container(
                decoration: BoxDecoration(
                  color: bc.surface,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Optimal Fairness Match',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: bc.surface.withValues(alpha: 0.6),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  fontSize: 10,
                ),
          ),
        ],
      ),
    );
  }
}

class _PreviewCard extends StatelessWidget {
  const _PreviewCard({required this.slotCount, required this.bc});

  final int slotCount;
  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: bc.surfaceContainerLow,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: bc.outlineVariant.withValues(alpha: 0.3),
          width: 2,
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Creator View Preview',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: bc.onSurfaceVariant,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  fontSize: 11,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Container(
            decoration: BoxDecoration(
              color: bc.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Container(
                      height: 160,
                      decoration: BoxDecoration(
                        color: bc.surfaceContainerHighest,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                      ),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                        child: BarterNetworkImage(
                          url: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBE9e7E9X6UZjaZajcwUGPvXu9L6Ndm0EkGRqUhGP0LyRtu6hwGQqv1MOITQ3nxFf8-BchCiw74Ms5CBvYjCrOs3PdhJaDFq56TGeJrTP1jkeVbSSHphQrBz7rZrtQlmgPe9HYhVCA8GsaTCfanhy3gHskFMOacrCG6W7fIhodp4WOConSSCqnUz0TkuxIIvv0BNDTo3KR-gV6BlA20y7fyBsCxgbkIOAh17chz7lypJSTlSUX7vx_ma3ko2UyMTRhY9e-bzhxI3Zo',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 16,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: bc.primary,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          '$slotCount SLOTS',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: bc.onPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 48,
                        height: 4,
                        decoration: BoxDecoration(
                          color: bc.primary.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        height: 20,
                        width: double.infinity * 0.75,
                        decoration: BoxDecoration(
                          color: bc.surfaceContainerHigh,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 12,
                        width: double.infinity * 0.5,
                        decoration: BoxDecoration(
                          color: bc.surfaceContainer,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: List.generate(
                              3,
                              (index) => Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: [
                                      bc.surfaceContainerHighest,
                                      bc.surfaceContainer,
                                      bc.outlineVariant,
                                    ][index],
                                    shape: BoxShape.circle,
                                    border: Border.all(color: bc.surface, width: 2),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: 32,
                            width: 80,
                            decoration: BoxDecoration(
                              color: bc.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Estimated Reach: 2.4M - 4.1M',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: bc.secondary,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w500,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _HelperTip extends StatelessWidget {
  const _HelperTip({required this.bc});

  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Symbols.lightbulb, color: bc.primary),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Did you know?',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Campaigns with "Manual Approval" see 15% higher content quality but take longer to fulfill.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: bc.secondary,
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
