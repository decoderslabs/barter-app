import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/config/api_config.dart';
import '../../../providers/app_providers.dart';
import '../../../theme/barter_colors.dart';
import '../../../widgets/barter_appbar.dart';

class PendingApprovalScreen extends ConsumerStatefulWidget {
  const PendingApprovalScreen({
    super.key,
    this.submittedUrl,
    this.taskTitle,
  });

  final String? submittedUrl;
  final String? taskTitle;

  @override
  ConsumerState<PendingApprovalScreen> createState() =>
      _PendingApprovalScreenState();
}

class _PendingApprovalScreenState extends ConsumerState<PendingApprovalScreen> {
  bool _isRefreshing = false;

  Future<void> _refreshStatus() async {
    setState(() => _isRefreshing = true);
    try {
      ref.invalidate(membershipProvider);
      ref.invalidate(authProvider);
      await ref.read(membershipProvider.future);
    } catch (_) {
      // Ignored for network retry
    } finally {
      if (mounted) setState(() => _isRefreshing = false);
    }
  }

  Future<void> _joinWhatsApp() async {
    final uri = Uri.parse(ApiConfig.communityWhatsAppUrl);
    try {
      final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!launched && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not open: ${ApiConfig.communityWhatsAppUrl}'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not open WhatsApp: $e'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bc = context.barter;
    final theme = Theme.of(context);
    final auth = ref.watch(authProvider);
    final membershipAsync = ref.watch(membershipProvider);

    final user = auth.user;
    final isApproved = membershipAsync.valueOrNull?.status.proActive ?? false;

    return Scaffold(
      backgroundColor: bc.background,
      appBar: BarterAppBar(
        showBrandTitle: false,
        title: 'Membership Status',
        leading: IconButton(
          icon: Icon(Symbols.arrow_back, color: bc.onBackground),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/creator/feed');
            }
          },
        ),
        actions: [
          IconButton(
            tooltip: 'Refresh Status',
            icon: _isRefreshing
                ? SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: bc.primary,
                    ),
                  )
                : Icon(Symbols.refresh, color: bc.primary),
            onPressed: _isRefreshing ? null : _refreshStatus,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Status Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: isApproved
                      ? const Color(0xFFE8F5E9)
                      : bc.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: isApproved
                        ? const Color(0xFF2E7D32).withValues(alpha: 0.3)
                        : bc.outlineVariant.withValues(alpha: 0.2),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: bc.onBackground.withValues(alpha: 0.04),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: isApproved
                                ? const Color(0xFF2E7D32).withValues(alpha: 0.15)
                                : const Color(0xFFE65100).withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isApproved
                                ? Symbols.verified
                                : Symbols.hourglass_top,
                            color: isApproved
                                ? const Color(0xFF2E7D32)
                                : const Color(0xFFE65100),
                            size: 26,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isApproved
                                    ? 'MEMBERSHIP ACTIVE'
                                    : 'UNDER EDITORIAL REVIEW',
                                style: theme.textTheme.labelMedium?.copyWith(
                                  color: isApproved
                                      ? const Color(0xFF2E7D32)
                                      : const Color(0xFFE65100),
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 2,
                                  fontSize: 11,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                isApproved
                                    ? 'Welcome to Barter Pro'
                                    : 'Estimated: 24–48 Hours',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: bc.onSurfaceVariant,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      isApproved
                          ? "Congratulations! Your profile & proof post have been verified. You now have full access to live barter exchanges."
                          : "Your claim has been submitted! Our curation team reviews every submission to ensure high-aesthetic brand storytelling.",
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: bc.onBackground,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Submission Summary Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: bc.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SUBMISSION DETAILS',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: bc.onSurfaceVariant,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 14),
                    _DetailRow(
                      icon: Symbols.person,
                      label: 'Creator',
                      value: user != null ? '${user.name} (@${user.username})' : 'Pending',
                      bc: bc,
                    ),
                    const SizedBox(height: 10),
                    _DetailRow(
                      icon: Symbols.workspace_premium,
                      label: 'Task',
                      value: widget.taskTitle ?? 'Editorial Intro Post on Instagram/TikTok',
                      bc: bc,
                    ),
                    if (widget.submittedUrl != null && widget.submittedUrl!.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      _DetailRow(
                        icon: Symbols.link,
                        label: 'Proof Link',
                        value: widget.submittedUrl!,
                        bc: bc,
                        isLink: true,
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Join WhatsApp Community Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF075E54), Color(0xFF128C7E)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF128C7E).withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Symbols.groups,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 14),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Barter Creator Club',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              Text(
                                'Private WhatsApp Community',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Do not wait alone. Join our private creator circle to get fast-track review tips, meet fellow storytellers, and receive first notifications on new drops.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _joinWhatsApp,
                        icon: const Icon(Symbols.chat, color: Color(0xFF075E54)),
                        label: const Text(
                          'Join WhatsApp Community',
                          style: TextStyle(
                            color: Color(0xFF075E54),
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.5,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF25D366),
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(999),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Secondary Actions
              if (isApproved) ...[
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => context.go('/creator/feed'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: bc.primary,
                      foregroundColor: bc.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                    child: const Text(
                      'Explore Live Exchanges',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
              ] else ...[
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => context.push('/creator/onboarding/profile'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: bc.onSurface,
                          side: BorderSide(
                            color: bc.outlineVariant.withValues(alpha: 0.3),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                        child: const Text('Edit Profile'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _refreshStatus,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: bc.primary,
                          side: BorderSide(color: bc.primary),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                        child: const Text('Check Status'),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.bc,
    this.isLink = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final BarterColors bc;
  final bool isLink;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: bc.primary),
        const SizedBox(width: 10),
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: TextStyle(
              color: bc.onSurfaceVariant,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: isLink ? bc.primary : bc.onBackground,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              decoration: isLink ? TextDecoration.underline : null,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
