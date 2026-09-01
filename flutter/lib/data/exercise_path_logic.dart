import 'package:serena_client/serena_client.dart'
    show ExerciseProgress, BlockEntry, BlockSeverity;
import '../models/exercise.dart';

class ExercisePathLogic {
  static List<Exercise> exercisesForCategory(
    List<Exercise> allExercises,
    ExerciseCategory category,
  ) {
    final list = allExercises.where((e) => e.category == category).toList();
    list.sort((a, b) => a.difficulty.index.compareTo(b.difficulty.index));
    return list;
  }

  /// Todos los ejercicios están disponibles: el usuario puede practicar
  /// cualquiera, sin importar su progreso previo (a pedido explícito).
  static bool isUnlocked(
    Exercise exercise,
    List<Exercise> categoryExercises,
    Map<String, ExerciseProgress> progressById,
  ) {
    return true;
  }

  static bool isCategoryCompleted(
    List<Exercise> categoryExercises,
    Map<String, ExerciseProgress> progressById,
  ) {
    return categoryExercises.every((e) {
      final progress = progressById[e.id];
      return progress != null && progress.timesCompleted >= 1;
    });
  }

  /// Todas las categorías están disponibles, sin restricción de orden
  /// (a pedido explícito).
  static bool isCategoryUnlocked(
    ExerciseCategory category,
    List<ExerciseCategory> orderedCategories,
    Map<ExerciseCategory, List<Exercise>> exercisesByCategory,
    Map<String, ExerciseProgress> progressById,
  ) {
    return true;
  }

  static Exercise? nextRecommendedExercise(
    List<Exercise> allExercises,
    List<ExerciseCategory> orderedCategories,
    Map<String, ExerciseProgress> progressById,
  ) {
    for (final category in orderedCategories) {
      final categoryExercises = exercisesForCategory(allExercises, category);
      for (final exercise in categoryExercises) {
        final unlocked = isUnlocked(exercise, categoryExercises, progressById);
        if (!unlocked) break;
        final progress = progressById[exercise.id];
        final completed = progress != null && progress.timesCompleted >= 1;
        if (!completed) return exercise;
      }
    }
    return null;
  }

  static bool hasRecentStrongBlock(List<BlockEntry> blockEntries, {int days = 3}) {
    final cutoff = DateTime.now().subtract(Duration(days: days));
    return blockEntries.any(
      (e) => e.severity == BlockSeverity.fuerte && e.dateTime.isAfter(cutoff),
    );
  }
}