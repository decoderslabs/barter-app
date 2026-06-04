import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../theme/barter_colors.dart';

Future<void> showMembershipGate(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const MembershipGateModal(),
  );
}

class MembershipGateModal extends StatelessWidget {
  const MembershipGateModal({super.key});

  @override
  Widget build(BuildContext context) {
    final bc = context.barter;
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
      decoration: BoxDecoration(
        color: bc.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: bc.onBackground.withValues(alpha: 0.16),
            blurRadius: 36,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48,
              height: 5,
              decoration: BoxDecoration(
                color: bc.outlineVariant,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            const SizedBox(height: 28),
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: bc.primaryFixed.withValues(alpha: 0.55),
                shape: BoxShape.circle,
              ),
              child: Icon(Symbols.workspace_premium, color: bc.primary, size: 42, fill: 1),
            ),
            const SizedBox(height: 24),
            Text(
              'Want to collab? Earn your free membership first.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    height: 1.1,
                  ),
            ),
            const SizedBox(height: 12),
            Text(
              'Create content about Barter or our partners. Get verified. Start collaborating — zero cash needed.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: bc.onSurfaceVariant,
                    height: 1.45,
                  ),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  context.push('/creator/membership/earn');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: bc.primary,
                  foregroundColor: bc.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                  elevation: 0,
                ),
                child: const Text('See the tasks'),
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Maybe later',
                style: TextStyle(color: bc.tertiary, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
