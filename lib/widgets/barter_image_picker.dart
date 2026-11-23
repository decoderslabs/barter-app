import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../theme/barter_colors.dart';

// Export types for external use
typedef OnImagePickedCallback = void Function(XFile? file);

/// A reusable image picker widget for avatar/logo uploads.
/// Works on web and mobile.
class BarterImagePicker extends StatefulWidget {
  const BarterImagePicker({
    super.key,
    this.initialUrl,
    this.onImagePicked,
    this.size = 128,
    this.isCircular = true,
    this.placeholderText = 'Upload Photo',
    this.subtitleText,
    this.showEditButton = true,
    this.editButtonSize = 40,
    this.backgroundColor,
    this.borderColor,
    this.enableCropping = true,
    this.cropAspectRatio,
  });

  /// Initial image URL to display
  final String? initialUrl;

  /// Callback when an image is picked. Returns the File (mobile) or XFile (web)
  final ValueChanged<XFile?>? onImagePicked;

  /// Size of the image container (width/height)
  final double size;

  /// Whether the shape should be circular (true) or rounded rect (false)
  final bool isCircular;

  /// Text shown in placeholder state
  final String placeholderText;

  /// Optional subtitle text below the image
  final String? subtitleText;

  /// Whether to show the edit button overlay
  final bool showEditButton;

  /// Size of the edit button
  final double editButtonSize;

  /// Custom background color (defaults to theme surfaceContainerLow)
  final Color? backgroundColor;

  /// Custom border color (defaults to theme outlineVariant)
  final Color? borderColor;

  /// Whether to enable image cropping after picking
  final bool enableCropping;

  /// Crop aspect ratio (null for freeform, or use CropAspectRatio)
  final CropAspectRatio? cropAspectRatio;

  @override
  State<BarterImagePicker> createState() => _BarterImagePickerState();
}

class _BarterImagePickerState extends State<BarterImagePicker> {
  XFile? _pickedFile;
  bool _isLoading = false;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    setState(() => _isLoading = true);
    try {
      final XFile? picked = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 90,
      );

      if (picked == null) {
        setState(() => _isLoading = false);
        return;
      }

      // Skip cropping on web (limited support) or if disabled
      if (kIsWeb || !widget.enableCropping) {
        setState(() => _pickedFile = picked);
        widget.onImagePicked?.call(picked);
        setState(() => _isLoading = false);
        return;
      }

      // Crop the image
      final CroppedFile? cropped = await _cropImage(picked.path);

