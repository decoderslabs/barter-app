import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../theme/barter_colors.dart';

class BarterValueEngineScreen extends StatefulWidget {
  const BarterValueEngineScreen({super.key});

  @override
  State<BarterValueEngineScreen> createState() => _BarterValueEngineScreenState();
}

class _BarterValueEngineScreenState extends State<BarterValueEngineScreen> {
  final _valueController = TextEditingController();
  final _contentController = TextEditingController();
  double _progressValue = 42 / 100;

  @override
  void dispose() {
    _valueController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bc = context.barter;

    return Scaffold(
      backgroundColor: bc.background,
      appBar: AppBar(
        backgroundColor: bc.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Symbols.close, color: bc.primary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'CREATE OFFER',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: bc.primary,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                fontSize: 12,
              ),
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: Text(
              'SAVE',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: bc.primary,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    fontSize: 12,
                  ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ProgressHeader(progress: _progressValue),
            const SizedBox(height: 48),
            _StepHeader(),
            const SizedBox(height: 32),
            _InputsSection(
              valueController: _valueController,
              contentController: _contentController,
            ),
            const SizedBox(height: 64),
            _ValueEnginePanel(),
            const SizedBox(height: 64),
            _NavigationButtons(),
          ],
        ),
      ),
    );
  }
}

class _ProgressHeader extends StatelessWidget {
  const _ProgressHeader({required this.progress});
  final double progress;

  @override
  Widget build(BuildContext context) {
    final bc = context.barter;
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: -3,
                      height: 1,
                      color: bc.onBackground,
                    ),
                children: [
                  const TextSpan(text: '03'),
                  TextSpan(text: '/', style: TextStyle(color: bc.primary)),
                  const TextSpan(text: '07'),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                'VALUE & DELIVERABLES',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: bc.onSurfaceVariant,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      fontSize: 10,
                    ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: bc.surfaceContainerHighest,
            color: bc.primary,
            minHeight: 4,
          ),
        ),
      ],
    );
  }
}

class _StepHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bc = context.barter;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: -1,
                  color: bc.onBackground,
                ),
            children: [
              const TextSpan(text: "What's the "),
              TextSpan(
                text: 'Value',
                style: TextStyle(color: bc.primary, fontStyle: FontStyle.italic),
              ),
              const TextSpan(text: ' of this exchange?'),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Define your product worth and exactly what you expect back from the creator.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: bc.onSurfaceVariant,
              ),
        ),
      ],
    );
  }
}

class _InputsSection extends StatelessWidget {
  const _InputsSection({
    required this.valueController,
    required this.contentController,
  });

  final TextEditingController valueController;
  final TextEditingController contentController;

  @override
  Widget build(BuildContext context) {
    final bc = context.barter;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ESTIMATED OFFER VALUE',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: bc.onSurfaceVariant,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
                fontSize: 10,
              ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: bc.surfaceContainerLow,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(
                      color: bc.outlineVariant.withValues(alpha: 0.3),
                    ),
                  ),
                ),
                child: Text(
                  'INR',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              Expanded(
                child: TextField(
                  controller: valueController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                  decoration: InputDecoration(
                    hintText: '3,500',
                    hintStyle: TextStyle(color: bc.onSurfaceVariant.withValues(alpha: 0.4)),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Include retail price of products + shipping costs.',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: bc.onSurfaceVariant,
                fontStyle: FontStyle.italic,
              ),
        ),
        const SizedBox(height: 32),
        Text(
          'CONTENT ASK',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: bc.onSurfaceVariant,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
                fontSize: 10,
              ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: bc.surfaceContainerLow,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: contentController,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                  decoration: InputDecoration(
                    hintText: 'e.g. 1x Instagram Reel',
                    hintStyle: TextStyle(color: bc.onSurfaceVariant.withValues(alpha: 0.4)),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Icon(Symbols.edit_note, color: bc.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ValueEnginePanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bc = context.barter;
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: bc.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: bc.onBackground.withValues(alpha: 0.06),
            blurRadius: 80,
            offset: const Offset(0, 40),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: -48,
            right: -48,
            child: Container(
              width: 128,
              height: 128,
              decoration: BoxDecoration(
                color: bc.primary.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Symbols.auto_awesome, color: bc.primary, size: 22, fill: 1),
                  const SizedBox(width: 8),
                  Text(
                    'BARTER VALUE ENGINE',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: bc.primary,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 3,
                          fontSize: 10,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: bc.onBackground,
                        height: 1.5,
                      ),
                  children: [
                    const TextSpan(text: 'For a '),
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                        color: bc.primaryFixed,
                        child: Text(
                          '₹3,500',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: bc.onPrimaryFixed,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ),
                    const TextSpan(
                        text:
                            ' product bundle asking for 1 Instagram Reel, you can expect creators with '),
                    TextSpan(
                      text: '5K–30K',
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                    const TextSpan(text: ' followers and '),
                    TextSpan(
                      text: '4%+',
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                    const TextSpan(text: ' engagement.'),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: bc.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(16),
                  border: Border(
                    left: BorderSide(
                      color: bc.primary.withValues(alpha: 0.2),
                      width: 4,
                    ),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Symbols.lightbulb, color: bc.tertiary, size: 20),
                    const SizedBox(width: 16),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: bc.onSurfaceVariant,
                                fontStyle: FontStyle.italic,
                              ),
                          children: [
                            const TextSpan(text: '"Asking for '),
                            TextSpan(
                              text: '2 Reels',
                              style: TextStyle(
                                color: bc.onBackground,
                                fontWeight: FontWeight.w600,
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                            const TextSpan(text: ' would be a strong match for '),
                            TextSpan(
                              text: '20K–80K',
                              style: TextStyle(
                                color: bc.onBackground,
                                fontWeight: FontWeight.w600,
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                            const TextSpan(text: ' creators."'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Opacity(
                opacity: 0.6,
                child: Row(
                  children: [
                    Icon(Symbols.info, size: 14, color: bc.onSurfaceVariant),
                    const SizedBox(width: 8),
                    Text(
                      'DATA-BACKED SUGGESTION • NOT A REQUIREMENT',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: bc.onSurfaceVariant,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                            fontSize: 9,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NavigationButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bc = context.barter;
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => context.pop(),
            style: OutlinedButton.styleFrom(
              foregroundColor: bc.onSurfaceVariant,
              padding: const EdgeInsets.symmetric(vertical: 20),
              side: BorderSide.none,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
              textStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
            ),
            child: const Text('BACK'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 2,
          child: ElevatedButton.icon(
            onPressed: () => context.go('/brand/dashboard'),
            icon: const Icon(Symbols.arrow_forward, size: 20),
            label: const Text('CONTINUE'),
            style: ElevatedButton.styleFrom(
              backgroundColor: bc.primary,
              foregroundColor: bc.onPrimary,
              padding: const EdgeInsets.symmetric(vertical: 20),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
              elevation: 4,
              shadowColor: bc.primary.withValues(alpha: 0.2),
              textStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
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
