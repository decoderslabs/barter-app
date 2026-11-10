import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../data/models/onboarding_config.dart';
import '../../../providers/app_providers.dart';
import '../../../theme/barter_colors.dart';
import '../../../widgets/barter_image_picker.dart';

class ProfileSetupScreen extends ConsumerStatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  ConsumerState<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

// TODO: Add image upload functionality
// TODO: Add username availability check
// TODO: Add location autocomplete using Google Places API

class _ProfileSetupScreenState extends ConsumerState<ProfileSetupScreen> {
  final TextEditingController _displayNameController = TextEditingController();
  final TextEditingController _handleController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  XFile? _pickedAvatar;
  bool _isLoading = false;

  // Validation errors
  String? _displayNameError;
  String? _handleError;
  String? _bioError;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = ref.read(authProvider).user;
      if (user != null) {
        if (_displayNameController.text.isEmpty && user.name.isNotEmpty) {
          _displayNameController.text = user.name;
        }
        if (_handleController.text.isEmpty && user.username.isNotEmpty) {
          _handleController.text = user.username.toLowerCase().replaceAll(RegExp(r'[^a-z0-9_.]'), '');
        }
        if (_bioController.text.isEmpty && user.bio != null && user.bio!.isNotEmpty) {
          _bioController.text = user.bio!;
        }
        if (_locationController.text.isEmpty && user.locationCity != null && user.locationCity!.isNotEmpty) {
          _locationController.text = user.locationCity!;
        }
        if (mounted) setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _handleController.dispose();
    _bioController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  // Validation methods
  String? _validateDisplayName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Display name is required';
    }
    if (value.trim().length < 2) {
      return 'Must be at least 2 characters';
    }
    if (value.trim().length > 50) {
      return 'Must be less than 50 characters';
    }
    // Only allow letters, spaces, hyphens, and apostrophes
    final validNameRegex = RegExp(r"^[a-zA-Z\s\-'\.]+$");
    if (!validNameRegex.hasMatch(value.trim())) {
      return 'Only letters, spaces, hyphens, and apostrophes allowed';
    }
    return null;
  }

  String? _validateHandle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Handle is required';
    }
    final handle = value.trim().toLowerCase();
    if (handle.length < 3) {
      return 'Must be at least 3 characters';
    }
    if (handle.length > 30) {
      return 'Must be less than 30 characters';
    }
    // Only allow lowercase letters, numbers, underscores, and periods
    final validHandleRegex = RegExp(r'^[a-z0-9_\.]+$');
    if (!validHandleRegex.hasMatch(handle)) {
      return 'Only lowercase letters, numbers, underscores, and periods allowed';
    }
    if (handle.startsWith('.') || handle.startsWith('_')) {
      return 'Cannot start with a period or underscore';
    }
    if (handle.endsWith('.') || handle.endsWith('_')) {
      return 'Cannot end with a period or underscore';
    }
    // Check for consecutive special characters
    if (handle.contains('..') || handle.contains('__') || handle.contains('._') || handle.contains('_.')) {
      return 'Cannot have consecutive special characters';
    }
    return null;
  }

  String? _validateBio(String? value) {
    if (value != null && value.length > 160) {
      return 'Bio must be 160 characters or less';
    }
    return null;
  }

  void _validateForm() {
    setState(() {
      _displayNameError = _validateDisplayName(_displayNameController.text);
      _handleError = _validateHandle(_handleController.text);
      _bioError = _validateBio(_bioController.text);
    });
  }

  bool get _isFormValid {
    _validateForm();
    return _displayNameError == null &&
           _handleError == null &&
           _bioError == null &&
           _displayNameController.text.trim().isNotEmpty &&
           _handleController.text.trim().isNotEmpty;
  }

  Future<void> _onSaveAndContinue() async {
    if (!_isFormValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please fix the errors before continuing'),
          backgroundColor: context.barter.error,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final session = ref.read(sessionProvider.notifier);

      // Parse location into city and country
      final locationParts = _locationController.text.split(',');
      final city = locationParts.isNotEmpty ? locationParts[0].trim() : null;
      final country = locationParts.length > 1 ? locationParts[1].trim() : null;

      final user = ref.read(authProvider).user;
      final defaultAvatar = (user?.profilePhotoUrl != null && user!.profilePhotoUrl!.isNotEmpty)
          ? user.profilePhotoUrl
          : 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200&h=200&fit=crop&crop=face';

      // Persist profile data to backend
      await session.persistProfileSetup(
        name: _displayNameController.text.trim(),
        bio: _bioController.text.isNotEmpty ? _bioController.text.trim() : 'Digital creator & storyteller',
        locationCity: city ?? 'Mumbai',
        locationCountry: country ?? 'IN',
        profilePhotoUrl: (user?.profilePhotoUrl != null && user!.profilePhotoUrl!.isNotEmpty)
            ? user.profilePhotoUrl
            : defaultAvatar,
      );

      await ref.read(authProvider.notifier).refreshUser();

      if (mounted) {
        context.push('/creator/onboarding/niche');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save profile: $e'),
            backgroundColor: context.barter.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bc = context.barter;
    final configAsync = ref.watch(onboardingConfigProvider);
    final creatorConfig = configAsync.valueOrNull?.creatorProfile;

    if (configAsync.isLoading) {
      return Scaffold(
        backgroundColor: bc.background,
        body: Center(
          child: CircularProgressIndicator(color: bc.primary),
        ),
      );
    }

    return Scaffold(
      backgroundColor: bc.background,
      appBar: AppBar(
        backgroundColor: bc.background,
        leading: IconButton(
          icon: Icon(Symbols.arrow_back, color: bc.primary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'BARTER',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: bc.primary,
                fontWeight: FontWeight.w900,
                letterSpacing: -1,
              ),
        ),
        actions: [
          TextButton(
            onPressed: () => context.push('/help'),
            child: Text(
              'Help',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: bc.primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ProgressBar(bc: bc),
              const SizedBox(height: 48),
              _Headline(bc: bc),
              const SizedBox(height: 48),
              _ProfilePhotoSection(
                bc: bc,
                avatarUrl: _pickedAvatar?.path ?? creatorConfig?.defaultAvatar ?? '',
                displayName: _displayNameController.text.isEmpty
                    ? (creatorConfig?.suggestedName ?? 'Creator')
                    : _displayNameController.text,
                onImagePicked: (file) => setState(() => _pickedAvatar = file),
              ),
              const SizedBox(height: 40),
              _DisplayNameInput(
                bc: bc,
                controller: _displayNameController,
                errorText: _displayNameError,
                onChanged: (_) => setState(() => _displayNameError = null),
                suggestedName: creatorConfig?.suggestedName,
              ),
              const SizedBox(height: 24),
              _HandleInput(
                bc: bc,
                controller: _handleController,
                errorText: _handleError,
                onChanged: (_) => setState(() => _handleError = null),
                suggestedHandle: creatorConfig?.suggestedHandle,
              ),
              const SizedBox(height: 24),
              _BioInput(
                bc: bc,
                controller: _bioController,
                errorText: _bioError,
                onChanged: (_) => setState(() => _bioError = null),
                suggestedBio: creatorConfig?.suggestedBio,
              ),
              const SizedBox(height: 24),
              _LocationInput(
                bc: bc,
                controller: _locationController,
                suggestedLocation: creatorConfig?.suggestedLocation,
              ),
              const SizedBox(height: 48),
              _ActionButtons(
                bc: bc,
                onSave: _onSaveAndContinue,
                onSkip: () => context.push('/creator/onboarding/niche'),
                isLoading: _isLoading,
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.bc});

  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Step 1 of 5',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: bc.primary,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                        fontSize: 11,
                      ),
                ),
                Text(
                  'Profile Setup',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
            Text(
              '20% Complete',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: bc.onSurfaceVariant.withValues(alpha: 0.6),
                  ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          height: 6,
          decoration: BoxDecoration(
            color: bc.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(999),
          ),
          child: FractionallySizedBox(
            widthFactor: 0.2,
            alignment: Alignment.centerLeft,
            child: Container(
              decoration: BoxDecoration(
                color: bc.primary,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Headline extends StatelessWidget {
  const _Headline({required this.bc});

  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  height: 1.1,
                ),
            children: [
              const TextSpan(text: 'Define your '),
              TextSpan(
                text: 'Creator',
                style: TextStyle(color: bc.primary, fontStyle: FontStyle.italic),
              ),
              const TextSpan(text: ' Identity.'),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'This is how brands will see you. Make it personal, make it professional, make it yours.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: bc.onSurfaceVariant,
                height: 1.6,
              ),
        ),
      ],
    );
  }
}

class _ProfilePhotoSection extends StatelessWidget {
  const _ProfilePhotoSection({
    required this.bc,
    required this.avatarUrl,
    required this.displayName,
    this.onImagePicked,
  });

  final BarterColors bc;
  final String avatarUrl;
  final String displayName;
  final ValueChanged<XFile>? onImagePicked;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        BarterImagePicker(
          initialUrl: avatarUrl.isNotEmpty ? avatarUrl : null,
          onImagePicked: onImagePicked,
          size: 128,
          isCircular: true,
          placeholderText: 'Upload Photo',
          showEditButton: true,
          editButtonSize: 40,
        ),
        const SizedBox(width: 32),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Profile Photo',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: bc.onSurfaceVariant,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Square JPG or PNG,\nmin. 400x400px',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: bc.onSurfaceVariant.withValues(alpha: 0.7),
                    ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Image picker coming soon')),
                  );
                },
                child: Text(
                  'Upload new',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: bc.primary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DisplayNameInput extends StatelessWidget {
  const _DisplayNameInput({
    required this.bc,
    required this.controller,
    this.errorText,
    this.onChanged,
    this.suggestedName,
  });

  final BarterColors bc;
  final TextEditingController controller;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final String? suggestedName;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Display Name',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: bc.onSurfaceVariant,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
                fontSize: 11,
              ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: bc.surfaceContainerLow,
            borderRadius: BorderRadius.circular(16),
            border: errorText != null
                ? Border.all(color: bc.error, width: 1)
                : null,
          ),
          child: TextField(
            controller: controller,
            onChanged: onChanged,
            decoration: InputDecoration(
              hintText: suggestedName ?? 'e.g. Elena Rossi',
              hintStyle: TextStyle(color: bc.onSurfaceVariant.withValues(alpha: 0.4)),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
              errorText: errorText,
              errorStyle: TextStyle(color: bc.error, fontSize: 12),
            ),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
      ],
    );
  }
}

class _HandleInput extends StatelessWidget {
  const _HandleInput({
    required this.bc,
    required this.controller,
    this.errorText,
    this.onChanged,
    this.suggestedHandle,
  });

  final BarterColors bc;
  final TextEditingController controller;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final String? suggestedHandle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Handle',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: bc.onSurfaceVariant,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
                fontSize: 11,
              ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: bc.surfaceContainerLow,
            borderRadius: BorderRadius.circular(16),
            border: errorText != null
                ? Border.all(color: bc.error, width: 1)
                : null,
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 8),
                child: Text(
                  '@',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: bc.primary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              Expanded(
                child: TextField(
                  controller: controller,
                  onChanged: onChanged,
                  decoration: InputDecoration(
                    hintText: suggestedHandle ?? '(ideally your instagram username)',
                    hintStyle: TextStyle(color: bc.onSurfaceVariant.withValues(alpha: 0.4)),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                    errorText: errorText,
                    errorStyle: TextStyle(color: bc.error, fontSize: 12),
                  ),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BioInput extends StatefulWidget {
  const _BioInput({
    required this.bc,
    required this.controller,
    this.errorText,
    this.onChanged,
    this.suggestedBio,
  });

  final BarterColors bc;
  final TextEditingController controller;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final String? suggestedBio;

  @override
  State<_BioInput> createState() => _BioInputState();
}

class _BioInputState extends State<_BioInput> {
  int _characterCount = 0;

  @override
  void initState() {
    super.initState();
    _characterCount = widget.controller.text.length;
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      _characterCount = widget.controller.text.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bc = widget.bc;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Professional Bio',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: bc.onSurfaceVariant,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                    fontSize: 11,
                  ),
            ),
            Text(
              '$_characterCount / 160',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: bc.onSurfaceVariant.withValues(alpha: 0.4),
                    fontSize: 10,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: bc.surfaceContainerLow,
            borderRadius: BorderRadius.circular(16),
            border: widget.errorText != null
                ? Border.all(color: bc.error, width: 1)
                : null,
          ),
          child: TextField(
            controller: widget.controller,
            maxLength: 160,
            maxLines: 4,
            onChanged: widget.onChanged,
            decoration: InputDecoration(
              hintText: widget.suggestedBio ?? 'Tell brands about your niche, style, and what you\'re looking for...',
              hintStyle: TextStyle(color: bc.onSurfaceVariant.withValues(alpha: 0.4)),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
              counterText: '',
              errorText: widget.errorText,
              errorStyle: TextStyle(color: bc.error, fontSize: 12),
            ),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  height: 1.6,
                ),
          ),
        ),
      ],
    );
  }
}

