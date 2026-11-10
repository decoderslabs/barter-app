import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../data/models/membership_model.dart';
import '../../../providers/api_providers.dart';
import '../../../providers/app_providers.dart';
import '../../../theme/barter_colors.dart';

class SubmitTaskScreen extends ConsumerStatefulWidget {
  const SubmitTaskScreen({super.key, required this.taskId});

  final String taskId;

  @override
  ConsumerState<SubmitTaskScreen> createState() => _SubmitTaskScreenState();
}

class _SubmitTaskScreenState extends ConsumerState<SubmitTaskScreen> {
  final _url = TextEditingController();
  final _note = TextEditingController();

  bool get _validUrl {
    final value = _url.text.trim();
    final re = RegExp(r'^https?:\/\/(www\.)?(instagram\.com|tiktok\.com)\/.+', caseSensitive: false);
    return re.hasMatch(value);
  }

  @override
  void dispose() {
    _url.dispose();
    _note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bc = context.barter;
    final membership = ref.watch(membershipProvider);
    return Scaffold(
      backgroundColor: bc.background,
      appBar: AppBar(
        backgroundColor: bc.background,
        leading: IconButton(
          icon: Icon(Symbols.arrow_back, color: bc.onBackground),
          onPressed: () => context.pop(),
        ),
        title: const Text('Submit Task'),
      ),
      body: membership.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (payload) {
          final task = payload.tasks.firstWhere(
            (task) => task.id == widget.taskId,
            orElse: () => payload.tasks.first,
          );
          return _buildBody(context, bc, task);
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, BarterColors bc, MembershipTask task) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: bc.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: bc.primaryFixed,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(Symbols.workspace_premium, color: bc.primary, fill: 1),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(task.title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900)),
                      Text('${task.points} points • ${task.platform}', style: TextStyle(color: bc.onSurfaceVariant)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Text('Paste live post URL', style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 10),
          TextField(
            controller: _url,
            onChanged: (_) => setState(() {}),
            keyboardType: TextInputType.url,
            decoration: InputDecoration(
              hintText: 'https://www.instagram.com/reel/...',
              prefixIcon: Icon(Symbols.link, color: bc.primary),
              filled: true,
              fillColor: bc.surfaceContainerLow,
              errorText: _url.text.isEmpty || _validUrl ? null : 'Enter a valid Instagram or TikTok URL',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text('Reviewer note', style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 10),
          TextField(
            controller: _note,
            minLines: 4,
            maxLines: 6,
            decoration: InputDecoration(
              hintText: 'Optional: add context for the Barter team...',
              filled: true,
              fillColor: bc.surfaceContainerLow,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _validUrl ? () => _submit(context, bc) : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: bc.primary,
                foregroundColor: bc.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
              ),
              child: const Text('Confirm submission'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submit(BuildContext context, BarterColors bc) async {
    final repo = ref.read(membershipRepositoryProvider);
    final postUrl = _url.text.trim();
    try {
      await repo.submitTask(
        taskId: widget.taskId,
        postUrl: postUrl,
        note: _note.text.trim(),
      );
      ref.invalidate(membershipProvider);
      if (!context.mounted) return;
      context.go(
        '/creator/membership/pending?url=${Uri.encodeComponent(postUrl)}',
      );
    } catch (e) {
      if (!context.mounted) return;
      _handleError(context, e);
    }
  }

  void _handleError(BuildContext context, Object e) {
    String msg = e.toString();
    VoidCallback? action;
    String? actionLabel;

    if (e is Exception) {
      final inner = e is Error ? null : e;
      final str = inner?.toString() ?? '';
      if (str.contains('profile_incomplete')) {
        msg = 'Complete your profile to 80% first.';
        action = () => context.go('/creator/onboarding/complete');
        actionLabel = 'Complete Profile';
      } else if (str.contains('membership_required')) {
        msg = 'You need an approved membership task.';
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        action: action != null && actionLabel != null
            ? SnackBarAction(label: actionLabel, onPressed: action)
            : null,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showSubmitted(BuildContext context, BarterColors bc) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: bc.surfaceContainerLowest,
        title: const Text("Submitted! We'll review within 48 hours."),
        content: const Text('You can now apply to deals while your membership is pending verification.'),
        actions: [
          TextButton(
            onPressed: () => context.go('/creator/feed'),
            child: const Text('Back to Feed'),
          ),
          ElevatedButton(
            onPressed: () => context.go('/creator/inbox'),
            child: const Text('View Proposals'),
          ),
        ],
      ),
    );
  }
}
