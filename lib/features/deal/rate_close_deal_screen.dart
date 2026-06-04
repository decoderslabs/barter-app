import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../core/config/api_config.dart';
import '../../core/routing/deal_route.dart';
import '../../providers/api_providers.dart';
import '../../theme/barter_colors.dart';
import '../../widgets/barter_appbar.dart';

class RateCloseDealScreen extends ConsumerStatefulWidget {
  const RateCloseDealScreen({super.key});

  @override
  ConsumerState<RateCloseDealScreen> createState() => _RateCloseDealScreenState();
}

class _RateCloseDealScreenState extends ConsumerState<RateCloseDealScreen> {
  int _rating = 4;
  final TextEditingController _reviewController = TextEditingController();

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bc = context.barter;
    return Scaffold(
      backgroundColor: bc.background,
      appBar: BarterAppBar(
        showBrandTitle: false,
        title: 'Deal Room',
        leading: BarterBackButton(color: bc.primary),
        actions: [
          IconButton(
            icon: Icon(Symbols.more_vert, color: bc.primary),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (_) => SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(leading: const Icon(Icons.flag), title: const Text('Report Issue'), onTap: () => Navigator.pop(context)),
                      ListTile(leading: const Icon(Icons.share), title: const Text('Share'), onTap: () => Navigator.pop(context)),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            Center(
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: bc.primaryContainer,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: bc.primary.withValues(alpha: 0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Icon(Symbols.check_circle, color: bc.onPrimary, size: 40, fill: 1),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: Text(
                'Deal Complete',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: bc.onSurfaceVariant,
                      ),
                  children: [
                    const TextSpan(text: 'The exchange with '),
                    TextSpan(
                      text: '@lexi_creative',
                      style: TextStyle(color: bc.primary),
                    ),
                    const TextSpan(text: ' is now finalized.'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(child: _SummaryCard(label: 'Final Value', value: '\$2,450', subtitle: 'EST.', bc: bc)),
                const SizedBox(width: 16),
                Expanded(
                  child: _SummaryCard(
                    label: 'Barter Fee',
                    value: '\$49.00',
                    subtitle: 'CHARGED',
                    bc: bc,
                    hasPrimaryBorder: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            _RatingSection(bc: bc),
            const SizedBox(height: 32),
            _ActionButtons(
              bc: bc,
              onSubmit: () async {
                final dealId = dealIdFromRoute(context);
                if (dealId != null && !ApiConfig.useMockData) {
                  await ref.read(dealRepositoryProvider).rateDeal(dealId, {
                    'stars': _rating,
                    'review_text': _reviewController.text.trim(),
                  });
                }
                if (context.mounted) {
                  context.push('/deal/rating-confirmation');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.label,
    required this.value,
    required this.subtitle,
    required this.bc,
    this.hasPrimaryBorder = false,
  });

  final String label;
  final String value;
  final String subtitle;
  final BarterColors bc;
  final bool hasPrimaryBorder;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: bc.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: hasPrimaryBorder ? Border(left: BorderSide(color: bc.primary, width: 4)) : null,
        boxShadow: [
          BoxShadow(
            color: bc.onBackground.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  fontSize: 10,
                  color: bc.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: hasPrimaryBorder ? bc.primary : bc.onSurface,
                    ),
              ),
              const SizedBox(width: 4),
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: bc.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RatingSection extends StatefulWidget {
  const _RatingSection({required this.bc});

  final BarterColors bc;

  @override
  State<_RatingSection> createState() => _RatingSectionState();
}

class _RatingSectionState extends State<_RatingSection> {
  int _rating = 4;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: widget.bc.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Text(
            'Rate your experience',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: IconButton(
                  iconSize: 40,
                  icon: Icon(
                    Symbols.star,
                    color: index < _rating ? widget.bc.primary : widget.bc.onSurfaceVariant.withValues(alpha: 0.2),
                    fill: index < _rating ? 1.0 : 0.0,
                  ),
                  onPressed: () {
                    setState(() {
                      _rating = index + 1;
                    });
                  },
                ),
              );
            }),
          ),
          const SizedBox(height: 24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Written Review',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                      fontSize: 10,
                      color: widget.bc.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: widget.bc.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: TextField(
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Tell us about the collaboration quality, communication, and results...',
                    hintStyle: TextStyle(
                      color: widget.bc.onSurfaceVariant.withValues(alpha: 0.4),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(20),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons({required this.bc, required this.onSubmit});

  final BarterColors bc;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: onSubmit,
            style: ElevatedButton.styleFrom(
              backgroundColor: bc.primary,
              foregroundColor: bc.onPrimary,
              padding: const EdgeInsets.symmetric(vertical: 20),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
              elevation: 0,
              shadowColor: bc.primary.withValues(alpha: 0.2),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Submit & Close Deal'),
                const SizedBox(width: 12),
                Icon(Symbols.lock, color: bc.onPrimary),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: TextButton(
            onPressed: () => context.go('/creator/feed'),
            child: Text(
              'Skip for now',
              style: TextStyle(
                color: bc.onSurfaceVariant,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
