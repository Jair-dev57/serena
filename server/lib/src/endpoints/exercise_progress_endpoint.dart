import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class ExerciseProgressEndpoint extends Endpoint {
  Future<List<ExerciseProgress>> getAllProgress(Session session) async {
    return ExerciseProgress.db.find(session);
  }

  Future<ExerciseProgress?> getProgressForExercise(
    Session session,
    String exerciseId,
  ) async {
    return ExerciseProgress.db.findFirstRow(
      session,
      where: (t) => t.exerciseId.equals(exerciseId),
    );
  }

  Future<ExerciseProgress> incrementProgress(
    Session session,
    String exerciseId,
  ) async {
    final existing = await getProgressForExercise(session, exerciseId);
    if (existing == null) {
      final newProgress = ExerciseProgress(
        exerciseId: exerciseId,
        timesCompleted: 1,
        lastCompletedAt: DateTime.now(),
      );
      return ExerciseProgress.db.insertRow(session, newProgress);
    }
    final updated = existing.copyWith(
      timesCompleted: existing.timesCompleted + 1,
      lastCompletedAt: DateTime.now(),
    );
    return ExerciseProgress.db.updateRow(session, updated);
  }
}