class _LocationInput extends StatelessWidget {
  const _LocationInput({
    required this.bc,
    required this.controller,
    this.suggestedLocation,
  });

  final BarterColors bc;
  final TextEditingController controller;
  final String? suggestedLocation;

  static const List<String> popularCities = [
    'Mumbai, IN',
    'Delhi NCR, IN',
    'Bengaluru, IN',
    'Hyderabad, IN',
    'Pune, IN',
    'Dubai, AE',
    'London, UK',
    'New York, US',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Base Location',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: bc.onSurfaceVariant,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
                fontSize: 11,
              ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: bc.surfaceContainerLow,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 12),
                child: Icon(
                  Symbols.location_on,
                  color: bc.primary.withValues(alpha: 0.6),
                  size: 24,
                ),
              ),
              Expanded(
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: suggestedLocation ?? 'City, Country',
                    hintStyle: TextStyle(color: bc.onSurfaceVariant.withValues(alpha: 0.4)),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        AnimatedBuilder(
          animation: controller,
          builder: (context, _) {
            final currentText = controller.text.trim().toLowerCase();
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: popularCities.map((city) {
                  final isSelected = currentText == city.toLowerCase() ||
                      currentText == city.split(',').first.trim().toLowerCase();
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(city),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) {
                          controller.text = city;
                        }
                      },
                      labelStyle: TextStyle(
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        color: isSelected ? bc.onPrimary : bc.onSurfaceVariant,
                      ),
                      backgroundColor: bc.surfaceContainerLow,
                      selectedColor: bc.primary,
                      side: BorderSide(
                        color: isSelected ? bc.primary : bc.outline.withValues(alpha: 0.15),
                      ),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      showCheckmark: false,
                    ),
                  );
                }).toList(),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons({
    required this.bc,
    required this.onSave,
    required this.onSkip,
    this.isLoading = false,
  });

  final BarterColors bc;
  final VoidCallback onSave;
  final VoidCallback onSkip;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: isLoading ? null : onSave,
          style: ElevatedButton.styleFrom(
            backgroundColor: bc.primary,
            foregroundColor: bc.onPrimary,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
            elevation: 10,
            shadowColor: bc.primary.withValues(alpha: 0.4),
          ),
          child: isLoading
              ? SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: bc.onPrimary,
                    strokeWidth: 2,
                  ),
                )
              : Text(
                  'Save and Continue',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: isLoading ? null : onSkip,
          child: Text(
            'I\'ll do this later',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: bc.onSurfaceVariant,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
      ],
    );
  }
}
