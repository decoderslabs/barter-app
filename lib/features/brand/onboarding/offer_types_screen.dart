import '../../../widgets/barter_logo.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../theme/barter_colors.dart';
import '../../../widgets/barter_network_image.dart';

class OfferTypesScreen extends StatefulWidget {
  const OfferTypesScreen({super.key});

  @override
  State<OfferTypesScreen> createState() => _OfferTypesScreenState();
}

class _OfferTypesScreenState extends State<OfferTypesScreen> {
  final Set<String> _selectedTypes = {'Physical Product'};

  final List<OfferType> _offerTypes = [
    OfferType(
      icon: Symbols.terminal,
      label: 'SaaS/Software Access',
      description: 'Free licenses, premium seats, or credits.',
    ),
    OfferType(
      icon: Symbols.inventory_2,
      label: 'Physical Product',
      description: 'Shippable goods, samples, or new releases.',
      iconFilled: true,
    ),
    OfferType(
      icon: Symbols.confirmation_number,
      label: 'Event Pass',
      description: 'Concert tickets, VIP entries, or conference access.',
    ),
    OfferType(
      icon: Symbols.travel_explore,
      label: 'Experience',
      description: 'Hotel stays, restaurant visits, or travel perks.',
    ),
    OfferType(
      icon: Symbols.apparel,
      label: 'Merchandise',
      description: 'Branded apparel, limited edition drops.',
    ),
    OfferType(
      icon: Symbols.school,
      label: 'Course/Education',
      description: 'Professional training, online cohorts, certificates.',
    ),
    OfferType(
      icon: Symbols.card_giftcard,
      label: 'Gift Card/Voucher',
      description: 'Digital credits or physical store vouchers.',
      fullWidth: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final bc = context.barter;
    return Scaffold(
      backgroundColor: bc.background,
      appBar: AppBar(
        backgroundColor: bc.background,
        leading: IconButton(
          icon: Icon(Symbols.arrow_back, color: bc.onSurface),
          onPressed: () => context.pop(),
        ),
        title: const BarterLogo(height: 28),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Text(
              'Step 04 / 05',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: bc.onSurfaceVariant,
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
            Text(
              'What will you offer?',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Select all the assets your brand typically barters with creators.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: bc.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: 0.75,
                minHeight: 6,
                backgroundColor: bc.surfaceContainerHigh,
                color: bc.primary,
              ),
            ),
            const SizedBox(height: 32),
            ..._offerTypes.map((type) {
              final isSelected = _selectedTypes.contains(type.label);
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _OfferTypeCard(
                  type: type,
                  isSelected: isSelected,
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        _selectedTypes.remove(type.label);
                      } else {
                        _selectedTypes.add(type.label);
                      }
                    });
                  },
                  bc: bc,
                ),
              );
            }),
            const SizedBox(height: 32),
            _ProTipCard(bc: bc),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: bc.surfaceContainerLowest.withValues(alpha: 0.8),
          border: Border(top: BorderSide(color: bc.surfaceContainerHigh)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () => context.go('/brand/dashboard'),
              child: Text(
                'Skip for now',
                style: TextStyle(
                  color: bc.onSurfaceVariant,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => context.push('/brand/onboarding/content-rights'),
              style: ElevatedButton.styleFrom(
                backgroundColor: bc.primary,
                foregroundColor: bc.onPrimary,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                elevation: 0,
              ),
              child: Row(
                children: [
                  const Text('Next Step'),
                  const SizedBox(width: 8),
                  Icon(Symbols.chevron_right, color: bc.onPrimary),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OfferType {
  final IconData icon;
  final String label;
  final String description;
  final bool iconFilled;
  final bool fullWidth;

  OfferType({
    required this.icon,
    required this.label,
    required this.description,
    this.iconFilled = false,
    this.fullWidth = false,
  });
}

class _OfferTypeCard extends StatelessWidget {
  const _OfferTypeCard({
    required this.type,
    required this.isSelected,
    required this.onTap,
    required this.bc,
  });

  final OfferType type;
  final bool isSelected;
  final VoidCallback onTap;
  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isSelected ? bc.surfaceContainerLow : bc.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(16),
          border: isSelected
              ? Border.all(color: bc.primary, width: 2)
              : Border.all(color: bc.outlineVariant.withValues(alpha: 0.2)),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: bc.onBackground.withValues(alpha: 0.06),
                    blurRadius: 40,
                    offset: const Offset(0, 10),
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
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isSelected ? bc.primary : bc.surfaceContainerLow,
                borderRadius: BorderRadius.circular(12),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: bc.primary.withValues(alpha: 0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ]
                    : null,
              ),
              child: Icon(
                type.icon,
                color: isSelected ? bc.onPrimary : bc.primary,
                fill: isSelected ? 1.0 : (type.iconFilled ? 1.0 : 0.0),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    type.label,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    type.description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: bc.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? bc.primary : bc.outlineVariant.withValues(alpha: 0.3),
                border: isSelected ? null : Border.all(color: bc.outlineVariant, width: 2),
              ),
              child: isSelected
                  ? Icon(Symbols.check, color: bc.onPrimary, size: 14, fill: 1)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _ProTipCard extends StatelessWidget {
  const _ProTipCard({required this.bc});

  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: bc.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: bc.onBackground.withValues(alpha: 0.1),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: BarterNetworkImage(
                    url: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBP4EtwUfiKFE1Hx1lGo0P_iTQTSxGxr3hxA3D8SNrbsYT6EegHeHM-XwJ2gVjmXtEQg9q0XITf1CmbH_qXCFB3xIOxfEcuuUq5Z0L9oEnhFYYIpRz8M_KI3slqPSo0RyIsZHI5ERvNHA2GvKp9IRFq99isyN5dT5DXmzeUQPWEyjDuhBrNnZvuLZC1tKTYDNqyCL7czxPHKh2L-rdncB48u96yDxQQe8hHc8Bfjm2-FEvDS7HrNooiUvVaXhH7RGwkOS8D2o6wOdo',
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: bc.tertiaryContainer,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: bc.onBackground.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(Symbols.auto_awesome, color: bc.onTertiaryContainer, size: 16, fill: 1),
              ),
            ],
          ),
          const SizedBox(width: 24),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: bc.onSurfaceVariant,
                    ),
                children: [
                  TextSpan(
                    text: 'Pro Tip: ',
                    style: TextStyle(
                      color: bc.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const TextSpan(text: 'Offering a mix of '),
                  TextSpan(
                    text: 'Digital Access',
                    style: TextStyle(
                      color: bc.primary,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const TextSpan(text: ' and '),
                  TextSpan(
                    text: 'Experiences',
                    style: TextStyle(
                      color: bc.primary,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const TextSpan(text: ' usually yields the highest quality creator applications.'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
