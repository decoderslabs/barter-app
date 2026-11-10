import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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

        final isConnected = existingAccount.id.isNotEmpty;

        return SocialPlatform(
          id: config.id,
          name: config.name,
          handle: isConnected ? '@${existingAccount.handle}' : '',
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
    setState(() => _isLoading = true);

    try {
      final auth = ref.read(authRepositoryProvider);

      // TODO: Implement OAuth flow
      // 1. Get OAuth URL from backend
      // final oauthUrl = await auth.getOAuthUrl(platformId);
      // 2. Open OAuth flow (using url_launcher or webview)
      // 3. Handle callback and extract tokens
      // 4. Exchange tokens for account info

      // For now, simulate OAuth flow with dialog for manual entry
      final result = await _showConnectDialog(platformId);
      if (result == null) return;

      // Connect account via API
      final session = ref.read(sessionProvider.notifier);
      await session.connectSocialAccount(
        platform: platformId,
        username: result['username']!,
        followers: int.parse(result['followers']!),
        engagementRate: double.parse(result['engagement']!),
      );

      // Refresh user data to get updated social accounts
      await ref.read(authProvider.notifier).refreshUser();

      // Reload local state
      _loadSocialAccounts();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$platformId connected successfully!')),
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
      setState(() => _isLoading = false);
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
      setState(() => _isLoading = false);
    }
  }

  Future<Map<String, String>?> _showConnectDialog(String platformId) async {
    final usernameController = TextEditingController();
    final followersController = TextEditingController();
    final engagementController = TextEditingController();

    return showDialog<Map<String, String>>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Connect $platformId'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                hintText: 'your_handle',
              ),
            ),
            TextField(
              controller: followersController,
              decoration: const InputDecoration(
                labelText: 'Followers',
                hintText: '10000',
              ),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: engagementController,
              decoration: const InputDecoration(
                labelText: 'Engagement Rate (%)',
                hintText: '4.5',
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, {
                'username': usernameController.text,
                'followers': followersController.text,
                'engagement': engagementController.text,
              });
            },
            child: const Text('Connect'),
          ),
        ],
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
                onPressed: _isLoading ? null : () => context.go('/creator/membership/earn'),
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
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 24,
        mainAxisSpacing: 24,
        childAspectRatio: 1.2,
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
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: _isHovered
              ? (isPrimary ? bc.primary : bc.tertiary)
              : bc.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(16),
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
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _isHovered
                    ? bc.surface.withValues(alpha: 0.2)
                    : bc.surfaceContainerLow,
                shape: BoxShape.circle,
              ),
              child: Icon(
                platform.icon,
                color: _isHovered ? bc.surface : bc.onBackground,
                size: 28,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              platform.name,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: _isHovered ? bc.surface : bc.onBackground,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              isPrimary
                  ? 'Connect your channel for video content exchanges.'
                  : 'Best for professional services and B2B creators.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: _isHovered
                        ? bc.surface.withValues(alpha: 0.8)
                        : bc.onSurfaceVariant,
                  ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () => widget.onConnect(platform.id),
              style: ElevatedButton.styleFrom(
                backgroundColor: _isHovered ? bc.surface : bc.onBackground,
                foregroundColor: _isHovered
                    ? (isPrimary ? bc.primary : bc.tertiary)
                    : bc.surface,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                minimumSize: const Size(double.infinity, 48),
              ),
              child: Text(
                'Connect ${platform.name}',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
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
