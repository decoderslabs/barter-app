import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../theme/barter_colors.dart';
import '../../../widgets/barter_appbar.dart';
import '../../../widgets/barter_card.dart';

class CreateOfferDetailsScreen extends StatefulWidget {
  const CreateOfferDetailsScreen({super.key});

  @override
  State<CreateOfferDetailsScreen> createState() => _CreateOfferDetailsScreenState();
}

class _CreateOfferDetailsScreenState extends State<CreateOfferDetailsScreen> {
  final TextEditingController _headlineController = TextEditingController(text: 'TaskFlow Pro Annual');
  final TextEditingController _descriptionController = TextEditingController(text: 'Premium annual subscription to TaskFlow Pro. Includes all automation features and priority support for growth teams.');
  int _quantity = 10;
  String _selectedType = 'SaaS / Software';

  @override
  void dispose() {
    _headlineController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bc = context.barter;
    return Scaffold(
      backgroundColor: bc.surface,
      appBar: BarterAppBar(
        showBrandTitle: true,
        actions: [
          BarterCloseButton(),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  '01',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        color: bc.primary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(width: 8),
                Text(
                  '/ 04',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: bc.onSurfaceVariant,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                        fontSize: 12,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                children: [
                  const TextSpan(text: 'Create Your '),
                  TextSpan(text: 'Offer', style: TextStyle(color: bc.primary)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: 48,
              height: 4,
              decoration: BoxDecoration(
                color: bc.primary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Select Type',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: bc.onSurfaceVariant,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    fontSize: 12,
                  ),
            ),
            const SizedBox(height: 24),
            _OfferTypeGrid(bc: bc),
            const SizedBox(height: 32),
            _HeadlineField(bc: bc),
            const SizedBox(height: 32),
            _DescriptionField(bc: bc),
            const SizedBox(height: 32),
            _StatsGrid(bc: bc),
            const SizedBox(height: 32),
            _QuoteCard(bc: bc),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(24),
        margin: const EdgeInsets.only(bottom: 100),
        child: ElevatedButton(
          onPressed: () => context.push('/brand/campaigns/create/requirements'),
          style: ElevatedButton.styleFrom(
            backgroundColor: bc.primary,
            foregroundColor: bc.onPrimary,
            padding: const EdgeInsets.symmetric(vertical: 20),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
            elevation: 0,
            shadowColor: bc.primary.withValues(alpha: 0.2),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Next: Deliverables',
                style: TextStyle(
                  letterSpacing: 2,
                  fontSize: 14,
                ),
              ),
              Icon(Symbols.arrow_forward, color: bc.onPrimary),
            ],
          ),
        ),
      ),
    );
  }
}

class _OfferTypeGrid extends StatelessWidget {
  const _OfferTypeGrid({required this.bc});

  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SaaSCard(bc: bc),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _TypeCard(icon: Symbols.inventory_2, label: 'Products', desc: 'Physical goods', bc: bc)),
            const SizedBox(width: 16),
            Expanded(child: _TypeCard(icon: Symbols.handshake, label: 'Services', desc: 'Professional skills', bc: bc)),
          ],
        ),
      ],
    );
  }
}

class _SaaSCard extends StatelessWidget {
  const _SaaSCard({required this.bc});

  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      decoration: BoxDecoration(
        color: bc.primary,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: bc.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -8,
            right: -8,
            child: Icon(
              Symbols.terminal,
              color: bc.onPrimary.withValues(alpha: 0.4),
              size: 64,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Digital Solution',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: bc.onPrimary.withValues(alpha: 0.8),
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                            fontSize: 10,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'SaaS / Software',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: bc.onPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Icon(Symbols.check_circle, color: bc.onPrimary, fill: 1),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TypeCard extends StatelessWidget {
  const _TypeCard({
    required this.icon,
    required this.label,
    required this.desc,
    required this.bc,
  });

  final IconData icon;
  final String label;
  final String desc;
  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bc.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border(left: BorderSide(color: bc.surfaceContainerHigh, width: 4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: bc.tertiary, size: 24),
          const SizedBox(height: 12),
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
    );
  }
}

class _HeadlineField extends StatelessWidget {
  const _HeadlineField({required this.bc});

  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'The Headline',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: bc.onSurfaceVariant,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                fontSize: 10,
              ),
        ),
        const SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            hintText: 'Enter Title',
            hintStyle: TextStyle(
              color: bc.onSurfaceVariant.withValues(alpha: 0.4),
            ),
            border: UnderlineInputBorder(
              borderSide: BorderSide(color: bc.outlineVariant.withValues(alpha: 0.3), width: 2),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: bc.primary, width: 2),
            ),
            contentPadding: EdgeInsets.zero,
          ),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
}

class _DescriptionField extends StatelessWidget {
  const _DescriptionField({required this.bc});

  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: bc.onSurfaceVariant,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                fontSize: 10,
              ),
        ),
        const SizedBox(height: 8),
        TextField(
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'Enter description...',
            hintStyle: TextStyle(
              color: bc.onSurfaceVariant.withValues(alpha: 0.4),
            ),
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

class _StatsGrid extends StatelessWidget {
  const _StatsGrid({required this.bc});

  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: bc.outlineVariant.withValues(alpha: 0.1)),
          bottom: BorderSide(color: bc.outlineVariant.withValues(alpha: 0.1)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Est. Value',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: bc.onSurfaceVariant,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                        fontSize: 10,
                      ),
                ),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '4200',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            color: bc.primary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(width: 4),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Text(
                        'INR',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: bc.onSurfaceVariant,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Quantity',
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
                    Text(
                      '10',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(width: 8),
                    Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: bc.surfaceContainerHigh,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.remove, size: 14),
                        ),
                        const SizedBox(width: 4),
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: bc.surfaceContainerHigh,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.add, size: 14),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuoteCard extends StatelessWidget {
  const _QuoteCard({required this.bc});

  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return BarterCard(
      borderRadius: 16,
      padding: const EdgeInsets.all(24),
      backgroundColor: bc.primaryFixedDim.withValues(alpha: 0.2),
      child: Stack(
        children: [
          Positioned(
            top: -12,
            left: -8,
            child: Icon(
              Symbols.format_quote,
              color: bc.primary.withValues(alpha: 0.2),
              size: 48,
            ),
          ),
          Text(
            'TaskFlow Pro is designed for high-performing creators. You\'re offering significant value to the ecosystem.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontStyle: FontStyle.italic,
                  color: bc.onPrimaryFixedVariant,
                ),
          ),
        ],
      ),
    );
  }
}
