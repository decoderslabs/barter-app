import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../providers/api_providers.dart';
import '../../../theme/barter_colors.dart';
import '../../../widgets/barter_appbar.dart';
import '../../../widgets/barter_card.dart';
import 'create_offer_wizard_provider.dart';

class CreateOfferRightsScreen extends ConsumerStatefulWidget {
  const CreateOfferRightsScreen({super.key});

  @override
  ConsumerState<CreateOfferRightsScreen> createState() => _CreateOfferRightsScreenState();
}

class _CreateOfferRightsScreenState extends ConsumerState<CreateOfferRightsScreen> {
  String _contentRights = 'Tier 2: Organic Reshare';
  final TextEditingController _customTermsController = TextEditingController();
  bool _rawFilesRequired = true;
  bool _exclusivity = false;
  int _maxProposals = 25;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _customTermsController.dispose();
    super.dispose();
  }

  Future<void> _handlePublish() async {
    setState(() => _isSubmitting = true);
    try {
      ref.read(createOfferWizardProvider.notifier).updateRights(
        rightsTier: _contentRights,
        rawFilesRequired: _rawFilesRequired,
        exclusivity: _exclusivity,
        customTerms: _customTermsController.text,
      );
      final payload = ref.read(createOfferWizardProvider).toJson();
      await ref.read(offerRepositoryProvider).createOffer(payload);
      ref.read(createOfferWizardProvider.notifier).reset();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Offer created and published successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        context.go('/brand/campaigns');
      }
    } catch (e) {
      if (mounted) {
        final errText = e.toString().replaceAll('Exception: ', '');
        final isAuthErr = errText.contains('401') || errText.contains('not allowed') || errText.contains('unauthorized');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isAuthErr ? 'Please sign in with a brand account to publish offers.' : 'Failed to publish: $errText'),
            action: isAuthErr
                ? SnackBarAction(
                    label: 'Sign In',
                    textColor: Colors.amber,
                    onPressed: () => context.push('/sign-in'),
                  )
                : null,
            duration: const Duration(seconds: 5),
          ),
        );
        setState(() => _isSubmitting = false);
      }
    }
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
                      '03 / 03',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: bc.primary,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                            fontSize: 12,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Finalizing Rights & Reach',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                Text(
                  '100%',
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
                value: 1.0,
                minHeight: 6,
                backgroundColor: bc.surfaceContainerHigh,
                color: bc.primary,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Secure your content usage and define the operational boundaries of this exchange.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: bc.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 24),
            _ValueEngineTip(bc: bc),
            const SizedBox(height: 32),
            _ContentRightsSection(
              selectedRights: _contentRights,
              onRightsChanged: (val) => setState(() => _contentRights = val),
              customTermsController: _customTermsController,
              bc: bc,
            ),
            const SizedBox(height: 32),
            _DealSettingsSection(
              rawFilesRequired: _rawFilesRequired,
              onRawFilesChanged: (val) => setState(() => _rawFilesRequired = val),
              exclusivity: _exclusivity,
              onExclusivityChanged: (val) => setState(() => _exclusivity = val),
              maxProposals: _maxProposals,
              onMaxProposalsChanged: (val) => setState(() => _maxProposals = val),
              bc: bc,
            ),
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
                  onPressed: _isSubmitting ? null : _handlePublish,
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
                      if (_isSubmitting) ...[
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: bc.onPrimary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Publishing...',
                          style: TextStyle(letterSpacing: 1.5, fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ] else ...[
                        const Text(
                          'Preview & Publish',
                          style: TextStyle(letterSpacing: 1.5, fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 10),
                        Icon(Symbols.rocket_launch, color: bc.onPrimary),
                      ],
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

class _ValueEngineTip extends StatelessWidget {
  const _ValueEngineTip({required this.bc});

  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bc.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border(left: BorderSide(color: bc.primary, width: 4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Symbols.lightbulb, color: bc.primary, size: 24),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'RIGHTS VALUATION ENGINE',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: bc.primary,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                        fontSize: 11,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Perpetual digital usage increases creator perceived value. Tier 2 reshare provides optimal match velocity for most products.',
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

class _ContentRightsSection extends StatelessWidget {
  const _ContentRightsSection({
    required this.selectedRights,
    required this.onRightsChanged,
    required this.customTermsController,
    required this.bc,
  });

  final String selectedRights;
  final ValueChanged<String> onRightsChanged;
  final TextEditingController customTermsController;
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
              'Select Content Rights Tier',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _RightsOptionCard(
          label: 'Tier 1: Organic UGC Only',
          desc: 'Creator posts on their own channels only. No reposting or ad usage.',
          badge: 'BASIC',
          isSelected: selectedRights == 'Tier 1: Organic UGC Only',
          onTap: () => onRightsChanged('Tier 1: Organic UGC Only'),
          bc: bc,
        ),
        const SizedBox(height: 12),
        _RightsOptionCard(
          label: 'Tier 2: Organic Reshare',
          desc: 'Brand can repost on organic social channels with credit for 12 months.',
          badge: 'RECOMMENDED',
          isSelected: selectedRights == 'Tier 2: Organic Reshare',
          onTap: () => onRightsChanged('Tier 2: Organic Reshare'),
          bc: bc,
        ),
        const SizedBox(height: 12),
        _RightsOptionCard(
          label: 'Tier 3: Paid Usage License',
          desc: 'Full whitelisting, paid media ads, and website landing page usage for 90 days.',
          badge: 'PREMIUM',
          isSelected: selectedRights == 'Tier 3: Paid Usage License',
          onTap: () => onRightsChanged('Tier 3: Paid Usage License'),
          bc: bc,
        ),
        const SizedBox(height: 20),
        TextField(
          controller: customTermsController,
          maxLines: 3,
          decoration: InputDecoration(
            labelText: 'Additional Custom Terms (Optional)',
            hintText: 'e.g. Excludes YouTube shorts reposting, requires brand tag in caption...',
            filled: true,
            fillColor: bc.surfaceContainerLow,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }
}

class _RightsOptionCard extends StatelessWidget {
  const _RightsOptionCard({
    required this.label,
    required this.desc,
    this.badge,
    required this.isSelected,
    required this.onTap,
    required this.bc,
  });

  final String label;
  final String desc;
  final String? badge;
  final bool isSelected;
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
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isSelected ? bc.primary.withValues(alpha: 0.08) : bc.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? bc.primary : bc.outlineVariant.withValues(alpha: 0.2),
              width: 2,
            ),
          ),
          child: Row(
            children: [
              Icon(
                isSelected ? Symbols.check_circle : Symbols.radio_button_unchecked,
                color: isSelected ? bc.primary : bc.outlineVariant,
                fill: isSelected ? 1 : 0,
                size: 24,
              ),
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
                                color: isSelected ? bc.primary : bc.onSurface,
                              ),
                        ),
                        if (badge != null) ...[
                          const SizedBox(width: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: isSelected ? bc.primary : bc.surfaceContainerHigh,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              badge!,
                              style: TextStyle(
                                color: isSelected ? bc.onPrimary : bc.onSurfaceVariant,
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
      ),
    );
  }
}

class _DealSettingsSection extends StatelessWidget {
  const _DealSettingsSection({
    required this.rawFilesRequired,
    required this.onRawFilesChanged,
    required this.exclusivity,
    required this.onExclusivityChanged,
    required this.maxProposals,
    required this.onMaxProposalsChanged,
    required this.bc,
  });

  final bool rawFilesRequired;
  final ValueChanged<bool> onRawFilesChanged;
  final bool exclusivity;
  final ValueChanged<bool> onExclusivityChanged;
  final int maxProposals;
  final ValueChanged<int> onMaxProposalsChanged;
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
                  '2',
                  style: TextStyle(color: bc.onPrimary, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Campaign Operational Boundaries',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        BarterCard(
          borderRadius: 20,
          padding: const EdgeInsets.all(20),
          backgroundColor: bc.surfaceContainerLowest,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Raw Unedited Asset Files Required',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Creator must deliver original unedited footage alongside final cuts.',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: bc.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: rawFilesRequired,
                    onChanged: onRawFilesChanged,
                    activeColor: bc.primary,
                  ),
                ],
              ),
              const Divider(height: 28),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '30-Day Category Exclusivity',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Creator cannot promote direct competitor brands within 30 days.',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: bc.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: exclusivity,
                    onChanged: onExclusivityChanged,
                    activeColor: bc.primary,
                  ),
                ],
              ),
              const Divider(height: 28),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Proposal Acceptance Cap',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Automatically closes applications once capacity is reached.',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: bc.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: maxProposals > 5 ? () => onMaxProposalsChanged(maxProposals - 5) : null,
                        icon: const Icon(Icons.remove, size: 16),
                        style: IconButton.styleFrom(
                          backgroundColor: bc.surfaceContainerLow,
                          padding: const EdgeInsets.all(6),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          '$maxProposals',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                        onPressed: () => onMaxProposalsChanged(maxProposals + 5),
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
            ],
          ),
        ),
      ],
    );
  }
}
