import 'package:serena_client/serena_client.dart' as server;
import 'server_client.dart';
import '../models/exercise.dart';

class ExercisesRepository {
  static List<Exercise>? _cache;

  static Future<List<Exercise>> load() async {
    if (_cache != null) return _cache!;
    final serverExercises = await ServerClient.instance.exercise.getAllExercises();
    _cache = serverExercises.map(_toLocal).toList();
    return _cache!;
  }

  static Exercise _toLocal(server.Exercise e) {
    return Exercise(
      id: e.exerciseKey,
      title: e.title,
      category: ExerciseCategory.values.byName(e.category.name),
      description: e.description,
      steps: e.steps,
      difficulty: ExerciseDifficulty.values.byName(e.difficulty.name),
      durationMinutes: e.durationMinutes,
      tags: e.tags,
      breathingPattern: e.breathingPattern != null
          ? BreathingPattern(
              inhaleSeconds: e.breathingPattern!.inhaleSeconds,
              holdSeconds: e.breathingPattern!.holdSeconds,
              exhaleSeconds: e.breathingPattern!.exhaleSeconds,
            )
          : null,
    );
  }
}