import '../../../widgets/barter_logo.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../providers/app_providers.dart';
import '../../../theme/barter_colors.dart';
import '../../../widgets/barter_image_picker.dart';

class BrandIdentityScreen extends StatefulWidget {
  const BrandIdentityScreen({super.key});

  @override
  State<BrandIdentityScreen> createState() => _BrandIdentityScreenState();
}

class _BrandIdentityScreenState extends State<BrandIdentityScreen> {
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _instagramController = TextEditingController();
  final TextEditingController _tiktokController = TextEditingController();
  String _selectedIndustry = 'Select Category';
  XFile? _pickedLogo;

  @override
  void dispose() {
    _companyController.dispose();
    _websiteController.dispose();
    _locationController.dispose();
    _bioController.dispose();
    _instagramController.dispose();
    _tiktokController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bc = context.barter;
    return Scaffold(
      backgroundColor: bc.background,
      appBar: AppBar(
        backgroundColor: bc.background,
        leading: const SizedBox.shrink(),
        title: const BarterLogo(height: 28),
        actions: [
          Consumer(builder: (context, ref, child) {
            final cfgAsync = ref.watch(onboardingConfigProvider);
            return switch (cfgAsync) {
              AsyncData(:final value) => Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: bc.surfaceContainerHigh,
                      child: ClipOval(
                        child: value.brandAvatarUrl.isNotEmpty
                            ? Image.network(
                                value.brandAvatarUrl,
                                fit: BoxFit.cover,
                                width: 40,
                                height: 40,
                                errorBuilder: (_, __, ___) => Icon(
                                  Symbols.business,
                                  color: bc.onSurfaceVariant,
                                ),
                              )
                            : Icon(Symbols.business, color: bc.onSurfaceVariant),
                      ),
                    ),
                  ),
              _ => const SizedBox.shrink(),
            };
          }),
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
                      'Step 1 of 4',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: bc.primary,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                            fontSize: 10,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Brand Identity',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                Text(
                  '25%',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: bc.onSurfaceVariant.withValues(alpha: 0.4),
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: 0.25,
                minHeight: 6,
                backgroundColor: bc.surfaceContainer,
                color: bc.primary,
              ),
            ),
            const SizedBox(height: 32),
            _LogoUploadSection(
              bc: bc,
              onImagePicked: (file) => setState(() => _pickedLogo = file),
            ),
            const SizedBox(height: 24),
            _TextField(
              label: 'Company Name',
              controller: _companyController,
              placeholder: 'e.g. Atelier Noir',
              bc: bc,
            ),
            const SizedBox(height: 16),
            _TextField(
              label: 'Website URL',
              controller: _websiteController,
              placeholder: 'https://ateliernoir.com',
              bc: bc,
              keyboardType: TextInputType.url,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _DropdownField(
                    label: 'Industry',
                    value: _selectedIndustry,
                    items: const [
                      'Select Category',
                      'Fashion & Apparel',
                      'Beauty & Skincare',
                      'Home Decor',
                      'Tech & Gadgets',
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedIndustry = value!;
                      });
                    },
                    bc: bc,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _TextField(
                    label: 'Location',
                    controller: _locationController,
                    placeholder: 'London, UK',
                    bc: bc,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _TextAreaField(
              label: 'Brand Bio',
              controller: _bioController,
              placeholder: 'Tell us about your brand\'s mission and aesthetic...',
              bc: bc,
            ),
            const SizedBox(height: 32),
            Text(
              'Social Links',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: bc.primary,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    fontSize: 11,
                  ),
            ),
            const SizedBox(height: 12),
            _SocialField(
              icon: Symbols.language,
              placeholder: 'Instagram handle',
              controller: _instagramController,
              bc: bc,
            ),
            const SizedBox(height: 12),
            _SocialField(
              icon: Symbols.link,
              placeholder: 'TikTok URL',
              controller: _tiktokController,
              bc: bc,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => context.push('/brand/onboarding/offer-types'),
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
                    const Text('Next Step'),
                    const SizedBox(width: 8),
                    Icon(Symbols.arrow_forward, color: bc.onPrimary),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: TextButton(
                onPressed: () => context.pop(),
                child: Text(
                  'Save as Draft',
                  style: TextStyle(
                    color: bc.onSurfaceVariant.withValues(alpha: 0.4),
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                    fontSize: 10,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}

class _LogoUploadSection extends StatefulWidget {
  const _LogoUploadSection({required this.bc, this.onImagePicked});

  final BarterColors bc;
  final ValueChanged<XFile?>? onImagePicked;

  @override
  State<_LogoUploadSection> createState() => _LogoUploadSectionState();
}

class _LogoUploadSectionState extends State<_LogoUploadSection> {
  XFile? _pickedLogo;

  void _onImagePicked(XFile? file) {
    setState(() => _pickedLogo = file);
    widget.onImagePicked?.call(file);
  }

  @override
  Widget build(BuildContext context) {
    final bc = widget.bc;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BarterImagePicker(
          initialUrl: null,
          onImagePicked: _onImagePicked,
          size: 112,
          isCircular: false,
          placeholderText: 'Upload Logo',
          showEditButton: false,
        ),
        const SizedBox(width: 24),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text(
                'Brand Logo',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: bc.onSurfaceVariant,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 6),
              Text(
                'Recommended: Square PNG or SVG, max 2MB.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: bc.onSurfaceVariant.withValues(alpha: 0.6),
                    ),
              ),
              if (_pickedLogo != null) ...[
                const SizedBox(height: 8),
                Text(
                  'Logo selected: ${_pickedLogo!.name}',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: bc.primary,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _TextField extends StatelessWidget {
  const _TextField({
    required this.label,
    required this.controller,
    required this.placeholder,
    required this.bc,
    this.keyboardType,
  });

  final String label;
  final TextEditingController controller;
  final String placeholder;
  final BarterColors bc;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: bc.onSurfaceVariant.withValues(alpha: 0.7),
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
                fontSize: 11,
              ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: TextStyle(
              color: bc.onSurfaceVariant.withValues(alpha: 0.3),
            ),
            filled: true,
            fillColor: bc.surfaceContainerLow,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }
}

class _TextAreaField extends StatelessWidget {
  const _TextAreaField({
    required this.label,
    required this.controller,
    required this.placeholder,
    required this.bc,
  });

  final String label;
  final TextEditingController controller;
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
                color: bc.onSurfaceVariant.withValues(alpha: 0.7),
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
                fontSize: 11,
              ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: TextStyle(
              color: bc.onSurfaceVariant.withValues(alpha: 0.3),
            ),
            filled: true,
            fillColor: bc.surfaceContainerLow,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }
}

class _DropdownField extends StatelessWidget {
  const _DropdownField({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.bc,
  });

  final String label;
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: bc.onSurfaceVariant.withValues(alpha: 0.7),
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
                fontSize: 11,
              ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: bc.surfaceContainerLow,
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: onChanged,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              icon: Icon(Symbols.expand_more, color: bc.onSurfaceVariant.withValues(alpha: 0.5)),
              style: Theme.of(context).textTheme.bodyMedium,
              dropdownColor: bc.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }
}

class _SocialField extends StatelessWidget {
  const _SocialField({
    required this.icon,
    required this.placeholder,
    required this.controller,
    required this.bc,
  });

  final IconData icon;
  final String placeholder;
  final TextEditingController controller;
  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: bc.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: bc.onSurfaceVariant.withValues(alpha: 0.4), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: placeholder,
                hintStyle: TextStyle(
                  color: bc.onSurfaceVariant.withValues(alpha: 0.3),
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
