import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../theme/barter_colors.dart';
import '../../widgets/barter_appbar.dart';
import '../../widgets/barter_card.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  final Map<String, bool> _pushNotifications = {
    'New Proposals': true,
    'Proposal Accepted/Declined': true,
    'Counter-Offers': true,
    'Deal Room Messages': true,
    'Content Delivered': true,
    'Revision Requests': false,
    'Deal Completed': true,
    'Ratings & Reviews': true,
  };

  final Map<String, bool> _deadlines = {
    '3 Days Before': true,
    '24 Hours Before': true,
  };

  final Map<String, bool> _emailAlerts = {
    'Weekly Digest': true,
    'Marketing & Insights': false,
  };

  @override
  Widget build(BuildContext context) {
    final bc = context.barter;
    return Scaffold(
      backgroundColor: bc.background,
      appBar: BarterAppBar(
        showBrandTitle: false,
        title: 'Notification Settings',
        leading: BarterBackButton(color: bc.primary),
        actions: [
          IconButton(
            icon: Icon(Symbols.notifications, color: bc.primary),
            onPressed: () => context.pop(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _HeroSection(bc: bc),
            const SizedBox(height: 32),
            _PushNotificationsSection(bc: bc),
            const SizedBox(height: 32),
            _DeadlinesSection(bc: bc),
            const SizedBox(height: 32),
            _EmailAlertsSection(bc: bc),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection({required this.bc});

  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  height: 1.1,
                ),
            children: [
              const TextSpan(text: 'YOUR\n'),
              TextSpan(text: 'PULSE.', style: TextStyle(color: bc.primary)),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Define how the exchange speaks to you. High-frequency updates or curated digests.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: bc.onSurfaceVariant.withValues(alpha: 0.7),
              ),
        ),
      ],
    );
  }
}

class _PushNotificationsSection extends StatelessWidget {
  const _PushNotificationsSection({required this.bc});

  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Push Notifications',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: bc.primary,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
            ),
            Icon(Symbols.sensors, color: bc.primaryFixedDim),
          ],
        ),
        const SizedBox(height: 24),
        _NotificationToggle(
          label: 'New Proposals',
          description: 'Alert when creators pitch a barter',
          value: true,
          onChanged: (_) {},
          bc: bc,
        ),
        const SizedBox(height: 16),
        _NotificationToggle(
          label: 'Proposal Accepted/Declined',
          description: 'Immediate status of sent offers',
          value: true,
          onChanged: (_) {},
          bc: bc,
        ),
        const SizedBox(height: 16),
        _NotificationToggle(
          label: 'Counter-Offers',
          description: 'When negotiations shift',
          value: true,
          onChanged: (_) {},
          bc: bc,
        ),
        const SizedBox(height: 16),
        _NotificationToggle(
          label: 'Deal Room Messages',
          description: 'Real-time collaboration alerts',
          value: true,
          onChanged: (_) {},
          bc: bc,
        ),
        Container(
          height: 4,
          margin: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: bc.surfaceContainerHighest.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(height: 16),
        _NotificationToggle(
          label: 'Content Delivered',
          description: 'Assets are ready for review',
          value: true,
          onChanged: (_) {},
          bc: bc,
        ),
        const SizedBox(height: 16),
        _NotificationToggle(
          label: 'Revision Requests',
          description: 'Feedback required on submissions',
          value: false,
          onChanged: (_) {},
          bc: bc,
        ),
        const SizedBox(height: 16),
        _NotificationToggle(
          label: 'Deal Completed',
          description: 'Final closure of the barter loop',
          value: true,
          onChanged: (_) {},
          bc: bc,
        ),
        const SizedBox(height: 16),
        _NotificationToggle(
          label: 'Ratings & Reviews',
          description: 'When your profile receives feedback',
          value: true,
          onChanged: (_) {},
          bc: bc,
        ),
      ],
    );
  }
}

class _DeadlinesSection extends StatelessWidget {
  const _DeadlinesSection({required this.bc});

  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return BarterCard(
      borderRadius: 32,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Symbols.schedule, color: bc.primary),
              const SizedBox(width: 12),
              Text(
                'Deadlines',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _DeadlineToggle(
            label: '3 Days Before',
            value: true,
            onChanged: (_) {},
            bc: bc,
          ),
          const SizedBox(height: 16),
          _DeadlineToggle(
            label: '24 Hours Before',
            value: true,
            onChanged: (_) {},
            bc: bc,
          ),
        ],
      ),
    );
  }
}

class _EmailAlertsSection extends StatelessWidget {
  const _EmailAlertsSection({required this.bc});

  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Email Alerts',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: bc.primary,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
            ),
            Icon(Symbols.mail, color: bc.primaryFixedDim),
          ],
        ),
        const SizedBox(height: 24),
        _EmailToggle(
          label: 'Weekly Digest',
          description: 'A curated summary of your exchange activity',
          value: true,
          onChanged: (_) {},
          bc: bc,
        ),
        const SizedBox(height: 16),
        _EmailToggle(
          label: 'Marketing & Insights',
          description: 'Tips to improve your barter success rate',
          value: false,
          onChanged: (_) {},
          bc: bc,
        ),
      ],
    );
  }
}

class _NotificationToggle extends StatelessWidget {
  const _NotificationToggle({
    required this.label,
    required this.description,
    required this.value,
    required this.onChanged,
    required this.bc,
  });

  final String label;
  final String description;
  final bool value;
  final ValueChanged<bool?> onChanged;
  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return BarterCard(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: bc.onSurfaceVariant.withValues(alpha: 0.6),
                      ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: bc.primary,
            activeTrackColor: bc.primary.withValues(alpha: 0.4),
          ),
        ],
      ),
    );
  }
}

class _DeadlineToggle extends StatelessWidget {
  const _DeadlineToggle({
    required this.label,
    required this.value,
    required this.onChanged,
    required this.bc,
  });

  final String label;
  final bool value;
  final ValueChanged<bool?> onChanged;
  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
        Checkbox(
          value: value,
          onChanged: onChanged,
          fillColor: WidgetStateProperty.all(bc.primary),
        ),
      ],
    );
  }
}

class _EmailToggle extends StatelessWidget {
  const _EmailToggle({
    required this.label,
    required this.description,
    required this.value,
    required this.onChanged,
    required this.bc,
  });

  final String label;
  final String description;
  final bool value;
  final ValueChanged<bool?> onChanged;
  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return BarterCard(
      padding: const EdgeInsets.all(20),
      backgroundColor: bc.surfaceContainerLowest,
      borderColor: bc.outlineVariant.withValues(alpha: 0.1),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: bc.onSurfaceVariant.withValues(alpha: 0.6),
                      ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: bc.primary,
            activeTrackColor: bc.primary.withValues(alpha: 0.4),
          ),
        ],
      ),
    );
  }
}
