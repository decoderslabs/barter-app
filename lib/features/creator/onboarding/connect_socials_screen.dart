import '../../../widgets/barter_logo.dart';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../data/dto/user_dto.dart';
import '../../../providers/api_providers.dart';
import '../../../providers/app_providers.dart';
import '../../../theme/barter_colors.dart';

class ConnectSocialsScreen extends ConsumerStatefulWidget {
  const ConnectSocialsScreen({super.key});

  @override
  ConsumerState<ConnectSocialsScreen> createState() => _ConnectSocialsScreenState();
}

class _ConnectSocialsScreenState extends ConsumerState<ConnectSocialsScreen> {
  bool _isLoading = false;
  List<SocialPlatform> _platforms = [];

  @override
  void initState() {
    super.initState();
    _loadSocialAccounts();
  }

  void _loadSocialAccounts() {
    final user = ref.read(authProvider).user;
    final accounts = user?.socialAccounts ?? [];

    // Define available platforms
    final availablePlatforms = [
      _PlatformConfig('instagram', 'Instagram', Symbols.photo_camera, const Color(0xFFE1306C)),
      _PlatformConfig('tiktok', 'TikTok', Symbols.music_note, const Color(0xFF000000)),
      _PlatformConfig('youtube', 'YouTube', Symbols.smart_display, const Color(0xFFFF0000)),
      _PlatformConfig('linkedin', 'LinkedIn', Symbols.work, const Color(0xFF0077B5)),
    ];

    setState(() {
      _platforms = availablePlatforms.map((config) {
        final existingAccount = accounts.firstWhere(
          (a) => a.platform.toLowerCase() == config.id,
          orElse: () => const SocialAccountDto(
            id: '',
            platform: '',
            handle: '',
          ),
        );

        final isConnected = existingAccount.handle.isNotEmpty || existingAccount.id.isNotEmpty;
        final cleanHandle = existingAccount.handle.startsWith('@')
            ? existingAccount.handle
            : '@${existingAccount.handle}';

        return SocialPlatform(
          id: config.id,
          name: config.name,
          handle: isConnected ? cleanHandle : '',
          icon: config.icon,
          status: isConnected ? SocialStatus.connected : SocialStatus.disconnected,
          followers: isConnected && existingAccount.followers != null
              ? _formatFollowers(existingAccount.followers!)
              : '',
          engagement: isConnected && existingAccount.engagementRate != null
              ? '${existingAccount.engagementRate!.toStringAsFixed(1)}%'
              : '',
          color: config.color,
          accountId: existingAccount.id,
          proofUrl: existingAccount.proofUrl,
        );
      }).toList();
    });
  }

