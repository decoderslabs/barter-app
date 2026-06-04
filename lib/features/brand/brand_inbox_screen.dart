import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../data/models/brand_dashboard_model.dart';
import '../../providers/app_providers.dart';
import '../../theme/barter_colors.dart';
import '../../theme/responsive_extension.dart';
import '../../widgets/barter_network_image.dart';

class BrandInboxScreen extends ConsumerStatefulWidget {
  const BrandInboxScreen({super.key});

  @override
  ConsumerState<BrandInboxScreen> createState() => _BrandInboxScreenState();
}

class _BrandInboxScreenState extends ConsumerState<BrandInboxScreen> {
  String? _activeConvId;
  final _msgController = TextEditingController();

  @override
  void dispose() {
    _msgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bc = context.barter;
    final wide = context.isWide;
    final async = ref.watch(brandDiscoveryProvider);

    return Scaffold(
      backgroundColor: bc.background,
      body: async.when(
        loading: () => Center(child: CircularProgressIndicator(color: bc.primary)),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (data) {
          final convs = data.inbox.conversations;
          if (_activeConvId == null && convs.isNotEmpty) {
            _activeConvId = convs.first.id;
          }
          final active = convs.where((c) => c.id == _activeConvId).firstOrNull;

          if (wide) {
            return Row(
              children: [
                SizedBox(
                  width: 340,
                  child: _ConversationList(
                    convs: convs,
                    activeId: _activeConvId,
                    bc: bc,
                    onSelect: (id) => setState(() => _activeConvId = id),
                  ),
                ),
                VerticalDivider(width: 1, color: bc.outlineVariant.withValues(alpha: 0.15)),
                Expanded(
                  child: active != null
                      ? _ChatView(conv: active, bc: bc, controller: _msgController)
                      : Center(child: Text('Select a conversation', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: bc.onSurfaceVariant))),
                ),
              ],
            );
          }

          // Mobile: show list, tap to open chat
          if (_activeConvId != null && active != null) {
            return _ChatView(
              conv: active,
              bc: bc,
              controller: _msgController,
              onBack: () => setState(() => _activeConvId = null),
            );
          }
          return _ConversationList(
            convs: convs,
            activeId: null,
            bc: bc,
            onSelect: (id) => setState(() => _activeConvId = id),
          );
        },
      ),
    );
  }
}

// ─── Conversation List ────────────────────────────────────────────────────────

class _ConversationList extends StatelessWidget {
  const _ConversationList({
    required this.convs,
    required this.activeId,
    required this.bc,
    required this.onSelect,
  });
  final List<InboxConversation> convs;
  final String? activeId;
  final BarterColors bc;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    final wide = context.isWide;
    return Container(
      color: bc.background,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(wide ? 24 : 20, wide ? 40 : 24, wide ? 24 : 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Inbox',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('${convs.where((c) => c.unread).length} unread conversations',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: bc.onSurfaceVariant)),
                const SizedBox(height: 16),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: wide ? 12 : 0, vertical: 8),
              itemCount: convs.length,
              separatorBuilder: (_, __) => const SizedBox(height: 2),
              itemBuilder: (context, i) {
                final conv = convs[i];
                final isActive = conv.id == activeId;
                return _ConvTile(
                  conv: conv,
                  active: isActive,
                  bc: bc,
                  onTap: () => onSelect(conv.id),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ConvTile extends StatelessWidget {
  const _ConvTile({required this.conv, required this.active, required this.bc, required this.onTap});
  final InboxConversation conv;
  final bool active;
  final BarterColors bc;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: active ? bc.primary.withValues(alpha: 0.06) : Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Stack(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: bc.surfaceContainer),
                    child: ClipOval(
                      child: BarterNetworkImage(
                        url: conv.creatorAvatar,
                        fit: BoxFit.cover,
                        memCacheWidth: 96,
                        memCacheHeight: 96,
                      ),
                    ),
                  ),
                  if (conv.unread)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: bc.primary,
                          shape: BoxShape.circle,
                          border: Border.all(color: bc.background, width: 2),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(conv.creatorName,
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontWeight: conv.unread ? FontWeight.bold : FontWeight.w500,
                                )),
                        Text(conv.lastMessageTime,
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: conv.unread ? bc.primary : bc.onSurfaceVariant,
                                  fontWeight: conv.unread ? FontWeight.bold : FontWeight.normal,
                                )),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(conv.campaignTitle,
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall
                            ?.copyWith(color: bc.primary, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 2),
                    Text(conv.lastMessage,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: conv.unread ? bc.onSurface : bc.onSurfaceVariant,
                              fontWeight: conv.unread ? FontWeight.w500 : FontWeight.normal,
                            )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Chat View ────────────────────────────────────────────────────────────────

class _ChatView extends StatelessWidget {
  const _ChatView({
    required this.conv,
    required this.bc,
    required this.controller,
    this.onBack,
  });
  final InboxConversation conv;
  final BarterColors bc;
  final TextEditingController controller;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Chat header
        Container(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          decoration: BoxDecoration(
            color: bc.background,
            border: Border(bottom: BorderSide(color: bc.outlineVariant.withValues(alpha: 0.15))),
          ),
          child: Row(
            children: [
              if (onBack != null) ...[
                IconButton(
                  icon: Icon(Symbols.arrow_back, color: bc.onBackground),
                  onPressed: onBack,
                ),
              ],
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(shape: BoxShape.circle, color: bc.surfaceContainer),
                child: ClipOval(
                  child: BarterNetworkImage(
                    url: conv.creatorAvatar,
                    fit: BoxFit.cover,
                    memCacheWidth: 80,
                    memCacheHeight: 80,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(conv.creatorName,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                    Text(conv.campaignTitle,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(color: bc.primary)),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Symbols.open_in_new, color: bc.onSurfaceVariant, size: 20),
                onPressed: () => context.push('/brand/discover/${conv.creatorId}'),
                tooltip: 'View creator profile',
              ),
            ],
          ),
        ),
        // Messages
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: conv.messages.length,
            itemBuilder: (context, i) {
              final msg = conv.messages[i];
              final isBrand = msg.sender == 'brand';
              return _MessageBubble(msg: msg, isBrand: isBrand, bc: bc);
            },
          ),
        ),
        // Input bar
        Container(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          decoration: BoxDecoration(
            color: bc.background,
            border: Border(top: BorderSide(color: bc.outlineVariant.withValues(alpha: 0.15))),
          ),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: bc.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: bc.outlineVariant.withValues(alpha: 0.2)),
                  ),
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: 'Type a message…',
                      hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: bc.onSurfaceVariant),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    maxLines: null,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(color: bc.primary, shape: BoxShape.circle),
                child: IconButton(
                  icon: Icon(Symbols.send, color: bc.onPrimary, size: 20),
                  onPressed: () => controller.clear(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.msg, required this.isBrand, required this.bc});
  final InboxMessage msg;
  final bool isBrand;
  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: isBrand ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isBrand) const SizedBox(width: 4),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.68),
            child: Column(
              crossAxisAlignment: isBrand ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: isBrand ? bc.primary : bc.surfaceContainerHighest,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(18),
                      topRight: const Radius.circular(18),
                      bottomLeft: Radius.circular(isBrand ? 18 : 4),
                      bottomRight: Radius.circular(isBrand ? 4 : 18),
                    ),
                  ),
                  child: Text(
                    msg.text,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: isBrand ? bc.onPrimary : bc.onSurface,
                          height: 1.5,
                        ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(msg.time,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(color: bc.onSurfaceVariant)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
