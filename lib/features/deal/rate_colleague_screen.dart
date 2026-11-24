import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../providers/api_providers.dart';
import '../../theme/barter_colors.dart';
import '../../widgets/barter_network_image.dart';

class RateColleagueScreen extends ConsumerStatefulWidget {
  const RateColleagueScreen({super.key, this.dealId});

  final String? dealId;

  @override
  ConsumerState<RateColleagueScreen> createState() => _RateColleagueScreenState();
}

class _RateColleagueScreenState extends ConsumerState<RateColleagueScreen> {
  @override
  Widget build(BuildContext context) {
    final bc = context.barter;
    return Scaffold(
      backgroundColor: bc.background,
      appBar: AppBar(
        backgroundColor: bc.background,
        leading: IconButton(
          icon: Icon(Symbols.close, color: bc.primary),
          onPressed: () => context.pop(),
        ),
        centerTitle: true,
        title: Text(
          'RATE EXCHANGE',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: bc.primary,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                fontSize: 12,
              ),
        ),
        actions: const [SizedBox(width: 24)],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: bc.primaryFixed,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                'Deal Complete',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: bc.onPrimaryFixedVariant,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      fontSize: 10,
                    ),
              ),
            ),
            const SizedBox(height: 16),
            RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      height: 1.1,
                    ),
                children: [
                  const TextSpan(text: 'Rate\n'),
                  TextSpan(text: 'Colleague', style: TextStyle(color: bc.primary)),
                ],
              ),
            ),
            const SizedBox(height: 32),
            _ProfileCard(bc: bc),
            const SizedBox(height: 32),
            _RatingSection(bc: bc, dealId: widget.dealId),
          ],
        ),
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({required this.bc});

  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: bc.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: bc.onBackground.withValues(alpha: 0.04),
            blurRadius: 40,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: bc.surface, width: 4),
                  boxShadow: [
                    BoxShadow(
                      color: bc.onBackground.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: BarterNetworkImage(
                    url: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBZ0UFibN2JL4rQLnnwfC0-pkuT0Vm4NN11nmoU6awBY9hq370IjG6JUovxbNQRh5Y90X6mVSmZsU0JgcTlYm8hKe9ubdW7-KmNJupTzBwYC6jO_tajK67GAedZOKyjPmRGs5rtrQ5_63G63DJsISbSE3NZaIA9Zq00j6F0d_EgSfiEgG0yH3WQPCGIMboqgJTvrlRr9ljWQ4AX9PVuoGqmjtsCPdbn9mlaqQRJYIr7rScOd3CQEQpWOHdupp6DSPeCPOzMw_0he6Q',
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: bc.tertiaryContainer,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: bc.onBackground.withValues(alpha: 0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(Symbols.verified, color: bc.onTertiaryContainer, size: 14, fill: 1),
              ),
            ],
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Collaborator',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: bc.onSurfaceVariant,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                        fontSize: 10,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Sarah Jenkins',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Senior Content Strategist',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: bc.tertiary,
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

class _RatingSection extends ConsumerStatefulWidget {
  const _RatingSection({required this.bc, this.dealId});

  final BarterColors bc;
  final String? dealId;

  @override
  ConsumerState<_RatingSection> createState() => _RatingSectionState();
}

class _RatingSectionState extends ConsumerState<_RatingSection> {
  int _rating = 4;
  final TextEditingController _controller = TextEditingController(text: 'Sarah was an absolute pleasure to work with. Her attention to detail on the campaign strategy was exceptional and she delivered ahead of schedule.');
  int _charCount = 124;
  static const int _maxLength = 280;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          children: [
            Text(
              'How was your experience?',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                    color: widget.bc.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: IconButton(
                    iconSize: 48,
                    icon: Icon(
                      Symbols.star,
                      color: index < _rating ? widget.bc.primary : widget.bc.outlineVariant.withValues(alpha: 0.4),
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
            const SizedBox(height: 16),
            Text(
              '4.0',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: widget.bc.primary,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 40),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Written Review (Optional)',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                        fontSize: 10,
                        color: widget.bc.onSurfaceVariant,
                      ),
                ),
                Text(
                  '$_charCount / $_maxLength',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                        color: widget.bc.outline,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: widget.bc.surfaceContainerLow,
                borderRadius: BorderRadius.circular(16),
              ),
              child: TextField(
                controller: _controller,
                maxLines: 5,
                maxLength: _maxLength,
                onChanged: (value) {
                  setState(() {
                    _charCount = value.length;
                  });
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(24),
                  counterText: '',
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: widget.bc.surfaceContainerHigh.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(16),
            border: Border(left: BorderSide(color: widget.bc.primary.withValues(alpha: 0.2), width: 4)),
          ),
          child: Row(
            children: [
              Icon(Symbols.info, color: widget.bc.primary.withValues(alpha: 0.6), size: 20),
              const SizedBox(width: 16),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: widget.bc.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                    children: [
                      const TextSpan(text: 'To ensure fairness, your rating will remain private and only be published once '),
                      TextSpan(
                        text: 'Sarah Jenkins',
                        style: TextStyle(
                          color: widget.bc.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const TextSpan(text: ' has also submitted a response, or after 7 days have passed.'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isSubmitting ? null : () async {
              setState(() => _isSubmitting = true);
              try {
                if (widget.dealId != null && widget.dealId!.isNotEmpty) {
                  await ref.read(dealRepositoryProvider).rateDeal(
                    widget.dealId!,
                    {
                      'stars': _rating,
                      'review_text': _controller.text.trim(),
                    },
                  );
                }
                if (context.mounted) {
                  context.push('/deal/rating-confirmation');
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to submit rating: $e')),
                  );
                  setState(() => _isSubmitting = false);
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.bc.primary,
              foregroundColor: widget.bc.onPrimary,
              padding: const EdgeInsets.symmetric(vertical: 20),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
              elevation: 0,
              shadowColor: widget.bc.primary.withValues(alpha: 0.2),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_isSubmitting) ...[
                  SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2, color: widget.bc.onPrimary),
                  ),
                  const SizedBox(width: 12),
                  const Text('Submitting...'),
                ] else ...[
                  const Text('Submit Rating'),
                  const SizedBox(width: 12),
                  Icon(Symbols.send, color: widget.bc.onPrimary),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        Center(
          child: TextButton(
            onPressed: () => context.go('/creator/feed'),
            child: Text(
              'Skip for now',
              style: TextStyle(
                color: widget.bc.outlineVariant,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
                fontSize: 10,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
