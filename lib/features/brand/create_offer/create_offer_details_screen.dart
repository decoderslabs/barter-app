import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../theme/barter_colors.dart';
import '../../../widgets/barter_appbar.dart';
import '../../../widgets/barter_card.dart';
import 'create_offer_wizard_provider.dart';

class CreateOfferDetailsScreen extends ConsumerStatefulWidget {
  const CreateOfferDetailsScreen({super.key});

  @override
  ConsumerState<CreateOfferDetailsScreen> createState() => _CreateOfferDetailsScreenState();
}

class _CreateOfferDetailsScreenState extends ConsumerState<CreateOfferDetailsScreen> {
  late final TextEditingController _headlineController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _valueController;
  late int _quantity;
  late String _selectedType;

  @override
  void initState() {
    super.initState();
    final wizard = ref.read(createOfferWizardProvider);
    _headlineController = TextEditingController(text: wizard.title);
    _descriptionController = TextEditingController(text: wizard.description);
    _valueController = TextEditingController(text: wizard.estimatedValue.toInt().toString());
    _quantity = wizard.quantity;
    _selectedType = wizard.type;
  }

  @override
  void dispose() {
    _headlineController.dispose();
    _descriptionController.dispose();
    _valueController.dispose();
    super.dispose();
  }

  void _onNext() {
    ref.read(createOfferWizardProvider.notifier).updateDetails(
      title: _headlineController.text.trim().isEmpty ? 'TaskFlow Pro Annual' : _headlineController.text.trim(),
      description: _descriptionController.text.trim().isEmpty ? 'Premium subscription' : _descriptionController.text.trim(),
      type: _selectedType,
      quantity: _quantity,
      estimatedValue: double.tryParse(_valueController.text.trim()) ?? 4200,
      currency: 'INR',
    );
    context.push('/brand/campaigns/create/requirements');
  }

  @override
  Widget build(BuildContext context) {
    final bc = context.barter;
    return Scaffold(
      backgroundColor: bc.surface,
      appBar: BarterAppBar(
        showBrandTitle: true,
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
                  '/ 03',
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
              'SELECT TYPE',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: bc.onSurfaceVariant,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    fontSize: 12,
                  ),
            ),
            const SizedBox(height: 16),
            _OfferTypeGrid(
              selectedType: _selectedType,
              onTypeSelected: (type) => setState(() => _selectedType = type),
              bc: bc,
            ),
            const SizedBox(height: 32),
            _HeadlineField(controller: _headlineController, bc: bc),
            const SizedBox(height: 32),
            _DescriptionField(controller: _descriptionController, bc: bc),
            const SizedBox(height: 32),
            _StatsGrid(
              valueController: _valueController,
              quantity: _quantity,
              onQuantityChanged: (q) => setState(() => _quantity = q),
              bc: bc,
            ),
            const SizedBox(height: 32),
            _QuoteCard(bc: bc),
            const SizedBox(height: 32),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: bc.surface,
          border: Border(top: BorderSide(color: bc.outlineVariant.withValues(alpha: 0.15))),
        ),
        child: SafeArea(
          child: ElevatedButton(
            onPressed: _onNext,
            style: ElevatedButton.styleFrom(
              backgroundColor: bc.primary,
              foregroundColor: bc.onPrimary,
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
              elevation: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Next: Deliverables',
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
      ),
    );
  }
}

class _OfferTypeGrid extends StatelessWidget {
  const _OfferTypeGrid({
    required this.selectedType,
    required this.onTypeSelected,
    required this.bc,
  });

