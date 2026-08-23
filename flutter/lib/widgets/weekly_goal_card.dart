import 'package:flutter/material.dart';
import '../data/weekly_goal_manager.dart';
import '../theme/app_styles.dart';

class WeeklyGoalCard extends StatelessWidget {
  final int sessionsThisWeek;
  final int target;
  final Future<void> Function(int newTarget) onTargetChanged;

  const WeeklyGoalCard({
    super.key,
    required this.sessionsThisWeek,
    required this.target,
    required this.onTargetChanged,
  });

  Future<void> _showEditDialog(BuildContext context) async {
    int selected = target;
    final result = await showDialog<int>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Meta semanal'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('¿Cuántos días querés practicar por semana?'),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: selected > WeeklyGoalManager.minTarget
                            ? () => setDialogState(() => selected--)
                            : null,
                        icon: const Icon(Icons.remove_circle_outline),
                      ),
                      SizedBox(
                        width: 56,
                        child: Text(
                          '$selected',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ),
                      IconButton(
                        onPressed: selected < WeeklyGoalManager.maxTarget
                            ? () => setDialogState(() => selected++)
                            : null,
                        icon: const Icon(Icons.add_circle_outline),
                      ),
                    ],
                  ),
                  Text(
                    selected == 1 ? 'día por semana' : 'días por semana',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('Cancelar'),
                ),
                FilledButton(
                  onPressed: () => Navigator.of(dialogContext).pop(selected),
                  child: const Text('Guardar'),
                ),
              ],
            );
          },
        );
      },
    );
    if (result != null && result != target) {
      await onTargetChanged(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final achieved = sessionsThisWeek >= target;
    final progress = target == 0 ? 0.0 : (sessionsThisWeek / target).clamp(0.0, 1.0);
    final containerColor = achieved
        ? Theme.of(context).colorScheme.tertiaryContainer
        : Theme.of(context).colorScheme.secondaryContainer;
    final onContainerColor = achieved
        ? Theme.of(context).colorScheme.onTertiaryContainer
        : Theme.of(context).colorScheme.onSecondaryContainer;

    return Card(
      elevation: 0,
      color: containerColor,
      shape: AppStyles.cardShape(),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      achieved ? Icons.emoji_events : Icons.flag_outlined,
                      size: 20,
                      color: onContainerColor,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Meta semanal',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: onContainerColor,
                          ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => _showEditDialog(context),
                  icon: Icon(Icons.edit_outlined, size: 20, color: onContainerColor),
                  tooltip: 'Cambiar meta',
                  constraints: const BoxConstraints(),
                  padding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              achieved
                  ? '¡Meta cumplida! $sessionsThisWeek/$target días esta semana'
                  : '$sessionsThisWeek/$target días esta semana',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: onContainerColor),
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 10,
                backgroundColor: onContainerColor.withValues(alpha: 0.15),
                color: onContainerColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}