import 'package:flutter/material.dart';
import '../models/exercise.dart';
import '../theme/app_styles.dart';

class BlockStatsScreen extends StatelessWidget {
  final List<BlockEntry> entries;

  const BlockStatsScreen({super.key, required this.entries});

  Map<BlockSeverity, int> get _severityCounts {
    final counts = <BlockSeverity, int>{};
    for (final severity in BlockSeverity.values) {
      counts[severity] = entries.where((e) => e.severity == severity).length;
    }
    return counts;
  }

  Map<BlockContext, int> get _contextCounts {
    final counts = <BlockContext, int>{};
    for (final ctx in BlockContext.values) {
      counts[ctx] = entries.where((e) => e.context == ctx).length;
    }
    return counts;
  }

  int get _streakWithoutStrongBlocks {
    if (entries.isEmpty) return 0;

    final strongDays = entries
        .where((e) => e.severity == BlockSeverity.fuerte)
        .map((e) => DateTime(e.dateTime.year, e.dateTime.month, e.dateTime.day))
        .toSet();

    final earliestDate = entries
        .map((e) => DateTime(e.dateTime.year, e.dateTime.month, e.dateTime.day))
        .reduce((a, b) => a.isBefore(b) ? a : b);

    int streak = 0;
    DateTime cursor = DateTime.now();
    cursor = DateTime(cursor.year, cursor.month, cursor.day);

    while (!cursor.isBefore(earliestDate)) {
      if (strongDays.contains(cursor)) break;
      streak++;
      cursor = cursor.subtract(const Duration(days: 1));
    }

    return streak;
  }

  Widget _buildBar(BuildContext context, String label, int count, int total, Color color) {
    final percent = total == 0 ? 0 : ((count / total) * 100).round();
    final fraction = total == 0 ? 0.0 : count / total;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: Theme.of(context).textTheme.bodyMedium),
              Text(
                '$count · $percent%',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppStyles.barRadius),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Stack(
                  children: [
                    Container(
                      height: 10,
                      width: constraints.maxWidth,
                      color: color.withValues(alpha: 0.12),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      height: 10,
                      width: constraints.maxWidth * fraction,
                      color: color,
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard(BuildContext context, String title, List<Widget> bars) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      shape: AppStyles.cardShape(),
      child: Padding(
        padding: AppStyles.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            ...bars,
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final severityCounts = _severityCounts;
    final contextCounts = _contextCounts;
    final total = entries.length;
    final streak = _streakWithoutStrongBlocks;

    return Scaffold(
      appBar: AppBar(title: const Text('Estadísticas de bloqueos')),
      body: entries.isEmpty
          ? const Center(child: Text('Aún no hay datos suficientes.'))
          : ListView(
              padding: AppStyles.screenPadding,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Card(
                        elevation: 0,
                        color: Theme.of(context).colorScheme.primaryContainer,
                        shape: AppStyles.cardShape(),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              Text(
                                '$total',
                                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                                    ),
                              ),
                              Text(
                                'registros',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Card(
                        elevation: 0,
                        color: Colors.green.withValues(alpha: 0.15),
                        shape: AppStyles.cardShape(),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              Text(
                                '$streak',
                                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green.shade800,
                                    ),
                              ),
                              Text(
                                'días sin bloqueos fuertes',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: Colors.green.shade800,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildSectionCard(
                  context,
                  'Por severidad',
                  [
                    for (final severity in BlockSeverity.values)
                      _buildBar(
                        context,
                        severity.label,
                        severityCounts[severity] ?? 0,
                        total,
                        AppStyles.severityColor(severity),
                      ),
                  ],
                ),
                _buildSectionCard(
                  context,
                  'Por contexto',
                  [
                    for (final ctx in BlockContext.values)
                      _buildBar(
                        context,
                        ctx.label,
                        contextCounts[ctx] ?? 0,
                        total,
                        Theme.of(context).colorScheme.secondary,
                      ),
                  ],
                ),
              ],
            ),
    );
  }
}