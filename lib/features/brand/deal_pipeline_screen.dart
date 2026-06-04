import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../data/models/analytics_model.dart' show parseHexColor;
import '../../data/models/pipeline_model.dart';
import '../../providers/app_providers.dart';
import '../../theme/barter_colors.dart';
import '../../theme/responsive_extension.dart';
import '../../widgets/barter_kanban.dart';

class DealPipelineScreen extends ConsumerWidget {
  const DealPipelineScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bc = context.barter;
    final wide = context.isWide;
    final data = ref.watch(pipelineProvider);
    return Scaffold(
      backgroundColor: bc.background,
      body: data.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (PipelinePayload payload) {
          final board = _KanbanBoard(payload: payload);
          if (!wide) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _PipelineAppBar(wide: wide),
                Expanded(child: board),
              ],
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _PipelineAppBar(wide: wide),
              Expanded(child: board),
            ],
          );
        },
      ),
    );
  }
}

class _PipelineAppBar extends StatelessWidget {
  const _PipelineAppBar({required this.wide});

  final bool wide;

  @override
  Widget build(BuildContext context) {
    final bc = context.barter;
    return Material(
      color: bc.background,
      child: Padding(
        padding: EdgeInsets.fromLTRB(wide ? 48 : 20, 20, wide ? 48 : 20, 8),
        child: Row(
          children: [
            Text(
              'Deal Pipeline',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const Spacer(),
            Icon(Symbols.tune, color: bc.onSurface),
          ],
        ),
      ),
    );
  }
}

class _KanbanBoard extends StatelessWidget {
  const _KanbanBoard({required this.payload});

  final PipelinePayload payload;

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.sizeOf(context).height - 140;
    return SizedBox(
      height: h.clamp(320, 900),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        itemCount: payload.columns.length,
        itemBuilder: (context, i) {
          final col = payload.columns[i];
          final accent = parseHexColor(col.accentHex);
          return BarterKanbanColumn(
            title: col.title,
            count: col.cards.length,
            accentColor: accent,
            cards: col.cards
                .map(
                  (c) => BarterPipelineCard(
                    creatorName: c.creatorName,
                    offerTitle: c.offerTitle,
                    tags: c.tags,
                    brandInitial: c.brandInitial,
                  ),
                )
                .toList(),
          );
        },
      ),
    );
  }
}

