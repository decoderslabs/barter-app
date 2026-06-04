import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../theme/barter_colors.dart';
import '../../../widgets/barter_appbar.dart';
import '../../../widgets/barter_card.dart';

class CreateOfferRequirementsScreen extends StatefulWidget {
  const CreateOfferRequirementsScreen({super.key});

  @override
  State<CreateOfferRequirementsScreen> createState() => _CreateOfferRequirementsScreenState();
}

class _CreateOfferRequirementsScreenState extends State<CreateOfferRequirementsScreen> {
  final Set<String> _selectedDeliverables = {'IG Reel'};
  int _quantity = 2;
  double _minFollowers = 50000;
  double _engagementRate = 3.5;
  bool _verifiedOnly = true;

  @override
  Widget build(BuildContext context) {
    final bc = context.barter;
    return Scaffold(
      backgroundColor: bc.surface,
      appBar: BarterAppBar(
        showBrandTitle: true,
        actions: [
          IconButton(
            icon: Icon(Symbols.notifications, color: bc.onBackground),
            onPressed: () => context.push('/notifications/center'),
          ),
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
                      'Step 4 & 5 of 6',
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
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        fontWeight: FontWeight.bold,
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
            _DeliverablesSection(bc: bc),
            const SizedBox(height: 32),
            _RequirementsSection(bc: bc),
            const SizedBox(height: 32),
            _TrustBadge(bc: bc),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: bc.surfaceContainerLowest,
          border: Border(top: BorderSide(color: bc.outlineVariant.withValues(alpha: 0.1))),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => context.push('/brand/campaigns/create/rights'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: bc.primary,
                  foregroundColor: bc.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Next: Content Rights'),
                    const SizedBox(width: 12),
                    Icon(Symbols.arrow_forward, color: bc.onPrimary),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Changes are saved automatically to your drafts.',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: bc.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DeliverablesSection extends StatelessWidget {
  const _DeliverablesSection({required this.bc});

  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: bc.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  '4',
                  style: TextStyle(color: bc.onPrimary, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Text(
              'What do you want in return?',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(child: _DeliverableCard(label: 'IG Reel', icon: Symbols.movie_filter, isSelected: true, desc: 'Vertical video content', bc: bc)),
            const SizedBox(width: 16),
            Expanded(child: _DeliverableCard(label: 'TikTok', icon: Symbols.music_video, isSelected: false, desc: 'Short-form viral clip', bc: bc)),
            const SizedBox(width: 16),
            Expanded(child: _DeliverableCard(label: 'YouTube', icon: Symbols.video_library, isSelected: false, desc: 'Detailed review or vlog', bc: bc)),
          ],
        ),
        const SizedBox(height: 24),
        BarterCard(
          borderRadius: 32,
          padding: const EdgeInsets.all(32),
          backgroundColor: bc.surfaceContainerLow,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quantity of pieces',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Total unique content assets required',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: bc.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: bc.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(999),
                  boxShadow: [
                    BoxShadow(
                      color: bc.onBackground.withValues(alpha: 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: bc.surfaceContainerLow,
                      ),
                      child: Icon(Icons.remove),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      '02',
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: bc.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.add, color: bc.onPrimary),
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

class _DeliverableCard extends StatelessWidget {
  const _DeliverableCard({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.desc,
    required this.bc,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final String desc;
  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return BarterCard(
      borderRadius: 16,
      padding: const EdgeInsets.all(24),
      borderColor: isSelected ? bc.primary : Colors.transparent,
      borderWidth: 2,
      child: Stack(
        children: [
          if (isSelected)
            Positioned(
              top: 12,
              right: 12,
              child: Icon(Symbols.check_circle, color: bc.primary, size: 20, fill: 1),
            ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 32, color: isSelected ? bc.primary : bc.onSurfaceVariant),
              const SizedBox(height: 16),
              Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                desc,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: bc.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RequirementsSection extends StatelessWidget {
  const _RequirementsSection({required this.bc});

  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: bc.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  '5',
                  style: TextStyle(color: bc.onPrimary, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Text(
              'Creator requirements',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Minimum Followers',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: bc.onSurfaceVariant,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    fontSize: 12,
                  ),
            ),
            const SizedBox(height: 16),
            Column(
              children: [
                Slider(
                  value: 50000,
                  min: 1000,
                  max: 1000000,
                  onChanged: (_) {},
                  activeColor: bc.primary,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('1K', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: bc.onSurfaceVariant)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      decoration: BoxDecoration(
                        color: bc.primaryFixed,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        '50,000+ Followers',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: bc.onPrimaryFixedVariant,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    Text('1M', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: bc.onSurfaceVariant)),
                  ],
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: _RequirementCard(
                label: 'Min. Engagement Rate',
                value: '3.5%',
                desc: 'High quality audience interaction required.',
                bc: bc,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _RequirementCard(
                label: 'Account Type',
                value: 'Verified Only',
                isToggle: true,
                bc: bc,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _RequirementCard extends StatelessWidget {
  const _RequirementCard({
    required this.label,
    required this.value,
    this.desc,
    this.isToggle = false,
    required this.bc,
  });

  final String label;
  final String value;
  final String? desc;
  final bool isToggle;
  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return BarterCard(
      borderRadius: 16,
      padding: const EdgeInsets.all(24),
      borderColor: bc.outlineVariant.withValues(alpha: 0.2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: bc.onSurfaceVariant,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  fontSize: 12,
                ),
          ),
          const SizedBox(height: 16),
          if (isToggle)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: bc.surfaceContainerLow,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Verified Only',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Container(
                    width: 40,
                    height: 24,
                    decoration: BoxDecoration(
                      color: bc.primary,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(2),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: bc.onPrimary,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            Row(
              children: [
                Text(
                  value,
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        color: bc.primary,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -1,
                      ),
                ),
                Container(
                  height: 40,
                  width: 1,
                  color: bc.outlineVariant.withValues(alpha: 0.3),
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                ),
                Expanded(
                  child: Text(
                    desc ?? '',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: bc.onSurfaceVariant,
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

class _TrustBadge extends StatelessWidget {
  const _TrustBadge({required this.bc});

  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return BarterCard(
      borderRadius: 16,
      padding: const EdgeInsets.all(16),
      backgroundColor: bc.tertiaryContainer.withValues(alpha: 0.1),
      child: Row(
        children: [
          Icon(Symbols.verified_user, color: bc.tertiary),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Trust-First Marketplace',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: bc.onTertiaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'BARTER verifies creator metrics in real-time. These filters ensure your campaign matches with verified, high-performance talent.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: bc.onTertiaryContainer.withValues(alpha: 0.8),
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
