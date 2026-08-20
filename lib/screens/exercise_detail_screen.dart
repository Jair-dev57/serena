import 'package:flutter/material.dart';
import '../models/exercise.dart';
import '../widgets/recorder_widget.dart';

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
            const SizedBox(height: 16),
            Text(
              'Pasos',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            for (final step in exercise.steps) Text('• $step'),
            const SizedBox(height: 24),
            Center(child: RecorderWidget(exerciseTitle: exercise.title)),
          ],
        ),
      ),
    );
  }
}