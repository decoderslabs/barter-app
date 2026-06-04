import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../theme/barter_colors.dart';
import 'barter_network_image.dart';

class BarterAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BarterAppBar({
    super.key,
    this.title,
    this.leading,
    this.actions,
    this.centerTitle = false,
    this.backgroundColor,
    this.showBrandTitle = true,
    this.surfaceTintColor,
    this.elevation,
  });

  final String? title;
  final Widget? leading;
  final List<Widget>? actions;
  final bool centerTitle;
  final Color? backgroundColor;
  final bool showBrandTitle;
  final Color? surfaceTintColor;
  final double? elevation;

  @override
  Widget build(BuildContext context) {
    final bc = context.barter;
    
    return AppBar(
      backgroundColor: backgroundColor ?? bc.background,
      surfaceTintColor: surfaceTintColor ?? Colors.transparent,
      elevation: elevation ?? 0,
      centerTitle: centerTitle,
      leading: leading,
      title: showBrandTitle
          ? Text(
              title ?? 'BARTER',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                    fontStyle: FontStyle.italic,
                    color: bc.primary,
                    letterSpacing: -1,
                  ),
            )
          : title != null
              ? Text(
                  title!,
                  style: Theme.of(context).textTheme.titleLarge,
                )
              : null,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class BarterBackButton extends StatelessWidget {
  const BarterBackButton({
    super.key,
    this.onPressed,
    this.color,
  });

  final VoidCallback? onPressed;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final bc = context.barter;
    return IconButton(
      icon: Icon(Symbols.arrow_back, color: color ?? bc.onBackground),
      onPressed: onPressed ?? () => Navigator.of(context).pop(),
    );
  }
}

class BarterCloseButton extends StatelessWidget {
  const BarterCloseButton({
    super.key,
    this.onPressed,
    this.color,
  });

  final VoidCallback? onPressed;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final bc = context.barter;
    return IconButton(
      icon: Icon(Symbols.close, color: color ?? bc.onSurface),
      onPressed: onPressed ?? () => Navigator.of(context).pop(),
    );
  }
}

class BarterProfileAvatar extends StatelessWidget {
  const BarterProfileAvatar({
    super.key,
    this.imageUrl,
    this.radius = 20,
    this.onTap,
  });

  final String? imageUrl;
  final double radius;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final bc = context.barter;
    
    Widget avatar = Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        color: bc.surfaceContainerHighest,
        shape: BoxShape.circle,
      ),
      child: ClipOval(
        child: imageUrl != null
            ? BarterNetworkImage(
                url: imageUrl!,
                fit: BoxFit.cover,
                memCacheWidth: (radius * 2).toInt(),
                memCacheHeight: (radius * 2).toInt(),
              )
            : Icon(Icons.person, color: bc.onSurfaceVariant, size: radius),
      ),
    );

    if (onTap != null) {
      avatar = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(radius),
          child: avatar,
        ),
      );
    }

    return avatar;
  }
}
