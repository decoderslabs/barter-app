import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../theme/barter_colors.dart';
import '../../../widgets/barter_logo.dart';
import '../../../widgets/barter_network_image.dart';

class ShippingAddressEntryScreen extends StatelessWidget {
  const ShippingAddressEntryScreen({super.key});

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
        title: const BarterLogo(height: 26),
        actions: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: bc.surfaceContainerHigh,
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: BarterNetworkImage(
                url: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDsDwzxJ5Nv1fWOHERfel-zmdUA1GdV9F8JcYapjyKT4MslVFDHdL_c6AniBMMtFoeX10f6cVejYsdjtnMLNVkDYExNQtos7mmKzOj9GMGOgR2jLtji3ARKaHJB46L9ZI8QbMEhAHfLM4BGY5dY7Q7VnYmq7prPSE33ROZfy89cJITKfkdQiuWoGoxFR87L4eyxKcnyMn4OBQT-4ec_laLEkFhyClmqrgFTk9eAMPBaSNat_jRGh5h5CAXEx_a_O-CUz8N75qDByPY',
                fit: BoxFit.cover,
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
            _HeaderSection(bc: bc),
            const SizedBox(height: 32),
            _FormSection(bc: bc),
            const SizedBox(height: 24),
            _SecurityNote(bc: bc),
            const SizedBox(height: 140),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              bc.background,
              bc.background.withValues(alpha: 0.9),
              Colors.transparent,
            ],
          ),
        ),
        child: Center(
          child: ElevatedButton.icon(
            onPressed: () => context.pop(),
            icon: Icon(Symbols.chevron_right, color: bc.onPrimary),
            label: Text(
              'Save Shipping Address',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: bc.primary,
              foregroundColor: bc.onPrimary,
              padding: const EdgeInsets.symmetric(vertical: 20),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
              elevation: 12,
              shadowColor: bc.primary.withValues(alpha: 0.2),
              minimumSize: const Size.fromWidth(382),
            ),
          ),
        ),
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  const _HeaderSection({required this.bc});

  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Step 2 of 3',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: bc.primary,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    fontSize: 10,
                  ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Container(
                height: 2,
                decoration: BoxDecoration(
                  color: bc.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: FractionallySizedBox(
                  widthFactor: 0.67,
                  alignment: Alignment.centerLeft,
                  child: Container(
                    decoration: BoxDecoration(
                      color: bc.primary,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        RichText(
          text: TextSpan(
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  height: 1.1,
                  letterSpacing: -2,
                ),
            children: [
              const TextSpan(text: 'SHIPPING\n'),
              TextSpan(
                text: 'DETAILS.',
                style: TextStyle(color: bc.primary, fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Proposal accepted. Provide your delivery address to receive the campaign kit.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: bc.onSurfaceVariant,
              ),
        ),
      ],
    );
  }
}

class _FormSection extends StatelessWidget {
  const _FormSection({required this.bc});

  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _TextField(
          label: 'Full Name',
          placeholder: 'Alex Rivers',
          bc: bc,
        ),
        const SizedBox(height: 24),
        _TextField(
          label: 'Address Line 1',
          placeholder: 'Street name and number',
          bc: bc,
        ),
        const SizedBox(height: 24),
        _TextField(
          label: 'Address Line 2 (Optional)',
          placeholder: 'Suite, apartment, or unit',
          bc: bc,
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: _TextField(
                label: 'City',
                placeholder: 'New York',
                bc: bc,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _TextField(
                label: 'State/Emirate',
                placeholder: 'NY',
                bc: bc,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: _TextField(
                label: 'Postal Code',
                placeholder: '10001',
                bc: bc,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _DropdownField(
                label: 'Country',
                bc: bc,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _TextField extends StatelessWidget {
  const _TextField({
    required this.label,
    required this.placeholder,
    required this.bc,
  });

  final String label;
  final String placeholder;
  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: bc.onSurfaceVariant,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
        ),
        const SizedBox(height: 6),
        TextField(
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: TextStyle(color: bc.onSurfaceVariant.withValues(alpha: 0.4)),
            filled: true,
            fillColor: bc.surfaceContainerLow,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
      ],
    );
  }
}

class _DropdownField extends StatelessWidget {
  const _DropdownField({
    required this.label,
    required this.bc,
  });

  final String label;
  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: bc.onSurfaceVariant,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            filled: true,
            fillColor: bc.surfaceContainerLow,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          items: const [
            DropdownMenuItem(value: 'us', child: Text('United States')),
            DropdownMenuItem(value: 'ae', child: Text('United Arab Emirates')),
            DropdownMenuItem(value: 'uk', child: Text('United Kingdom')),
            DropdownMenuItem(value: 'ca', child: Text('Canada')),
          ],
          onChanged: (value) {},
        ),
      ],
    );
  }
}

class _SecurityNote extends StatelessWidget {
  const _SecurityNote({required this.bc});

  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bc.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: bc.outlineVariant.withValues(alpha: 0.15)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Symbols.lock,
            color: bc.tertiary,
            fill: 1,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Secure & Encrypted',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Your data is processed through industry-standard AES-256 encryption. Only the brand and fulfillment team can access this address.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: bc.onSurfaceVariant,
                        height: 1.5,
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
