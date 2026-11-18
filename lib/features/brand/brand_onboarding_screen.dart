import '../../widgets/barter_logo.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../providers/app_providers.dart';
import '../../theme/barter_colors.dart';
import '../../widgets/barter_buttons.dart';
import '../../widgets/barter_image_picker.dart';
import '../../widgets/barter_network_image.dart';
import '../../widgets/barter_text_field.dart';

class BrandOnboardingScreen extends ConsumerWidget {
  const BrandOnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bc = context.barter;
    final cfgAsync = ref.watch(onboardingConfigProvider);
    return Scaffold(
      backgroundColor: bc.background,
      appBar: AppBar(
        backgroundColor: bc.background,
        title: const BarterLogo(height: 28),
        actions: [
          switch (cfgAsync) {
            AsyncData(:final value) => Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: bc.surfaceContainerHigh,
                    child: ClipOval(
                      child: BarterNetworkImage(url: value.brandAvatarUrl),
                    ),
                  ),
                ),
            _ => const SizedBox.shrink(),
          },
        ],
      ),
      body: cfgAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (_) => const _BrandIdentityForm(),
      ),
      bottomNavigationBar: const _BrandShellFooter(),
    );
  }
}

class _BrandIdentityForm extends StatelessWidget {
  const _BrandIdentityForm();

  @override
  Widget build(BuildContext context) {
    final bc = context.barter;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'STEP 1 OF 4',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: bc.primary,
                          letterSpacing: 3,
                          fontSize: 11,
                        ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Brand Identity',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ],
              ),
              Text(
                '25%',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: bc.onSurfaceVariant.withValues(alpha: 0.45),
                      fontWeight: FontWeight.w700,
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
          const SizedBox(height: 28),
          _LogoUploadSection(bc: bc),
          const SizedBox(height: 24),
          const BarterLabeledField(
            label: 'COMPANY NAME',
            hint: 'e.g. Atelier Noir',
          ),
          const SizedBox(height: 16),
          const BarterLabeledField(
            label: 'WEBSITE URL',
            hint: 'https://ateliernoir.com',
            keyboardType: TextInputType.url,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'INDUSTRY',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontSize: 11,
                            letterSpacing: 2,
                            color: bc.onSurfaceVariant.withValues(alpha: 0.7),
                          ),
                    ),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(),
                      items: const [
                        DropdownMenuItem(value: 'fashion', child: Text('Fashion & Apparel')),
                        DropdownMenuItem(value: 'beauty', child: Text('Beauty & Skincare')),
                        DropdownMenuItem(value: 'home', child: Text('Home Decor')),
                        DropdownMenuItem(value: 'tech', child: Text('Tech & Gadgets')),
                      ],
                      onChanged: (_) {},
                      hint: const Text('Select Category'),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: BarterLabeledField(
                  label: 'LOCATION',
                  hint: 'London, UK',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const BarterLabeledField(
            label: 'BRAND BIO',
            hint: "Tell us about your brand's mission and aesthetic...",
            maxLines: 3,
          ),
          const SizedBox(height: 24),
          Text(
            'SOCIAL LINKS',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: bc.primary,
                  letterSpacing: 3,
                  fontSize: 11,
                ),
          ),
          const SizedBox(height: 12),
          _SocialInput(icon: Symbols.language, hint: 'Instagram handle'),
          const SizedBox(height: 10),
          _SocialInput(icon: Symbols.link, hint: 'TikTok URL'),
          const SizedBox(height: 28),
          BarterPrimaryButton(
            label: 'Next Step',
            icon: Symbols.arrow_forward,
            onPressed: () => context.go('/brand/pipeline'),
          ),
          const SizedBox(height: 8),
          Center(
            child: TextButton(
              onPressed: () => context.pop(),
              child: Text(
                'SAVE AS DRAFT',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontSize: 10,
                      color: bc.onSurfaceVariant.withValues(alpha: 0.35),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LogoUploadSection extends StatefulWidget {
  const _LogoUploadSection({required this.bc});

  final BarterColors bc;

  @override
  State<_LogoUploadSection> createState() => _LogoUploadSectionState();
}

class _LogoUploadSectionState extends State<_LogoUploadSection> {
  XFile? _pickedLogo;

  @override
  Widget build(BuildContext context) {
    final bc = widget.bc;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BarterImagePicker(
          initialUrl: null,
          onImagePicked: (file) => setState(() => _pickedLogo = file),
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
              const SizedBox(height: 8),
              if (_pickedLogo != null)
                Text(
                  'Logo selected: ${_pickedLogo!.name}',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: bc.primary,
                        fontWeight: FontWeight.w500,
                      ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SocialInput extends StatelessWidget {
  const _SocialInput({required this.icon, required this.hint});

  final IconData icon;
  final String hint;

  @override
  Widget build(BuildContext context) {
    final bc = context.barter;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: bc.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: bc.onSurfaceVariant.withValues(alpha: 0.45)),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: hint,
                border: InputBorder.none,
                hintStyle: TextStyle(
                  color: bc.onSurfaceVariant.withValues(alpha: 0.35),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BrandShellFooter extends StatelessWidget {
  const _BrandShellFooter();

  @override
  Widget build(BuildContext context) {
    final bc = context.barter;
    Widget item(IconData icon, String label, bool active, VoidCallback? onTap) {
      final color = active ? bc.primary : bc.onSurface.withValues(alpha: 0.45);
      return InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color),
              const SizedBox(height: 4),
              Text(
                label.toUpperCase(),
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontSize: 10,
                      color: color,
                    ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: bc.background.withValues(alpha: 0.8),
        border: Border(
          top: BorderSide(color: bc.outlineVariant.withValues(alpha: 0.15)),
        ),
        boxShadow: [
          BoxShadow(
            color: bc.onBackground.withValues(alpha: 0.06),
            blurRadius: 40,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 10, 8, 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              item(Symbols.explore, 'Discover', false, null),
              item(Symbols.edit_note, 'Proposals', false, null),
              item(Symbols.handshake, 'Exchange', false, null),
              item(Symbols.chat_bubble, 'Inbox', false, null),
              item(Symbols.person, 'Profile', true, () {}),
            ],
          ),
        ),
      ),
    );
  }
}