  String _formatFollowers(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(0)}K';
    }
    return count.toString();
  }

  Future<void> _onConnectPlatform(String platformId) async {
    final result = await _showConnectDialog(platformId);
    if (result == null) return;

    setState(() => _isLoading = true);

    try {
      final session = ref.read(sessionProvider.notifier);
      await session.connectSocialAccount(
        platform: platformId,
        username: result['username']!,
        followers: int.tryParse(result['followers'] ?? '') ?? 10000,
        engagementRate: double.tryParse(result['engagement'] ?? '') ?? 4.5,
        proofUrl: result['proof_url'],
      );

      // Refresh user data to get updated social accounts
      await ref.read(authProvider.notifier).refreshUser();

      // Reload local state
      _loadSocialAccounts();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$platformId connected with proof!'),
            backgroundColor: context.barter.primary,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to connect $platformId: $e'),
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

  Future<void> _onDisconnectPlatform(String platformId) async {
    setState(() => _isLoading = true);

    try {
      final session = ref.read(sessionProvider.notifier);
      await session.disconnectSocialAccount(platformId);

      // Refresh user data
      await ref.read(authProvider.notifier).refreshUser();

      // Reload local state
      _loadSocialAccounts();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$platformId disconnected')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to disconnect $platformId: $e'),
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

  Future<Map<String, String>?> _showConnectDialog(String platformId) async {
    final user = ref.read(authProvider).user;
    final defaultHandle = user?.username ?? '';
    final platformMatch = _platforms.firstWhere(
      (p) => p.id == platformId,
      orElse: () => SocialPlatform(
        id: platformId,
        name: platformId.toUpperCase(),
        handle: '',
        icon: Symbols.share,
        status: SocialStatus.disconnected,
        followers: '',
        engagement: '',
        color: Colors.blue,
      ),
    );

    return showDialog<Map<String, String>>(
      context: context,
      builder: (context) => _ConnectSocialProofDialog(
        platformId: platformId,
        platformName: platformMatch.name,
        initialHandle: defaultHandle,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bc = context.barter;

    return Scaffold(
      backgroundColor: bc.background,
      appBar: AppBar(
        backgroundColor: bc.background,
        title: const BarterLogo(height: 28),
        actions: [
          TextButton(
            onPressed: () => context.push('/help'),
            child: Text(
              'Help',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: bc.onBackground,
                    fontWeight: FontWeight.w600,
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
            _ProgressBar(bc: bc),
            const SizedBox(height: 40),
            _Description(bc: bc),
            const SizedBox(height: 40),
            _SocialPlatformsGrid(
              platforms: _platforms,
              onConnect: _onConnectPlatform,
              onDisconnect: _onDisconnectPlatform,
              bc: bc,
            ),
            const SizedBox(height: 48),
            _PrivacyDisclaimer(bc: bc),
            const SizedBox(height: 120),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: bc.surface.withValues(alpha: 0.8),
        ),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton.icon(
                onPressed: () => context.pop(),
                icon: Icon(Symbols.chevron_left, color: bc.onSurfaceVariant),
                label: Text(
                  'Back',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: bc.onSurfaceVariant,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : () {
                        final hasConnected = _platforms.any((p) => p.status == SocialStatus.connected);
                        if (!hasConnected) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Please connect at least 1 social account to claim membership'),
                              backgroundColor: context.barter.error,
                            ),
                          );
                          return;
                        }
                        context.go('/creator/membership/earn');
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: bc.primary,
                  foregroundColor: bc.onPrimary,
                  padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                ),
                child: _isLoading
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: bc.onPrimary,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        'Claim Membership',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: bc.onPrimary,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.5,
                            ),
                      ),
              ),
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
                  'Step 3 of 5',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: bc.primary,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                        fontSize: 11,
                      ),
                ),
                RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    children: [
                      const TextSpan(text: 'Connect '),
                      TextSpan(
                        text: 'Socials',
                        style: TextStyle(color: bc.primary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Text(
              '60%',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          height: 8,
          decoration: BoxDecoration(
            color: bc.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(999),
          ),
          child: FractionallySizedBox(
            widthFactor: 0.6,
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

class _Description extends StatelessWidget {
  const _Description({required this.bc});

  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return Text(
      'Link your platforms to verify your reach. We use this data to match you with brands that fit your audience profile perfectly.',
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: bc.onSurfaceVariant,
            height: 1.6,
          ),
    );
  }
}

class _SocialPlatformsGrid extends StatelessWidget {
  const _SocialPlatformsGrid({
    required this.platforms,
    required this.onConnect,
    required this.onDisconnect,
    required this.bc,
  });

  final List<SocialPlatform> platforms;
  final ValueChanged<String> onConnect;
  final ValueChanged<String> onDisconnect;
  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final crossAxisCount = width > 900 ? 3 : 2;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 1.35,
      ),
      itemCount: platforms.length,
      itemBuilder: (context, index) {
        final platform = platforms[index];
        return _SocialPlatformCard(
          platform: platform,
          onConnect: onConnect,
          onDisconnect: onDisconnect,
          bc: bc,
        );
      },
    );
  }
}

class _SocialPlatformCard extends StatelessWidget {
  const _SocialPlatformCard({
    required this.platform,
    required this.onConnect,
    required this.onDisconnect,
    required this.bc,
  });

  final SocialPlatform platform;
  final ValueChanged<String> onConnect;
  final ValueChanged<String> onDisconnect;
  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    switch (platform.status) {
      case SocialStatus.connected:
        return _ConnectedCard(
          platform: platform,
          onDisconnect: onDisconnect,
          bc: bc,
        );
      case SocialStatus.syncing:
        return _SyncingCard(platform: platform, bc: bc);
      case SocialStatus.disconnected:
        return _ConnectCard(
          platform: platform,
          onConnect: onConnect,
          bc: bc,
        );
    }
  }
}

class _ConnectedCard extends StatelessWidget {
  const _ConnectedCard({
    required this.platform,
    required this.onDisconnect,
    required this.bc,
  });

  final SocialPlatform platform;
  final ValueChanged<String> onDisconnect;
  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: bc.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border(left: BorderSide(color: bc.primary, width: 4)),
        boxShadow: [
          BoxShadow(
            color: bc.onBackground.withValues(alpha: 0.06),
            blurRadius: 40,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: bc.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  platform.icon,
                  color: bc.primary,
                  size: 28,
                ),
              ),
              Row(
                children: [
                  if (platform.proofUrl != null && platform.proofUrl!.isNotEmpty) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5E9),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: const Color(0xFFA5D6A7)),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Symbols.verified, size: 12, color: Color(0xFF2E7D32)),
                          SizedBox(width: 4),
                          Text(
                            'Proof Attached',
                            style: TextStyle(
                              color: Color(0xFF2E7D32),
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),
                  ],
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: bc.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      'Connected',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: bc.primary,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                            fontSize: 10,
                          ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () => onDisconnect(platform.id),
                    icon: Icon(
                      Symbols.close,
                      color: bc.error,
                      size: 20,
                    ),
                    tooltip: 'Disconnect',
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            platform.name,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            platform.handle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: bc.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.only(top: 16),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: bc.surfaceContainerHighest,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Followers',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: bc.onSurfaceVariant,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                              fontSize: 10,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        platform.followers,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: bc.primary,
                              fontWeight: FontWeight.w900,
                            ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Engagement',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: bc.onSurfaceVariant,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                              fontSize: 10,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        platform.engagement,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: bc.primary,
                              fontWeight: FontWeight.w900,
                            ),
                      ),
                    ],
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

