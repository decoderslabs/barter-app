import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../theme/barter_colors.dart';
import '../../../widgets/barter_appbar.dart';
import '../../../widgets/barter_card.dart';
import 'create_offer_wizard_provider.dart';

class CreateOfferRequirementsScreen extends ConsumerStatefulWidget {
  const CreateOfferRequirementsScreen({super.key});

  @override
  ConsumerState<CreateOfferRequirementsScreen> createState() => _CreateOfferRequirementsScreenState();
}

class _CreateOfferRequirementsScreenState extends ConsumerState<CreateOfferRequirementsScreen> {
  late Set<String> _selectedDeliverables;
  int _deliverablesCount = 2;
  double _minFollowers = 50000;
  double _engagementRate = 3.5;
  bool _verifiedOnly = true;

  @override
  void initState() {
    super.initState();
    final wizard = ref.read(createOfferWizardProvider);
    _selectedDeliverables = wizard.contentAsk.isNotEmpty
        ? Set<String>.from(wizard.contentAsk)
        : {'IG Reel'};
  }

  void _onToggleDeliverable(String label) {
    setState(() {
      if (_selectedDeliverables.contains(label)) {
        if (_selectedDeliverables.length > 1) {
          _selectedDeliverables.remove(label);
        }
      } else {
        _selectedDeliverables.add(label);
      }
    });
  }

  void _onNext() {
    ref.read(createOfferWizardProvider.notifier).updateRequirements(
      contentAsk: _selectedDeliverables.toList(),
      kpiPreferences: [
        'Min Followers: ${(_minFollowers / 1000).toInt()}K',
        'Engagement Rate: ${_engagementRate.toStringAsFixed(1)}%',
        if (_verifiedOnly) 'Verified Only',
      ],
    );
    context.push('/brand/campaigns/create/rights');
  }

