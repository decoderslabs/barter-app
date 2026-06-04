import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../theme/barter_colors.dart';

class ContentRightsScreen extends StatefulWidget {
  const ContentRightsScreen({super.key});

  @override
  State<ContentRightsScreen> createState() => _ContentRightsScreenState();
}

class _ContentRightsScreenState extends State<ContentRightsScreen> {
  String _usageLicense = 'Standard';
  String _rawFiles = 'No raw files needed';
  String _exclusivity = 'Non-exclusive';
  bool _creditRequired = true;

  @override
  Widget build(BuildContext context) {
    final bc = context.barter;
    return Scaffold(
      backgroundColor: bc.background,
      appBar: AppBar(
        backgroundColor: bc.background,
        leading: IconButton(
          icon: Icon(Symbols.arrow_back, color: bc.onBackground),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Rights Selection',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Text(
              'Step 6 of 6',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: bc.primary,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    fontSize: 10,
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
            RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      height: 1.1,
                    ),
                children: [
                  const TextSpan(text: 'The '),
                  TextSpan(text: 'Legal', style: TextStyle(color: bc.primary)),
                  const TextSpan(text: ' Canvas.'),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Define how your brand will own and distribute the content created in this exchange.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: bc.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 32),
            _UsageLicenseSection(bc: bc),
            const SizedBox(height: 32),
            _RawFilesSection(bc: bc),
            const SizedBox(height: 32),
            _ExclusivitySection(bc: bc),
            const SizedBox(height: 32),
            _CreditRequirementToggle(bc: bc),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: bc.surfaceContainerLowest.withValues(alpha: 0.6),
          border: Border(top: BorderSide(color: bc.outlineVariant.withValues(alpha: 0.15))),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton.icon(
              onPressed: () => context.pop(),
              icon: Icon(Symbols.chevron_left, color: bc.onBackground),
              label: Text(
                'Back',
                style: TextStyle(
                  color: bc.onBackground,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () => context.go('/brand/dashboard'),
              icon: Icon(Symbols.arrow_forward, color: bc.onPrimary),
              label: const Text('Continue'),
              style: ElevatedButton.styleFrom(
                backgroundColor: bc.primary,
                foregroundColor: bc.onPrimary,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                elevation: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UsageLicenseSection extends StatelessWidget {
  const _UsageLicenseSection({required this.bc});

  final BarterColors bc;

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
              'Usage License',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: bc.secondary,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _UsageOption(
          label: 'None',
          description: 'Creator retains all rights. Brand may repost on social channels only with explicit credit to the creator.',
          value: 'None',
          groupValue: 'Standard',
          onChanged: (_) {},
          bc: bc,
        ),
        const SizedBox(height: 12),
        _UsageOption(
          label: 'Standard',
          description: 'Brand can repost on owned channels (Instagram, TikTok, Web) for a period of 6 months.',
          value: 'Standard',
          groupValue: 'Standard',
          onChanged: (_) {},
          bc: bc,
        ),
        const SizedBox(height: 12),
        _UsageOption(
          label: 'Extended',
          description: 'Brand can use content in paid advertisements and digital billboards for 12 months.',
          value: 'Extended',
          groupValue: 'Standard',
          onChanged: (_) {},
          bc: bc,
          isValueBoost: true,
        ),
        const SizedBox(height: 12),
        _UsageOption(
          label: 'Full Buyout',
          description: 'Brand owns content permanently across all channels globally. No expiration date.',
          value: 'Full Buyout',
          groupValue: 'Standard',
          onChanged: (_) {},
          bc: bc,
          isPremium: true,
        ),
      ],
    );
  }
}

class _UsageOption extends StatelessWidget {
  const _UsageOption({
    required this.label,
    required this.description,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.bc,
    this.isValueBoost = false,
    this.isPremium = false,
  });

  final String label;
  final String description;
  final String value;
  final String groupValue;
  final ValueChanged<String?> onChanged;
  final BarterColors bc;
  final bool isValueBoost;
  final bool isPremium;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isPremium ? bc.surfaceContainerHighest.withValues(alpha: 0.3) : bc.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isPremium ? bc.primary : bc.outlineVariant.withValues(alpha: 0.2),
          width: isPremium ? 2 : 1,
        ),
        boxShadow: isPremium
            ? [
                BoxShadow(
                  color: bc.onBackground.withValues(alpha: 0.06),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ]
            : [
                BoxShadow(
                  color: bc.onBackground.withValues(alpha: 0.02),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    label,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  if (isValueBoost) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: bc.tertiaryContainer,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'Value Boost',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: bc.onTertiaryContainer,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                              fontSize: 10,
                            ),
                      ),
                    ),
                  ],
                  if (isPremium) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: bc.primary,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'Premium',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: bc.onPrimary,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                              fontSize: 10,
                            ),
                      ),
                    ),
                  ],
                ],
              ),
              Radio<String>(
                value: value,
                groupValue: groupValue,
                onChanged: onChanged,
                fillColor: MaterialStateProperty.all(bc.primary),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: bc.onSurfaceVariant,
                ),
          ),
          if (isValueBoost || isPremium) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  isValueBoost ? Symbols.trending_up : Symbols.tips_and_updates,
                  color: bc.primary,
                  size: 16,
                ),
                const SizedBox(width: 6),
                Text(
                  isValueBoost ? 'Barter Value Engine: This increases your deal value' : 'Strongly recommended for ad campaigns',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: bc.primary,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        fontSize: 11,
                      ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _RawFilesSection extends StatelessWidget {
  const _RawFilesSection({required this.bc});

  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Symbols.folder_zip, color: bc.primary, size: 20),
            const SizedBox(width: 8),
            Text(
              'Raw Files',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: bc.secondary,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _RawFileOption(
                icon: Symbols.block,
                label: 'No raw files needed',
                isSelected: true,
                bc: bc,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _RawFileOption(
                icon: Symbols.file_download,
                label: 'Request raw files',
                isSelected: false,
                bc: bc,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _RawFileOption(
                icon: Symbols.priority_high,
                label: 'Raw files mandatory',
                isSelected: false,
                bc: bc,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _RawFileOption extends StatelessWidget {
  const _RawFileOption({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.bc,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bc.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: isSelected ? bc.primary : bc.onSurfaceVariant,
            size: 32,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isSelected ? bc.primary : bc.onSurface,
                ),
          ),
        ],
      ),
    );
  }
}

class _ExclusivitySection extends StatelessWidget {
  const _ExclusivitySection({required this.bc});

  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Symbols.verified_user, color: bc.primary, size: 20),
            const SizedBox(width: 8),
            Text(
              'Exclusivity',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: bc.secondary,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _ExclusivityOption(
          icon: Symbols.public,
          label: 'Non-exclusive',
          description: 'Creator can work with any brand immediately.',
          isSelected: true,
          bc: bc,
        ),
        const SizedBox(height: 12),
        _ExclusivityOption(
          icon: Symbols.category,
          label: 'Category exclusive',
          description: 'No competitors in your industry for 30 days.',
          isSelected: false,
          bc: bc,
        ),
        const SizedBox(height: 12),
        _ExclusivityOption(
          icon: Symbols.lock,
          label: 'Full exclusive',
          description: 'No other brand collaborations for 60 days.',
          isSelected: false,
          bc: bc,
        ),
      ],
    );
  }
}

class _ExclusivityOption extends StatelessWidget {
  const _ExclusivityOption({
    required this.icon,
    required this.label,
    required this.description,
    required this.isSelected,
    required this.bc,
  });

  final IconData icon;
  final String label;
  final String description;
  final bool isSelected;
  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bc.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: bc.outlineVariant.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: bc.surfaceContainerHigh,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: bc.onSurfaceVariant),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: bc.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
          Radio<String>(
            value: label,
            groupValue: isSelected ? label : null,
            onChanged: (_) {},
            fillColor: MaterialStateProperty.all(bc.primary),
          ),
        ],
      ),
    );
  }
}

class _CreditRequirementToggle extends StatelessWidget {
  const _CreditRequirementToggle({required this.bc});

  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: bc.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: bc.primary.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: bc.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Symbols.alternate_email, color: bc.onPrimary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Credit Requirement',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  'Creator must tag brand in all posts.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: bc.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
          Switch(
            value: true,
            onChanged: (_) {},
            activeColor: bc.primary,
          ),
        ],
      ),
    );
  }
}