      if (cropped != null) {
        final croppedXFile = XFile(cropped.path);
        setState(() => _pickedFile = croppedXFile);
        widget.onImagePicked?.call(croppedXFile);
      } else {
        // User cancelled crop, use original
        setState(() => _pickedFile = picked);
        widget.onImagePicked?.call(picked);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to pick image: $e'),
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

  Future<CroppedFile?> _cropImage(String sourcePath) async {
    final bc = context.barter;

    return await ImageCropper().cropImage(
      sourcePath: sourcePath,
      maxWidth: 800,
      maxHeight: 800,
      aspectRatio: widget.cropAspectRatio ??
          (widget.isCircular
              ? const CropAspectRatio(ratioX: 1, ratioY: 1)
              : null),
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 90,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: widget.isCircular ? 'Crop Profile Photo' : 'Crop Logo',
          toolbarColor: bc.primary,
          toolbarWidgetColor: bc.onPrimary,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: widget.isCircular,
          showCropGrid: !widget.isCircular,
          hideBottomControls: false,
        ),
        IOSUiSettings(
          title: widget.isCircular ? 'Crop Profile Photo' : 'Crop Logo',
          aspectRatioLockEnabled: widget.isCircular,
          resetAspectRatioEnabled: !widget.isCircular,
          rotateClockwiseButtonHidden: false,
          rotateButtonsHidden: false,
        ),
        WebUiSettings(
          context: context,
        ),
      ],
    );
  }

  void _removeImage() {
    setState(() => _pickedFile = null);
    widget.onImagePicked?.call(null);
  }

  void _showImageOptions() {
    final bc = context.barter;

    showModalBottomSheet(
      context: context,
      backgroundColor: bc.surfaceContainerLowest,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: bc.outlineVariant.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: Icon(Symbols.photo_library, color: bc.primary),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage();
              },
            ),
            if (_hasImage)
              ListTile(
                leading: Icon(Symbols.crop, color: bc.primary),
                title: const Text('Crop/Edit Current'),
                onTap: () async {
                  Navigator.pop(context);
                  if (_pickedFile != null && !kIsWeb) {
                    setState(() => _isLoading = true);
                    final cropped = await _cropImage(_pickedFile!.path);
                    if (cropped != null) {
                      final croppedXFile = XFile(cropped.path);
                      setState(() => _pickedFile = croppedXFile);
                      widget.onImagePicked?.call(croppedXFile);
                    }
                    setState(() => _isLoading = false);
                  }
                },
              ),
            if (_hasImage)
              ListTile(
                leading: Icon(Symbols.delete, color: bc.error),
                title: Text('Remove Photo', style: TextStyle(color: bc.error)),
                onTap: () {
                  Navigator.pop(context);
                  _removeImage();
                },
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  String? get _displayUrl {
    if (_pickedFile != null) {
      return _pickedFile!.path;
    }
    return widget.initialUrl;
  }

  bool get _hasImage => _displayUrl != null && _displayUrl!.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final bc = context.barter;
    final bgColor = widget.backgroundColor ?? bc.surfaceContainerLow;
    final borderColor = widget.borderColor ?? bc.outlineVariant.withValues(alpha: 0.35);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            // Main container
            Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                color: bgColor,
                shape: widget.isCircular ? BoxShape.circle : BoxShape.rectangle,
                borderRadius: widget.isCircular ? null : BorderRadius.circular(16),
                border: Border.all(
                  color: borderColor,
                  width: widget.isCircular ? 4 : 2,
                ),
                boxShadow: widget.isCircular
                    ? [
                        BoxShadow(
                          color: bc.outlineVariant.withValues(alpha: 0.2),
                          blurRadius: 1,
                        ),
                      ]
                    : null,
              ),
              child: ClipRRect(
                borderRadius: widget.isCircular
                    ? BorderRadius.circular(widget.size / 2)
                    : BorderRadius.circular(14),
                child: _isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: bc.primary.withValues(alpha: 0.6),
                        ),
                      )
                    : _hasImage
                        ? kIsWeb
                            ? Image.network(
                                _displayUrl!,
                                fit: BoxFit.cover,
                                width: widget.size,
                                height: widget.size,
                                errorBuilder: (_, __, ___) => _buildPlaceholder(bc),
                              )
                            : Image.file(
                                File(_displayUrl!),
                                fit: BoxFit.cover,
                                width: widget.size,
                                height: widget.size,
                                errorBuilder: (_, __, ___) => _buildPlaceholder(bc),
                              )
                        : _buildPlaceholder(bc),
              ),
            ),

            // Edit button (positioned at bottom-right for circular, centered overlay for rect)
            if (widget.showEditButton)
              Positioned(
                bottom: widget.isCircular ? -4 : null,
                right: widget.isCircular ? -4 : null,
                top: widget.isCircular ? null : 0,
                left: widget.isCircular ? null : 0,
                child: widget.isCircular
                    ? _buildCircularEditButton(bc)
                    : _buildOverlayEditButton(bc),
              ),

            // Tap handler for the whole area (when no edit button)
            if (!widget.showEditButton)
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _pickImage,
                    customBorder: widget.isCircular
                        ? const CircleBorder()
                        : RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
              ),
          ],
        ),

        // Subtitle text
        if (widget.subtitleText != null) ...[
          const SizedBox(height: 12),
          Text(
            widget.subtitleText!,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: bc.onSurfaceVariant.withValues(alpha: 0.5),
                  fontWeight: FontWeight.w500,
                  fontSize: 11,
                ),
          ),
        ],
      ],
    );
  }

  Widget _buildPlaceholder(BarterColors bc) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _pickImage,
        customBorder: widget.isCircular
            ? const CircleBorder()
            : RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Symbols.add_a_photo,
                color: bc.outlineVariant,
                size: widget.isCircular ? 32 : 24,
              ),
              if (!widget.isCircular) ...[
                const SizedBox(height: 4),
                Text(
                  widget.placeholderText.toUpperCase(),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: bc.onSurfaceVariant.withValues(alpha: 0.6),
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                        fontSize: 10,
                      ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCircularEditButton(BarterColors bc) {
    return GestureDetector(
      onTap: _showImageOptions,
      child: Container(
        width: widget.editButtonSize,
        height: widget.editButtonSize,
        decoration: BoxDecoration(
          color: bc.primary,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: bc.onBackground.withValues(alpha: 0.2),
              blurRadius: 8,
            ),
          ],
        ),
        child: Icon(
          Symbols.edit,
          color: bc.onPrimary,
          size: widget.editButtonSize * 0.5,
        ),
      ),
    );
  }

  Widget _buildOverlayEditButton(BarterColors bc) {
    return Positioned.fill(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _showImageOptions,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            decoration: BoxDecoration(
              color: bc.onBackground.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Symbols.photo_camera,
                    color: bc.surface,
                    size: 32,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Change Photo',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: bc.surface,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A simpler inline image picker for use in forms
class BarterInlineImagePicker extends StatelessWidget {
  const BarterInlineImagePicker({
    super.key,
    this.url,
    this.onTap,
    this.size = 112,
    this.borderRadius = 16,
    this.placeholderIcon = Symbols.add_a_photo,
    this.placeholderText = 'UPLOAD LOGO',
  });

  final String? url;
  final VoidCallback? onTap;
  final double size;
  final double borderRadius;
  final IconData placeholderIcon;
  final String placeholderText;

  @override
  Widget build(BuildContext context) {
    final bc = context.barter;
    final hasImage = url != null && url!.isNotEmpty;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: bc.surfaceContainerLow,
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color: bc.outlineVariant.withValues(alpha: 0.35),
                width: 2,
              ),
              image: hasImage && !kIsWeb
                  ? DecorationImage(
                      image: FileImage(File(url!)),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: hasImage
                ? kIsWeb
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(borderRadius - 2),
                        child: Image.network(
                          url!,
                          fit: BoxFit.cover,
                          errorBuilder: (ctx, __, ___) => _buildPlaceholder(ctx, bc),
                        ),
                      )
                    : null
                : _buildPlaceholder(context, bc),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder(BuildContext context, BarterColors bc) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(placeholderIcon, color: bc.outlineVariant, size: 24),
        const SizedBox(height: 6),
        Text(
          placeholderText,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontSize: 10,
                color: bc.onSurfaceVariant.withValues(alpha: 0.55),
              ),
        ),
      ],
    );
  }
}