  @override
  Widget build(BuildContext context) {
    final bc = context.barter;
    return Scaffold(
      backgroundColor: bc.surface,
      appBar: BarterAppBar(
        showBrandTitle: true,
        leading: BarterBackButton(onPressed: () => context.pop()),
        actions: const [
          BarterCloseButton(),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '02 / 03',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: bc.primary,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                            fontSize: 12,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Deliverables & Requirements',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                Text(
                  '66%',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: bc.primary,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: 0.66,
                minHeight: 6,
                backgroundColor: bc.surfaceContainerHigh,
                color: bc.primary,
              ),
            ),
            const SizedBox(height: 32),
            _DeliverablesSection(
              selectedDeliverables: _selectedDeliverables,
              onToggle: _onToggleDeliverable,
              deliverablesCount: _deliverablesCount,
              onCountChanged: (val) => setState(() => _deliverablesCount = val),
              bc: bc,
            ),
            const SizedBox(height: 32),
            _RequirementsSection(
              minFollowers: _minFollowers,
              onMinFollowersChanged: (val) => setState(() => _minFollowers = val),
              engagementRate: _engagementRate,
              onEngagementRateChanged: (val) => setState(() => _engagementRate = val),
              verifiedOnly: _verifiedOnly,
              onVerifiedOnlyChanged: (val) => setState(() => _verifiedOnly = val),
              bc: bc,
            ),
            const SizedBox(height: 32),
            _TrustBadge(bc: bc),
            const SizedBox(height: 32),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: bc.surfaceContainerLowest,
          border: Border(top: BorderSide(color: bc.outlineVariant.withValues(alpha: 0.15))),
        ),
        child: SafeArea(
          child: Row(
            children: [
              IconButton(
                onPressed: () => context.pop(),
                icon: const Icon(Symbols.arrow_back),
                style: IconButton.styleFrom(
                  backgroundColor: bc.surfaceContainerLow,
                  padding: const EdgeInsets.all(16),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: _onNext,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: bc.primary,
                    foregroundColor: bc.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Next: Content Rights',
                        style: TextStyle(
                          letterSpacing: 1.5,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(Symbols.arrow_forward, color: bc.onPrimary),
                    ],
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

class _DeliverablesSection extends StatelessWidget {
  const _DeliverablesSection({
    required this.selectedDeliverables,
    required this.onToggle,
    required this.deliverablesCount,
    required this.onCountChanged,
    required this.bc,
  });

  final Set<String> selectedDeliverables;
  final ValueChanged<String> onToggle;
  final int deliverablesCount;
  final ValueChanged<int> onCountChanged;
  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: bc.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  '1',
                  style: TextStyle(color: bc.onPrimary, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'What do you want in return?',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _DeliverableCard(
              label: 'IG Reel',
              icon: Symbols.movie_filter,
              isSelected: selectedDeliverables.contains('IG Reel'),
              desc: 'Vertical video reel with product in focus',
              onTap: () => onToggle('IG Reel'),
              bc: bc,
            ),
            _DeliverableCard(
              label: 'TikTok Video',
              icon: Symbols.music_video,
              isSelected: selectedDeliverables.contains('TikTok Video'),
              desc: 'Short-form dynamic video post',
              onTap: () => onToggle('TikTok Video'),
              bc: bc,
            ),
            _DeliverableCard(
              label: 'YouTube Dedicated',
              icon: Symbols.video_library,
              isSelected: selectedDeliverables.contains('YouTube Dedicated'),
              desc: 'In-depth review or dedicated integration',
              onTap: () => onToggle('YouTube Dedicated'),
              bc: bc,
            ),
            _DeliverableCard(
              label: 'Instagram Story Set',
              icon: Symbols.history_toggle_off,
              isSelected: selectedDeliverables.contains('Instagram Story Set'),
              desc: '3-4 slides with link stickers and tagging',
              onTap: () => onToggle('Instagram Story Set'),
              bc: bc,
            ),
          ],
        ),
        const SizedBox(height: 24),
        BarterCard(
          borderRadius: 20,
          padding: const EdgeInsets.all(24),
          backgroundColor: bc.surfaceContainerLow,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quantity of Assets Required',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Total unique deliverables creator must submit',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: bc.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: deliverablesCount > 1 ? () => onCountChanged(deliverablesCount - 1) : null,
                    icon: const Icon(Icons.remove),
                    style: IconButton.styleFrom(
                      backgroundColor: bc.surfaceContainerLowest,
                      padding: const EdgeInsets.all(8),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      '$deliverablesCount'.padLeft(2, '0'),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => onCountChanged(deliverablesCount + 1),
                    icon: const Icon(Icons.add),
                    style: IconButton.styleFrom(
                      backgroundColor: bc.primary,
                      foregroundColor: bc.onPrimary,
                      padding: const EdgeInsets.all(8),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DeliverableCard extends StatelessWidget {
  const _DeliverableCard({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.desc,
    required this.onTap,
    required this.bc,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final String desc;
  final VoidCallback onTap;
  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 260,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: isSelected ? bc.primary.withValues(alpha: 0.08) : bc.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? bc.primary : bc.outlineVariant.withValues(alpha: 0.2),
              width: 2,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(icon, size: 28, color: isSelected ? bc.primary : bc.onSurfaceVariant),
                  if (isSelected)
                    Icon(Symbols.check_circle, color: bc.primary, size: 20, fill: 1)
                  else
                    Icon(Symbols.radio_button_unchecked, color: bc.outlineVariant, size: 20),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                label,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isSelected ? bc.primary : bc.onSurface,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                desc,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: bc.onSurfaceVariant,
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RequirementsSection extends StatelessWidget {
  const _RequirementsSection({
    required this.minFollowers,
    required this.onMinFollowersChanged,
    required this.engagementRate,
    required this.onEngagementRateChanged,
    required this.verifiedOnly,
    required this.onVerifiedOnlyChanged,
    required this.bc,
  });

  final double minFollowers;
  final ValueChanged<double> onMinFollowersChanged;
  final double engagementRate;
  final ValueChanged<double> onEngagementRateChanged;
  final bool verifiedOnly;
  final ValueChanged<bool> onVerifiedOnlyChanged;
  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    final followersK = (minFollowers / 1000).toInt();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: bc.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  '2',
                  style: TextStyle(color: bc.onPrimary, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Creator Audience Requirements',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        BarterCard(
          borderRadius: 20,
          padding: const EdgeInsets.all(24),
          backgroundColor: bc.surfaceContainerLowest,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'MINIMUM FOLLOWERS',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: bc.onSurfaceVariant,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                          fontSize: 11,
                        ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                    decoration: BoxDecoration(
                      color: bc.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      '$followersK,000+ Followers',
                      style: TextStyle(
                        color: bc.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Slider(
                value: minFollowers,
                min: 5000,
                max: 500000,
                divisions: 99,
                activeColor: bc.primary,
                onChanged: onMinFollowersChanged,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('5K', style: TextStyle(color: bc.onSurfaceVariant, fontSize: 12)),
                  Text('250K', style: TextStyle(color: bc.onSurfaceVariant, fontSize: 12)),
                  Text('500K+', style: TextStyle(color: bc.onSurfaceVariant, fontSize: 12)),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: BarterCard(
                borderRadius: 20,
                padding: const EdgeInsets.all(20),
                backgroundColor: bc.surfaceContainerLowest,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'MIN. ENGAGEMENT RATE',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: bc.onSurfaceVariant,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                            fontSize: 10,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${engagementRate.toStringAsFixed(1)}%',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: bc.primary,
                              ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: engagementRate > 1.0
                                  ? () => onEngagementRateChanged(engagementRate - 0.5)
                                  : null,
                              icon: const Icon(Icons.remove, size: 16),
                              style: IconButton.styleFrom(
                                backgroundColor: bc.surfaceContainerLow,
                                padding: const EdgeInsets.all(6),
                              ),
                            ),
                            const SizedBox(width: 4),
                            IconButton(
                              onPressed: engagementRate < 15.0
                                  ? () => onEngagementRateChanged(engagementRate + 0.5)
                                  : null,
                              icon: const Icon(Icons.add, size: 16),
                              style: IconButton.styleFrom(
                                backgroundColor: bc.primary,
                                foregroundColor: bc.onPrimary,
                                padding: const EdgeInsets.all(6),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Only creators with proven engagement',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: bc.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: BarterCard(
                borderRadius: 20,
                padding: const EdgeInsets.all(20),
                backgroundColor: bc.surfaceContainerLowest,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'VERIFICATION STATUS',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: bc.onSurfaceVariant,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                            fontSize: 10,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          verifiedOnly ? 'Verified Only' : 'All Creators',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        Switch(
                          value: verifiedOnly,
                          onChanged: onVerifiedOnlyChanged,
                          activeColor: bc.primary,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Requires Barter Verified badge',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: bc.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _TrustBadge extends StatelessWidget {
  const _TrustBadge({required this.bc});

  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return BarterCard(
      borderRadius: 16,
      padding: const EdgeInsets.all(20),
      backgroundColor: bc.surfaceContainerLowest,
      child: Row(
        children: [
          Icon(Symbols.verified_user, color: bc.primary, size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Automated Escrow & Deliverable Verification',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Creators are committed to the agreed deliverables before products are shipped.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
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
