import 'package:flutter/material.dart';
import '../data/exercises_data.dart';
import '../models/exercise.dart';
import 'exercise_detail_screen.dart';
import 'progress_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<ExerciseCategory, List<Exercise>> grouped = {};
    for (final exercise in exercises) {
      grouped.putIfAbsent(exercise.category, () => []).add(exercise);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Serena'),
        actions: [
          IconButton(
            icon: const Icon(Icons.show_chart),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const ProgressScreen()),
              );
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          for (final category in grouped.keys) ...[
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                category.label,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            for (final exercise in grouped[category]!)
              ListTile(
                title: Text(exercise.title),
                subtitle: Text(exercise.description),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ExerciseDetailScreen(exercise: exercise),
                    ),
                  );
                },
              ),
          ],
        ],
      ),
    );
  }
}