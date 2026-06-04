import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../theme/barter_colors.dart';

class BarterNetworkImage extends StatefulWidget {
  const BarterNetworkImage({
    super.key,
    required this.url,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.width,
    this.height,
    this.memCacheWidth,
    this.memCacheHeight,
  });

  final String url;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final double? width;
  final double? height;
  final int? memCacheWidth;
  final int? memCacheHeight;

  @override
  State<BarterNetworkImage> createState() => _BarterNetworkImageState();
}

class _BarterNetworkImageState extends State<BarterNetworkImage> {
  bool _hasError = false;
  bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    final bc = context.barter;

    Widget child;

    if (_hasError) {
      // Error state - show gray placeholder with icon
      child = Container(
        color: bc.surfaceContainerLow,
        alignment: Alignment.center,
        child: Icon(Icons.person_outline, color: bc.onSurfaceVariant.withValues(alpha: 0.5), size: 48),
      );
    } else {
      // Use Image.network for web (avoids cached_network_image CORS issues)
      // For mobile, we could use CachedNetworkImage, but using Image.network
      // consistently for simplicity and web compatibility
      child = Image.network(
        widget.url,
        width: widget.width,
        height: widget.height,
        fit: widget.fit,
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          if (wasSynchronouslyLoaded || frame != null) {
            // Image loaded - fade it in
            return AnimatedOpacity(
              opacity: _isLoading ? 0 : 1,
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              onEnd: () => setState(() => _isLoading = false),
              child: child,
            );
          }
          // Still loading
          return Container(
            color: bc.surfaceContainerLow,
            alignment: Alignment.center,
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: bc.primary.withValues(alpha: 0.5),
              ),
            ),
          );
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted && _isLoading) {
                setState(() => _isLoading = false);
              }
            });
            return child;
          }
          return Container(
            color: bc.surfaceContainerLow,
            alignment: Alignment.center,
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: bc.primary.withValues(alpha: 0.5),
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                    : null,
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && !_hasError) {
              setState(() => _hasError = true);
            }
          });
          return Container(
            color: bc.surfaceContainerLow,
            alignment: Alignment.center,
            child: Icon(Icons.person_outline, color: bc.onSurfaceVariant.withValues(alpha: 0.5), size: 48),
          );
        },
      );
    }

    if (widget.borderRadius != null) {
      child = ClipRRect(borderRadius: widget.borderRadius!, child: child);
    }
    return child;
  }
}
