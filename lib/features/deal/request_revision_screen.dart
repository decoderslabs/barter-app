import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../core/routing/deal_route.dart';
import '../../providers/api_providers.dart';
import '../../theme/barter_colors.dart';

class RequestRevisionScreen extends ConsumerStatefulWidget {
  const RequestRevisionScreen({super.key});

  @override
  ConsumerState<RequestRevisionScreen> createState() => _RequestRevisionScreenState();
}

class _RequestRevisionScreenState extends ConsumerState<RequestRevisionScreen> {
  final TextEditingController _notesController = TextEditingController();
  int _characterCount = 0;
  static const int _maxLength = 300;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bc = context.barter;
    return Scaffold(
      backgroundColor: bc.background,
      appBar: AppBar(
        backgroundColor: bc.background,
        leading: IconButton(
          icon: Icon(Symbols.arrow_back, color: bc.primary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Deal Room',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        actions: [
          IconButton(
            icon: Icon(Symbols.more_vert, color: bc.onSurfaceVariant.withValues(alpha: 0.6)),
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
            RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                children: [
                  const TextSpan(text: 'Refine'),
                  const TextSpan(text: ' '),
                  TextSpan(
                    text: 'the Vision',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: bc.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Provide specific feedback to align the deliverable with your brand\'s editorial standards.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: bc.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 32),
            _RevisionCard(
              bc: bc,
              onSend: (reason) async {
                final dealId = dealIdFromRoute(context);
                if (dealId != null) {
                  await ref
                      .read(dealRepositoryProvider)
                      .requestRevision(dealId, reason);
                }
                if (context.mounted) context.pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _RevisionCard extends StatelessWidget {
  const _RevisionCard({required this.bc, required this.onSend});

  final BarterColors bc;
  final Future<void> Function(String reason) onSend;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: bc.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: bc.onBackground.withValues(alpha: 0.04),
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Status',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: bc.onSurfaceVariant.withValues(alpha: 0.6),
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                          fontSize: 10,
                        ),
                  ),
                  const SizedBox(height: 4),
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
                        'Action Required',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Quota',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: bc.onSurfaceVariant.withValues(alpha: 0.6),
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                          fontSize: 10,
                        ),
                  ),
                  const SizedBox(height: 4),
                  RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      children: [
                        const TextSpan(text: '1 of 2 '),
                        TextSpan(
                          text: 'Remains',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: bc.onSurfaceVariant.withValues(alpha: 0.4),
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32),
          _RevisionNotesForm(bc: bc, onSend: onSend),
        ],
      ),
    );
  }
}

class _RevisionNotesForm extends StatefulWidget {
  const _RevisionNotesForm({required this.bc, required this.onSend});

  final BarterColors bc;
  final Future<void> Function(String reason) onSend;

  @override
  State<_RevisionNotesForm> createState() => _RevisionNotesFormState();
}

class _RevisionNotesFormState extends State<_RevisionNotesForm> {
  final TextEditingController _controller = TextEditingController();
  int _charCount = 0;
  static const int _maxLength = 300;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Revision Notes',
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
                color: widget.bc.onSurfaceVariant,
              ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: widget.bc.surfaceContainerLow,
            borderRadius: BorderRadius.circular(16),
          ),
          child: TextField(
            controller: _controller,
            maxLines: 6,
            maxLength: _maxLength,
            onChanged: (value) {
              setState(() {
                _charCount = value.length;
              });
            },
            decoration: InputDecoration(
              hintText: 'Explain the adjustments needed...',
              hintStyle: TextStyle(
                color: widget.bc.onSurfaceVariant.withValues(alpha: 0.3),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(20),
              counterText: '',
            ),
          ),
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            '$_charCount / $_maxLength',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: widget.bc.onSurfaceVariant.withValues(alpha: 0.4),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  fontSize: 10,
                ),
          ),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: widget.bc.surfaceContainerLow.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Icon(Symbols.lightbulb, color: widget.bc.tertiary, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text.rich(
                  TextSpan(
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: widget.bc.onSurfaceVariant,
                        ),
                    children: [
                      TextSpan(
                        text: 'Pro-Tip: ',
                        style: TextStyle(
                          color: widget.bc.tertiary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const TextSpan(text: 'High-quality feedback includes timestamps or specific visual references.'),
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
            onPressed: () => widget.onSend(_controller.text.trim()),
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.bc.primary,
              foregroundColor: widget.bc.onPrimary,
              padding: const EdgeInsets.symmetric(vertical: 20),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
              elevation: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Send Request'),
                const SizedBox(width: 12),
                Icon(Symbols.send, color: widget.bc.onPrimary),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: TextButton(
            onPressed: () => context.pop(),
            child: Text(
              'Cancel & Return',
              style: TextStyle(
                color: widget.bc.onSurfaceVariant.withValues(alpha: 0.6),
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
