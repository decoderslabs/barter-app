import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../theme/barter_colors.dart';
import '../../../widgets/barter_appbar.dart';
import '../../../widgets/barter_card.dart';

class CreateOfferRightsScreen extends StatefulWidget {
  const CreateOfferRightsScreen({super.key});

  @override
  State<CreateOfferRightsScreen> createState() => _CreateOfferRightsScreenState();
}

class _CreateOfferRightsScreenState extends State<CreateOfferRightsScreen> {
  String _contentRights = 'Tier 2: Organic Reshare';
  final TextEditingController _customTermsController = TextEditingController();
  String _proposalDeadline = '2024-05-24';
  String _maxProposals = '25 Proposals';
  String _selectedValue = '25 Proposals';

  @override
  void dispose() {
    _customTermsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bc = context.barter;
    return Scaffold(
      backgroundColor: bc.background,
      appBar: BarterAppBar(
        showBrandTitle: true,
        leading: BarterCloseButton(),
        actions: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Step 6 of 7',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: bc.onSurfaceVariant,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      fontSize: 10,
                    ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  for (int i = 0; i < 6; i++)
                    Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.only(right: 4),
                      decoration: BoxDecoration(
                        color: bc.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: bc.outlineVariant.withValues(alpha: 0.3),
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      height: 1.1,
                    ),
                children: [
                  const TextSpan(text: 'Finalizing '),
                  TextSpan(text: 'Rights', style: TextStyle(color: bc.primary)),
                  const TextSpan(text: ' & Reach.'),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Secure your content usage and define the operational boundaries of this exchange.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: bc.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 32),
            _ValueEngineTip(bc: bc),
            const SizedBox(height: 32),
            _ContentRightsSection(
              bc: bc,
              selectedRights: _contentRights,
              onRightsChanged: (val) => setState(() => _contentRights = val),
              customTermsController: _customTermsController,
            ),
            const SizedBox(height: 32),
            _DealSettingsSection(bc: bc),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: bc.surface.withValues(alpha: 0.8),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: bc.surfaceContainerLow,
                shape: BoxShape.circle,
              ),
              child: Icon(Symbols.arrow_back, color: bc.onSurface),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: ElevatedButton(
                onPressed: () => context.go('/brand/campaigns'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: bc.primary,
                  foregroundColor: bc.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Preview & Publish'),
                    const SizedBox(width: 8),
                    Icon(Symbols.rocket_launch, color: bc.onPrimary),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ValueEngineTip extends StatelessWidget {
  const _ValueEngineTip({required this.bc});

  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: bc.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        border: Border(left: BorderSide(color: bc.primary, width: 4)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: bc.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Symbols.analytics, color: bc.onPrimary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Barter Value Engine',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: bc.primary,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                        fontSize: 10,
                      ),
                ),
                const SizedBox(height: 4),
                RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: bc.onSurface,
                        ),
                    children: [
                      const TextSpan(text: 'Your offer value matches well with '),
                      TextSpan(
                        text: 'Micro-creators (10k-50k)',
                        style: TextStyle(
                          color: bc.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const TextSpan(text: '.'),
                    ],
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

class _ContentRightsSection extends StatelessWidget {
  const _ContentRightsSection({
    required this.bc,
    required this.selectedRights,
    required this.onRightsChanged,
    required this.customTermsController,
  });

  final BarterColors bc;
  final String selectedRights;
  final ValueChanged<String> onRightsChanged;
  final TextEditingController customTermsController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Symbols.gavel, color: bc.primary, size: 20),
            const SizedBox(width: 8),
            Text(
              'Content Rights Framework',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _RightsOption(
          label: 'Tier 1: No Rights',
          desc: 'Creator retains all rights. Brand may reshare with creator credit/tag only.',
          isSelected: selectedRights == 'Tier 1: No Rights',
          onTap: () => onRightsChanged('Tier 1: No Rights'),
          bc: bc,
        ),
        const SizedBox(height: 12),
        _RightsOption(
          label: 'Tier 2: Organic Reshare',
          desc: 'Usage for brand-owned social media channels for 6 months.',
          isSelected: selectedRights == 'Tier 2: Organic Reshare',
          badge: 'Default (Cafés & Experiences)',
          onTap: () => onRightsChanged('Tier 2: Organic Reshare'),
          bc: bc,
        ),
        const SizedBox(height: 12),
        _RightsOption(
          label: 'Tier 3: Paid Usage License',
          desc: 'Organic & Paid ad usage (Meta, TikTok) for 12 months.',
          isSelected: selectedRights == 'Tier 3: Paid Usage License',
          badge: 'Recommended for D2C & Drops',
          onTap: () => onRightsChanged('Tier 3: Paid Usage License'),
          bc: bc,
        ),
        const SizedBox(height: 12),
        _RightsOption(
          label: 'Tier 4: Full Buyout',
          desc: 'Perpetual commercial rights & full copyright buyout across all digital & print media.',
          isSelected: selectedRights == 'Tier 4: Full Buyout',
          onTap: () => onRightsChanged('Tier 4: Full Buyout'),
          bc: bc,
        ),
        const SizedBox(height: 24),
        Text(
          'Custom Terms & Additional Clauses (Optional)',
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: bc.onSurfaceVariant,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: customTermsController,
          maxLines: 3,
          style: TextStyle(color: bc.onSurface, fontSize: 14),
          decoration: InputDecoration(
            hintText: 'Enter any specific stipulations (e.g., exclusivity window, whitelisting, brand tag requirements)...',
            hintStyle: TextStyle(color: bc.onSurfaceVariant.withValues(alpha: 0.6)),
            filled: true,
            fillColor: bc.surfaceContainerLow,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: bc.outlineVariant.withValues(alpha: 0.3)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: bc.outlineVariant.withValues(alpha: 0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: bc.primary, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}

class _RightsOption extends StatelessWidget {
  const _RightsOption({
    required this.label,
    required this.desc,
    required this.isSelected,
    required this.bc,
    this.badge,
    this.onTap,
  });

  final String label;
  final String desc;
  final bool isSelected;
  final BarterColors bc;
  final String? badge;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: BarterCard(
        borderRadius: 16,
        padding: const EdgeInsets.all(20),
        backgroundColor: isSelected ? bc.surfaceContainerLowest : bc.surfaceContainerLow,
        borderColor: isSelected ? bc.primary : Colors.transparent,
        borderWidth: 2,
        child: Row(
          children: [
            if (isSelected)
              Icon(Symbols.check_circle, color: bc.primary, fill: 1)
            else
              Icon(Symbols.radio_button_unchecked, color: bc.outline),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        label,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      if (badge != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                          decoration: BoxDecoration(
                            color: bc.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            badge!,
                            style: TextStyle(
                              color: bc.primary,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
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
            ),
          ],
        ),
      ),
    );
  }
}

class _DealSettingsSection extends StatelessWidget {
  const _DealSettingsSection({required this.bc});

  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Symbols.settings_input_component, color: bc.primary, size: 20),
            const SizedBox(width: 8),
            Text(
              'Deal Settings',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Proposal Deadline',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: bc.onSurfaceVariant,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                          fontSize: 12,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 56,
                    decoration: BoxDecoration(
                      color: bc.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Select date',
                        hintStyle: TextStyle(
                          color: bc.onSurfaceVariant,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                        suffixIcon: Icon(Symbols.calendar_today, color: bc.onSurfaceVariant),
                      ),
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
                    'Max Proposals',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: bc.onSurfaceVariant,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                          fontSize: 12,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 56,
                    decoration: BoxDecoration(
                      color: bc.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: '25 Proposals',
                        items: const [
                          '10 Proposals',
                          '25 Proposals',
                          '50 Proposals',
                          'Unlimited',
                        ].map((String item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                        onChanged: (_) {},
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        icon: Icon(Symbols.expand_more, color: bc.onSurfaceVariant),
                        style: Theme.of(context).textTheme.bodyMedium,
                        dropdownColor: bc.surfaceContainerLowest,
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
