import 'package:flutter/material.dart';
import '../models/exercise.dart';
import '../widgets/recorder_widget.dart';
import '../widgets/metronome_widget.dart';

class ExerciseDetailScreen extends StatelessWidget {
  final Exercise exercise;
  const ExerciseDetailScreen({super.key, required this.exercise});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(exercise.title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(exercise.description),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [
                Chip(
                  label: Text(exercise.difficulty.label),
                  avatar: const Icon(Icons.bar_chart, size: 18),
                ),
                Chip(
                  label: Text('${exercise.durationMinutes} min'),
                  avatar: const Icon(Icons.timer_outlined, size: 18),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Pasos',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            for (final step in exercise.steps) Text('• $step'),
            const SizedBox(height: 24),
            if (exercise.id == 'ritmo_controlado')
              const Center(child: MetronomeWidget()),
            Center(child: RecorderWidget(exerciseTitle: exercise.title)),
          ],
        ),
      ),
    );
  }
}