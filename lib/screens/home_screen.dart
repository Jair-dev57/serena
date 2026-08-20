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
      appBar: AppBar(title: const Text('Serena')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
              child: const Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'Serena',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.fitness_center),
              title: const Text('Ejercicios'),
              onTap: () => Navigator.of(context).pop(),
            ),
            ListTile(
              leading: const Icon(Icons.show_chart),
              title: const Text('Mi progreso'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const ProgressScreen()),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.book_outlined),
              title: const Text('Diario de bloqueos'),
              subtitle: const Text('Próximamente'),
              enabled: false,
            ),
            ListTile(
              leading: const Icon(Icons.spellcheck),
              title: const Text('Palabras difíciles'),
              subtitle: const Text('Próximamente'),
              enabled: false,
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: const Text('Ajustes'),
              subtitle: const Text('Próximamente'),
              enabled: false,
            ),
          ],
        ),
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
              Card(
                child: ListTile(
                  title: Text(exercise.title),
                  subtitle: Text(exercise.description),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ExerciseDetailScreen(exercise: exercise),
                      ),
                    );
                  },
                ),
              ),
          ],
        ],
      ),
    );
  }
}