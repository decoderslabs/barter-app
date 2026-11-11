import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'dart:js' as js;

import '../../../theme/barter_colors.dart';

class InstallAppScreen extends ConsumerStatefulWidget {
  const InstallAppScreen({super.key});

  @override
  ConsumerState<InstallAppScreen> createState() => _InstallAppScreenState();
}

class _InstallAppScreenState extends ConsumerState<InstallAppScreen> {
  bool _isInstalled = false;

  @override
  void initState() {
    super.initState();
    _checkIfInstalled();
  }

  void _checkIfInstalled() {
    if (kIsWeb) {
      try {
        final result = js.context.callMethod('isPwaInstalled');
        if (result == true) {
          setState(() => _isInstalled = true);
        }
      } catch (_) {}
    }
  }

  Future<void> _handleInstall() async {
    if (kIsWeb) {
      try {
        final accepted = js.context.callMethod('triggerPwaInstall');
        if (accepted == true) {
          if (mounted) {
            context.go('/creator/onboarding/profile');
          }
          return;
        }
      } catch (_) {}
    }

    // Fallback modal with OS-specific instructions
    if (mounted) {
      _showInstallInstructions(context);
    }
  }

  void _showInstallInstructions(BuildContext context) {
    final bc = context.barter;
    final isIos = defaultTargetPlatform == TargetPlatform.iOS;

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: bc.surfaceContainerLowest,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Symbols.install_mobile, color: bc.primary, size: 28),
                const SizedBox(width: 12),
                Text(
                  isIos ? 'Install on iOS Safari' : 'Install on Chrome / Android',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (isIos) ...[
              _buildStepRow(context, '1', 'Tap the Share icon at the bottom of Safari', Symbols.ios_share),
              const SizedBox(height: 12),
              _buildStepRow(context, '2', 'Scroll down and tap "Add to Home Screen"', Symbols.add_box),
              const SizedBox(height: 12),
              _buildStepRow(context, '3', 'Tap "Add" in the top right corner', Symbols.check_circle),
            ] else ...[
              _buildStepRow(context, '1', 'Tap the three-dot menu (⋮) in your browser', Symbols.more_vert),
              const SizedBox(height: 12),
              _buildStepRow(context, '2', 'Select "Install app" or "Add to Home screen"', Symbols.install_mobile),
              const SizedBox(height: 12),
              _buildStepRow(context, '3', 'Confirm by tapping "Install"', Symbols.check_circle),
            ],
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  context.go('/creator/onboarding/profile');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: bc.primary,
                  foregroundColor: bc.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text('Got it, Continue Setup'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepRow(BuildContext context, String number, String text, IconData icon) {
    final bc = context.barter;
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: bc.primary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            number,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: bc.primary,
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
        Icon(icon, color: bc.onSurfaceVariant.withValues(alpha: 0.5), size: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final bc = context.barter;

    return Scaffold(
      backgroundColor: bc.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(28),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // App Icon Showcase
                  Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [bc.primary, bc.primary.withValues(alpha: 0.8)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: bc.primary.withValues(alpha: 0.35),
                          blurRadius: 28,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        'B',
                        style: TextStyle(
                          color: bc.onPrimary,
                          fontSize: 48,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Install BARTER',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w900,
                          letterSpacing: -1,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Add BARTER to your Home Screen for full-screen mode, deal notifications, and the best creator experience.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: bc.onSurfaceVariant,
                          height: 1.5,
                        ),
                  ),
                  const SizedBox(height: 36),
                  // Benefit Cards
                  _buildBenefit(
                    context,
                    icon: Symbols.notifications_active,
                    title: 'Instant Deal Alerts',
                    subtitle: 'Be the first to apply when high-value barter campaigns go live',
                  ),
                  const SizedBox(height: 16),
                  _buildBenefit(
                    context,
                    icon: Symbols.smartphone,
                    title: 'Native App Feel',
                    subtitle: 'Zero browser address bar clutter, fast offline caching & 1-tap launch',
                  ),
                  const SizedBox(height: 16),
                  _buildBenefit(
                    context,
                    icon: Symbols.speed,
                    title: 'Seamless Onboarding',
                    subtitle: 'Track your membership status and approvals in real-time',
                  ),
                  const SizedBox(height: 40),
                  // Primary Install Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _handleInstall,
                      icon: const Icon(Symbols.install_mobile),
                      label: Text(
                        _isInstalled ? 'App Installed • Continue' : 'Install to Home Screen',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: bc.primary,
                        foregroundColor: bc.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                        elevation: 8,
                        shadowColor: bc.primary.withValues(alpha: 0.4),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  // Secondary Skip Button
                  TextButton(
                    onPressed: () => context.go('/creator/onboarding/profile'),
                    child: Text(
                      'Continue in Browser ➔',
                      style: TextStyle(
                        color: bc.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
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

  Widget _buildBenefit(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    final bc = context.barter;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bc.surfaceContainerLow,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: bc.outlineVariant.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: bc.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: bc.primary, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: bc.onSurfaceVariant,
                        height: 1.3,
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
