import 'package:flutter/material.dart';

import '../theme/barter_colors.dart';

class BarterLogo extends StatelessWidget {
  const BarterLogo({
    super.key,
    this.height = 28,
    this.width,
    this.color,
    this.fit = BoxFit.contain,
  });

  final double height;
  final double? width;
  final Color? color;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final bc = context.barter;
    return Image.asset(
      'assets/images/barter_logo.png',
      height: height,
      width: width,
      fit: fit,
      color: color,
      errorBuilder: (context, error, stackTrace) {
        return Text(
          'BARTER',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w900,
                fontStyle: FontStyle.italic,
                color: color ?? bc.primary,
                letterSpacing: -1,
                fontSize: height * 0.7,
              ),
        );
      },
    );
  }
}