class _SyncingCard extends StatelessWidget {
  const _SyncingCard({required this.platform, required this.bc});

  final SocialPlatform platform;
  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: bc.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: bc.onBackground.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  platform.icon,
                  color: bc.onBackground,
                  size: 28,
                ),
              ),
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: bc.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Syncing...',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: bc.onSurfaceVariant,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                          fontSize: 10,
                        ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            platform.name,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            'Fetching profile data',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: bc.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 16,
                width: MediaQuery.of(context).size.width * 0.25,
                decoration: BoxDecoration(
                  color: bc.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                height: 16,
                width: MediaQuery.of(context).size.width * 0.15,
                decoration: BoxDecoration(
                  color: bc.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ConnectCard extends StatefulWidget {
  const _ConnectCard({
    required this.platform,
    required this.onConnect,
    required this.bc,
  });

  final SocialPlatform platform;
  final ValueChanged<String> onConnect;
  final BarterColors bc;

  @override
  State<_ConnectCard> createState() => _ConnectCardState();
}

class _ConnectCardState extends State<_ConnectCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final bc = widget.bc;
    final platform = widget.platform;
    final isPrimary = platform.name == 'YouTube';

    return GestureDetector(
      onTapDown: (_) => setState(() => _isHovered = true),
      onTapUp: (_) => setState(() => _isHovered = false),
      onTapCancel: () => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: _isHovered
              ? (isPrimary ? bc.primary : bc.tertiary)
              : bc.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: bc.onBackground.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: _isHovered
                        ? bc.surface.withValues(alpha: 0.2)
                        : bc.surfaceContainerLow,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    platform.icon,
                    color: _isHovered ? bc.surface : bc.onBackground,
                    size: 20,
                  ),
                ),
                Text(
                  platform.name,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: _isHovered ? bc.surface : bc.onBackground,
                      ),
                ),
              ],
            ),
            Text(
              isPrimary
                  ? 'Connect channel for video content exchanges.'
                  : 'Professional and B2B creator exchanges.',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: _isHovered
                        ? bc.surface.withValues(alpha: 0.8)
                        : bc.onSurfaceVariant,
                    fontSize: 11,
                  ),
            ),
            SizedBox(
              width: double.infinity,
              height: 34,
              child: ElevatedButton(
                onPressed: () => widget.onConnect(platform.id),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isHovered ? bc.surface : bc.onBackground,
                  foregroundColor: _isHovered
                      ? (isPrimary ? bc.primary : bc.tertiary)
                      : bc.surface,
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                ),
                child: Text(
                  'Connect',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PrivacyDisclaimer extends StatelessWidget {
  const _PrivacyDisclaimer({required this.bc});

  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: bc.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(Symbols.verified_user, color: bc.primary),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Privacy Secured',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: bc.onBackground,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'BARTER only requests read-only access to your analytics. We never post on your behalf without explicit permission.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: bc.onSurfaceVariant,
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

enum SocialStatus { connected, syncing, disconnected }

class SocialPlatform {
  final String id;
  final String name;
  final String handle;
  final IconData icon;
  final SocialStatus status;
  final String followers;
  final String engagement;
  final Color color;
  final String accountId;
  final String? proofUrl;

  SocialPlatform({
    required this.id,
    required this.name,
    required this.handle,
    required this.icon,
    required this.status,
    required this.followers,
    required this.engagement,
    required this.color,
    this.accountId = '',
    this.proofUrl,
  });

  SocialPlatform copyWith({
    String? id,
    String? name,
    String? handle,
    IconData? icon,
    SocialStatus? status,
    String? followers,
    String? engagement,
    Color? color,
    String? accountId,
    String? proofUrl,
  }) {
    return SocialPlatform(
      id: id ?? this.id,
      name: name ?? this.name,
      handle: handle ?? this.handle,
      icon: icon ?? this.icon,
      status: status ?? this.status,
      followers: followers ?? this.followers,
      engagement: engagement ?? this.engagement,
      color: color ?? this.color,
      accountId: accountId ?? this.accountId,
      proofUrl: proofUrl ?? this.proofUrl,
    );
  }
}

class _PlatformConfig {
  final String id;
  final String name;
  final IconData icon;
  final Color color;

  _PlatformConfig(this.id, this.name, this.icon, this.color);
}

class _ConnectSocialProofDialog extends ConsumerStatefulWidget {
  const _ConnectSocialProofDialog({
    required this.platformId,
    required this.platformName,
    required this.initialHandle,
  });

  final String platformId;
  final String platformName;
  final String initialHandle;

  @override
  ConsumerState<_ConnectSocialProofDialog> createState() =>
      _ConnectSocialProofDialogState();
}

class _ConnectSocialProofDialogState
    extends ConsumerState<_ConnectSocialProofDialog> {
  late final TextEditingController _usernameController;
  final _followersController = TextEditingController(text: '10000');
  final _engagementController = TextEditingController(text: '4.5');

  XFile? _proofFile;
  Uint8List? _proofBytes;
  bool _isUploading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.initialHandle);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _followersController.dispose();
    _engagementController.dispose();
    super.dispose();
  }

  Future<void> _pickProof() async {
    try {
      final picker = ImagePicker();
      final file = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1600,
        maxHeight: 1600,
        imageQuality: 85,
      );
      if (file != null) {
        final bytes = await file.readAsBytes();
        setState(() {
          _proofFile = file;
          _proofBytes = bytes;
          _error = null;
        });
      }
    } catch (e) {
      setState(() => _error = 'Could not select image: $e');
    }
  }

  Future<void> _onSubmit() async {
    final handle = _usernameController.text.trim();
    final followers = _followersController.text.trim();
    final engagement = _engagementController.text.trim();

    if (handle.isEmpty) {
      setState(() => _error = 'Please enter your handle/username');
      return;
    }
    if (followers.isEmpty) {
      setState(() => _error = 'Please enter your follower count');
      return;
    }

    setState(() => _isUploading = true);

    String? uploadedUrl;
    try {
      if (_proofBytes != null && _proofFile != null) {
        uploadedUrl = await ref.read(authRepositoryProvider).uploadMedia(
              bytes: _proofBytes!,
              filename: _proofFile!.name,
            );
      }

      if (mounted) {
        Navigator.pop(context, {
          'username': handle,
          'followers': followers,
          'engagement': engagement.isNotEmpty ? engagement : '4.5',
          'proof_url': uploadedUrl ?? '',
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isUploading = false;
          _error = 'Upload failed: $e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bc = context.barter;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: bc.surfaceContainerLowest,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Connect ${widget.platformName}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    IconButton(
                      icon: const Icon(Symbols.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Upload your logged-in profile or creator dashboard screenshot to verify account ownership.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: bc.onSurfaceVariant,
                        height: 1.4,
                      ),
                ),
                const SizedBox(height: 20),
                // Handle Field
                Text(
                  'Username / Handle',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: bc.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    hintText: '(ideally your instagram username)',
                    prefixText: '@ ',
                    filled: true,
                    fillColor: bc.surfaceContainerLow,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  ),
                ),
                const SizedBox(height: 14),
                // Followers & Engagement row
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Followers',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: bc.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 6),
                          TextField(
                            controller: _followersController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: '10000',
                              filled: true,
                              fillColor: bc.surfaceContainerLow,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Engagement Rate (%)',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: bc.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 6),
                          TextField(
                            controller: _engagementController,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            decoration: InputDecoration(
                              hintText: '4.5',
                              filled: true,
                              fillColor: bc.surfaceContainerLow,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                // Proof Upload Box
                Text(
                  'Account Ownership Proof',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: bc.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 6),
                InkWell(
                  onTap: _isUploading ? null : _pickProof,
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _proofBytes != null
                          ? const Color(0xFFE8F5E9)
                          : bc.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: _proofBytes != null
                            ? const Color(0xFF81C784)
                            : bc.outlineVariant.withValues(alpha: 0.3),
                        width: 1.5,
                      ),
                    ),
                    child: _proofBytes != null
                        ? Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.memory(
                                  _proofBytes!,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Row(
                                      children: [
                                        Icon(Symbols.check_circle, color: Color(0xFF2E7D32), size: 16),
                                        SizedBox(width: 4),
                                        Text(
                                          'Screenshot Selected',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF2E7D32),
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      _proofFile?.name ?? 'screenshot.png',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: bc.onSurfaceVariant,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              TextButton(
                                onPressed: _pickProof,
                                child: const Text('Change'),
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              Icon(
                                Symbols.add_photo_alternate,
                                size: 36,
                                color: bc.primary,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Upload Profile / Dashboard Screenshot',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: bc.primary,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Screenshot showing you logged in as @${_usernameController.text.isNotEmpty ? _usernameController.text : "handle"}',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: bc.onSurfaceVariant.withValues(alpha: 0.7),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                  ),
                ),
                if (_error != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    _error!,
                    style: TextStyle(color: bc.error, fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ],
                const SizedBox(height: 24),
                // Submit Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isUploading ? null : _onSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: bc.primary,
                      foregroundColor: bc.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: _isUploading
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  color: bc.onPrimary,
                                  strokeWidth: 2,
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Text('Uploading & Verifying...'),
                            ],
                          )
                        : const Text(
                            'Verify & Connect',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
