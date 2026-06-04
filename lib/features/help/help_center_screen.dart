import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../theme/barter_colors.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bc = context.barter;

    return Scaffold(
      backgroundColor: bc.background,
      appBar: AppBar(
        backgroundColor: bc.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Symbols.arrow_back, color: bc.primary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Help Center',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SearchBar(bc: bc),
            const SizedBox(height: 32),
            _QuickLinksSection(bc: bc),
            const SizedBox(height: 32),
            _PopularArticlesSection(bc: bc),
            const SizedBox(height: 32),
            _ContactSupportSection(bc: bc),
          ],
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.bc});

  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: bc.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search for help...',
          hintStyle: TextStyle(color: bc.onSurfaceVariant.withValues(alpha: 0.5)),
          prefixIcon: Icon(Symbols.search, color: bc.onSurfaceVariant),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }
}

class _QuickLinksSection extends StatelessWidget {
  const _QuickLinksSection({required this.bc});

  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    final quickLinks = [
      ('Getting Started', Symbols.rocket_launch),
      ('Account Settings', Symbols.settings),
      ('Payments', Symbols.payments),
      ('Verification', Symbols.verified),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Links',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: quickLinks.map((link) {
            return InkWell(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${link.$1} coming soon')),
                );
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: bc.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: bc.outlineVariant.withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(link.$2, color: bc.primary, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      link.$1,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _PopularArticlesSection extends StatelessWidget {
  const _PopularArticlesSection({required this.bc});

  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    final articles = [
      'How do I complete my profile?',
      'How do barter deals work?',
      'How to negotiate offers?',
      'Content rights explained',
      'Shipping and delivery FAQ',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Popular Articles',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        ...articles.map((article) {
          return ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Symbols.article, color: bc.primary.withValues(alpha: 0.6)),
            title: Text(
              article,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            trailing: Icon(Symbols.chevron_right, color: bc.onSurfaceVariant.withValues(alpha: 0.5)),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Article details coming soon')),
              );
            },
          );
        }),
      ],
    );
  }
}

class _ContactSupportSection extends StatelessWidget {
  const _ContactSupportSection({required this.bc});

  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Contact Support',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        Card(
          elevation: 0,
          color: bc.surfaceContainerLow,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: bc.outlineVariant.withValues(alpha: 0.2)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Need more help?',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Our support team is available 24/7 to assist you with any questions or issues.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: bc.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Chat support coming soon')),
                          );
                        },
                        icon: Icon(Symbols.chat, color: bc.primary),
                        label: const Text('Chat'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: bc.primary,
                          side: BorderSide(color: bc.primary),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Email support coming soon')),
                          );
                        },
                        icon: Icon(Symbols.email, color: bc.onPrimary),
                        label: const Text('Email'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: bc.primary,
                          foregroundColor: bc.onPrimary,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
