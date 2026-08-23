import 'package:serena_poc_client/serena_poc_client.dart' show ExerciseProgress;
import '../models/exercise.dart' show ExerciseRank;

extension ExerciseProgressRank on ExerciseProgress {
  ExerciseRank get rank {
    if (timesCompleted >= 15) return ExerciseRank.diamante;
    if (timesCompleted >= 10) return ExerciseRank.platino;
    if (timesCompleted >= 6) return ExerciseRank.oro;
    if (timesCompleted >= 3) return ExerciseRank.plata;
    return ExerciseRank.cobre;
  }

  int get repsToNextRank {
    if (timesCompleted >= 15) return 0;
    if (timesCompleted >= 10) return 15 - timesCompleted;
    if (timesCompleted >= 6) return 10 - timesCompleted;
    if (timesCompleted >= 3) return 6 - timesCompleted;
    return 3 - timesCompleted;
  }
}