  final String selectedType;
  final ValueChanged<String> onTypeSelected;
  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _TypeOptionCard(
          icon: Symbols.terminal,
          category: 'Digital Solution',
          label: 'SaaS / Software',
          desc: 'Cloud software, subscriptions, or digital access',
          isSelected: selectedType == 'SaaS / Software',
          onTap: () => onTypeSelected('SaaS / Software'),
          bc: bc,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _TypeOptionCard(
                icon: Symbols.inventory_2,
                category: 'Physical Goods',
                label: 'Products',
                desc: 'Physical goods shipped to creators',
                isSelected: selectedType == 'Products',
                onTap: () => onTypeSelected('Products'),
                bc: bc,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _TypeOptionCard(
                icon: Symbols.handshake,
                category: 'Professional',
                label: 'Services',
                desc: 'Consulting, services & bespoke value',
                isSelected: selectedType == 'Services',
                onTap: () => onTypeSelected('Services'),
                bc: bc,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _TypeOptionCard extends StatelessWidget {
  const _TypeOptionCard({
    required this.icon,
    required this.category,
    required this.label,
    required this.desc,
    required this.isSelected,
    required this.onTap,
    required this.bc,
  });

  final IconData icon;
  final String category;
  final String label;
  final String desc;
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
            color: isSelected ? bc.primary : bc.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? bc.primary : bc.outlineVariant.withValues(alpha: 0.2),
              width: 2,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: bc.primary.withValues(alpha: 0.25),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
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
                  Icon(
                    icon,
                    size: 28,
                    color: isSelected ? bc.onPrimary : bc.tertiary,
                  ),
                  if (isSelected)
                    Icon(Symbols.check_circle, color: bc.onPrimary, size: 22, fill: 1)
                  else
                    Icon(Symbols.radio_button_unchecked, color: bc.onSurfaceVariant.withValues(alpha: 0.4), size: 22),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                category.toUpperCase(),
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: isSelected ? bc.onPrimary.withValues(alpha: 0.8) : bc.onSurfaceVariant,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                      fontSize: 10,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: isSelected ? bc.onPrimary : bc.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                desc,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isSelected ? bc.onPrimary.withValues(alpha: 0.8) : bc.onSurfaceVariant,
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

class _HeadlineField extends StatelessWidget {
  const _HeadlineField({
    required this.controller,
    required this.bc,
  });

  final TextEditingController controller;
  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'THE HEADLINE',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: bc.onSurfaceVariant,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                fontSize: 10,
              ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'e.g. TaskFlow Pro Annual Subscription',
            hintStyle: TextStyle(
              color: bc.onSurfaceVariant.withValues(alpha: 0.4),
            ),
            border: UnderlineInputBorder(
              borderSide: BorderSide(color: bc.outlineVariant.withValues(alpha: 0.3), width: 2),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: bc.primary, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 8),
          ),
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
}

class _DescriptionField extends StatelessWidget {
  const _DescriptionField({
    required this.controller,
    required this.bc,
  });

  final TextEditingController controller;
  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'DESCRIPTION',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: bc.onSurfaceVariant,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                fontSize: 10,
              ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: 'Describe what you are offering and what kind of collaboration you seek...',
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
  const _StatsGrid({
    required this.valueController,
    required this.quantity,
    required this.onQuantityChanged,
    required this.bc,
  });

  final TextEditingController valueController;
  final int quantity;
  final ValueChanged<int> onQuantityChanged;
  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: bc.outlineVariant.withValues(alpha: 0.15)),
          bottom: BorderSide(color: bc.outlineVariant.withValues(alpha: 0.15)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'EST. VALUE',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: bc.onSurfaceVariant,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                        fontSize: 10,
                      ),
                ),
                const SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 120,
                      child: TextField(
                        controller: valueController,
                        keyboardType: TextInputType.number,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: bc.primary,
                              fontWeight: FontWeight.bold,
                            ),
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(vertical: 4),
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(color: bc.primary),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'INR',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: bc.onSurfaceVariant,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
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
                  'QUANTITY',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: bc.onSurfaceVariant,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                        fontSize: 10,
                      ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      '$quantity',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(width: 16),
                    Row(
                      children: [
                        IconButton(
                          onPressed: quantity > 1 ? () => onQuantityChanged(quantity - 1) : null,
                          icon: const Icon(Icons.remove),
                          iconSize: 18,
                          style: IconButton.styleFrom(
                            backgroundColor: bc.surfaceContainerHigh,
                            padding: const EdgeInsets.all(8),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: () => onQuantityChanged(quantity + 1),
                          icon: const Icon(Icons.add),
                          iconSize: 18,
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
            'High-performing creators prioritize value and utility over raw cash. Transparent deliverables create durable brand advocates.',
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
