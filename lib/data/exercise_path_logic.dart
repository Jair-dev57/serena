import '../models/exercise.dart';

class ExercisePathLogic {
  /// Ejercicios de una categoría, en el orden fijo de la ruta (por dificultad).
  static List<Exercise> exercisesForCategory(
    List<Exercise> allExercises,
    ExerciseCategory category,
  ) {
    final list = allExercises.where((e) => e.category == category).toList();
    list.sort((a, b) => a.difficulty.index.compareTo(b.difficulty.index));
    return list;
  }

  /// true si el ejercicio ya se completó al menos 1 vez (rango Cobre o más).
  static bool isUnlocked(
    Exercise exercise,
    List<Exercise> categoryExercises,
    Map<String, ExerciseProgress> progressById,
  ) {
    final index = categoryExercises.indexWhere((e) => e.id == exercise.id);
    if (index == 0) return true; // el primero de la sección siempre está abierto
    final previous = categoryExercises[index - 1];
    final previousProgress = progressById[previous.id];
    return previousProgress != null && previousProgress.timesCompleted >= 1;
  }

  /// true si TODOS los ejercicios de una sección están al menos en Cobre.
  static bool isCategoryCompleted(
    List<Exercise> categoryExercises,
    Map<String, ExerciseProgress> progressById,
  ) {
    return categoryExercises.every((e) {
      final progress = progressById[e.id];
      return progress != null && progress.timesCompleted >= 1;
    });
  }

  /// true si la sección completa está desbloqueada (la anterior ya se completó, o es la primera).
  static bool isCategoryUnlocked(
    ExerciseCategory category,
    List<ExerciseCategory> orderedCategories,
    Map<ExerciseCategory, List<Exercise>> exercisesByCategory,
    Map<String, ExerciseProgress> progressById,
  ) {
    final index = orderedCategories.indexOf(category);
    if (index == 0) return true;
    final previousCategory = orderedCategories[index - 1];
    final previousExercises = exercisesByCategory[previousCategory] ?? [];
    return isCategoryCompleted(previousExercises, progressById);
  }

  /// El primer ejercicio desbloqueado que aún no se ha completado ninguna vez,
  /// recorriendo las categorías en orden. Si todo está completado, devuelve null.
  static Exercise? nextRecommendedExercise(
    List<Exercise> allExercises,
    List<ExerciseCategory> orderedCategories,
    Map<String, ExerciseProgress> progressById,
  ) {
    for (final category in orderedCategories) {
      final categoryExercises = exercisesForCategory(allExercises, category);
      for (final exercise in categoryExercises) {
        final unlocked = isUnlocked(exercise, categoryExercises, progressById);
        if (!unlocked) break; // el resto de la sección tampoco está desbloqueado
        final progress = progressById[exercise.id];
        final completed = progress != null && progress.timesCompleted >= 1;
        if (!completed) return exercise;
      }
    }
    return null; // todo completado
  }
}