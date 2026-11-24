import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../providers/api_providers.dart';
import '../../../theme/barter_colors.dart';
import '../../../widgets/barter_logo.dart';
import '../../../widgets/barter_network_image.dart';

class ShippingAddressEntryScreen extends ConsumerStatefulWidget {
  const ShippingAddressEntryScreen({super.key, this.dealId});

  final String? dealId;

  @override
  ConsumerState<ShippingAddressEntryScreen> createState() => _ShippingAddressEntryScreenState();
}

class _ShippingAddressEntryScreenState extends ConsumerState<ShippingAddressEntryScreen> {
  final TextEditingController _fullNameController = TextEditingController(text: 'Alex Rivers');
  final TextEditingController _address1Controller = TextEditingController(text: '742 Evergreen Terrace');
  final TextEditingController _address2Controller = TextEditingController(text: 'Apt 4B');
  final TextEditingController _cityController = TextEditingController(text: 'New York');
  final TextEditingController _stateController = TextEditingController(text: 'NY');
  final TextEditingController _postalCodeController = TextEditingController(text: '10001');
  String _country = 'United States';
  bool _isSubmitting = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _address1Controller.dispose();
    _address2Controller.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _postalCodeController.dispose();
    super.dispose();
  }

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
            _FormSection(
              bc: bc,
              fullNameController: _fullNameController,
              address1Controller: _address1Controller,
              address2Controller: _address2Controller,
              cityController: _cityController,
              stateController: _stateController,
              postalCodeController: _postalCodeController,
              selectedCountry: _country,
              onCountryChanged: (val) => setState(() => _country = val),
            ),
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
            onPressed: _isSubmitting ? null : () async {
              setState(() => _isSubmitting = true);
              try {
                if (widget.dealId != null && widget.dealId!.isNotEmpty) {
                  await ref.read(dealRepositoryProvider).saveShippingAddress(
                    dealId: widget.dealId!,
                    fullName: _fullNameController.text.trim(),
                    addressLine1: _address1Controller.text.trim(),
                    addressLine2: _address2Controller.text.trim(),
                    city: _cityController.text.trim(),
                    state: _stateController.text.trim(),
                    postalCode: _postalCodeController.text.trim(),
                    country: _country,
                  );
                }
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Shipping address saved!')),
                  );
                  context.pop();
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to save shipping address: $e')),
                  );
                  setState(() => _isSubmitting = false);
                }
              }
            },
            icon: _isSubmitting
                ? SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2, color: bc.onPrimary),
                  )
                : Icon(Symbols.chevron_right, color: bc.onPrimary),
            label: Text(
              _isSubmitting ? 'Saving Address...' : 'Save Shipping Address',
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
  const _FormSection({
    required this.bc,
    required this.fullNameController,
    required this.address1Controller,
    required this.address2Controller,
    required this.cityController,
    required this.stateController,
    required this.postalCodeController,
    required this.selectedCountry,
    required this.onCountryChanged,
  });

  final BarterColors bc;
  final TextEditingController fullNameController;
  final TextEditingController address1Controller;
  final TextEditingController address2Controller;
  final TextEditingController cityController;
  final TextEditingController stateController;
  final TextEditingController postalCodeController;
  final String selectedCountry;
  final ValueChanged<String> onCountryChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _TextField(
          label: 'Full Name',
          placeholder: 'Alex Rivers',
          controller: fullNameController,
          bc: bc,
        ),
        const SizedBox(height: 24),
        _TextField(
          label: 'Address Line 1',
          placeholder: 'Street name and number',
          controller: address1Controller,
          bc: bc,
        ),
        const SizedBox(height: 24),
        _TextField(
          label: 'Address Line 2 (Optional)',
          placeholder: 'Suite, apartment, or unit',
          controller: address2Controller,
          bc: bc,
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: _TextField(
                label: 'City',
                placeholder: 'New York',
                controller: cityController,
                bc: bc,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _TextField(
                label: 'State/Emirate',
                placeholder: 'NY',
                controller: stateController,
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
                controller: postalCodeController,
                bc: bc,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _DropdownField(
                label: 'Country',
                selectedCountry: selectedCountry,
                onCountryChanged: onCountryChanged,
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
    this.controller,
  });

  final String label;
  final String placeholder;
  final BarterColors bc;
  final TextEditingController? controller;

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
          controller: controller,
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
    required this.selectedCountry,
    required this.onCountryChanged,
  });

  final String label;
  final BarterColors bc;
  final String selectedCountry;
  final ValueChanged<String> onCountryChanged;

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
          value: selectedCountry,
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
            DropdownMenuItem(value: 'United States', child: Text('United States')),
            DropdownMenuItem(value: 'United Arab Emirates', child: Text('United Arab Emirates')),
            DropdownMenuItem(value: 'United Kingdom', child: Text('United Kingdom')),
            DropdownMenuItem(value: 'Canada', child: Text('Canada')),
            DropdownMenuItem(value: 'India', child: Text('India')),
          ],
          onChanged: (value) {
            if (value != null) onCountryChanged(value);
          },
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
