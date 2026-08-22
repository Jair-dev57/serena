import 'package:flutter/material.dart';
import '../data/exercises_data.dart';
import '../data/favorites_manager.dart';
import '../models/exercise.dart';
import 'guided_exercise_screen.dart';
import 'progress_screen.dart';
import 'difficult_words_screen.dart';
import 'block_diary_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Set<String> _favoriteIds = {};

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final favorites = await FavoritesManager.getFavorites();
    setState(() {
      _favoriteIds = favorites;
    });
  }

  Future<void> _toggleFavorite(String exerciseId) async {
    await FavoritesManager.toggleFavorite(exerciseId);
    _loadFavorites();
  }

  Color _difficultyColor(ExerciseDifficulty difficulty) {
    switch (difficulty) {
      case ExerciseDifficulty.principiante:
        return Colors.green;
      case ExerciseDifficulty.intermedio:
        return Colors.amber.shade700;
      case ExerciseDifficulty.avanzado:
        return Colors.red;
    }
  }

  Widget _buildExerciseCard(Exercise exercise) {
    final isFavorite = _favoriteIds.contains(exercise.id);
    return Card(
      child: ListTile(
        title: Text(exercise.title),
        subtitle: Text(exercise.description),
        leading: CircleAvatar(
          backgroundColor: _difficultyColor(exercise.difficulty).withValues(alpha: 0.15),
          child: Text(
            exercise.difficulty.label[0],
            style: TextStyle(
              color: _difficultyColor(exercise.difficulty),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        trailing: IconButton(
          icon: Icon(
            isFavorite ? Icons.star : Icons.star_border,
            color: isFavorite ? Colors.amber : null,
          ),
          onPressed: () => _toggleFavorite(exercise.id),
        ),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => GuidedExerciseScreen(exercise: exercise),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Map<ExerciseCategory, List<Exercise>> grouped = {};
    for (final exercise in exercises) {
      grouped.putIfAbsent(exercise.category, () => []).add(exercise);
    }

    final favoriteExercises = exercises.where((e) => _favoriteIds.contains(e.id)).toList();

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
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const BlockDiaryScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.spellcheck),
              title: const Text('Palabras difíciles'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const DifficultWordsScreen()),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: const Text('Ajustes'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const SettingsScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: ListView(
        children: [
          if (favoriteExercises.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 20),
                  const SizedBox(width: 6),
                  Text(
                    'Favoritos',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
            ),
            for (final exercise in favoriteExercises) _buildExerciseCard(exercise),
            const Divider(height: 32),
          ],
          for (final category in grouped.keys) ...[
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                category.label,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            for (final exercise in grouped[category]!) _buildExerciseCard(exercise),
          ],
        ],
      ),
    );
  }
}