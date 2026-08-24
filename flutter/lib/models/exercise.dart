enum ExerciseCategory {
  respiracion,
  inicioSuave,
  ritmo,
  lectura,
}

extension ExerciseCategoryLabel on ExerciseCategory {
  String get label {
    switch (this) {
      case ExerciseCategory.respiracion:
        return 'Respiración';
      case ExerciseCategory.inicioSuave:
        return 'Inicio suave';
      case ExerciseCategory.ritmo:
        return 'Ritmo controlado';
      case ExerciseCategory.lectura:
        return 'Lectura guiada';
    }
  }
}

// ExerciseDifficulty

enum ExerciseDifficulty { principiante, intermedio, avanzado }
extension ExerciseDifficultyLabel on ExerciseDifficulty {
  String get label {
    switch (this) {
      case ExerciseDifficulty.principiante:
        return 'Principiante';
      case ExerciseDifficulty.intermedio:
        return 'Intermedio';
      case ExerciseDifficulty.avanzado:
        return 'Avanzado';
    }
  }
}

class Exercise {
  final String id;
  final String title;
  final ExerciseCategory category;
  final String description;
  final List<String> steps;
  final ExerciseDifficulty difficulty;
  final int durationMinutes;
  final List<String> tags;
  final BreathingPattern? breathingPattern;

  const Exercise({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.steps,
    required this.difficulty,
    required this.durationMinutes,
    this.tags = const [],
    this.breathingPattern,
  });
}

//Exercice Progression
enum ExerciseRank { cobre, plata, oro, platino, diamante }

extension ExerciseRankLabel on ExerciseRank {
  String get label {
    switch (this) {
      case ExerciseRank.cobre:
        return 'Cobre';
      case ExerciseRank.plata:
        return 'Plata';
      case ExerciseRank.oro:
        return 'Oro';
      case ExerciseRank.platino:
        return 'Platino';
      case ExerciseRank.diamante:
        return 'Diamante';
    }
  }
}


class BreathingPattern {
  final int inhaleSeconds;
  final int holdSeconds;
  final int exhaleSeconds;

  const BreathingPattern({
    required this.inhaleSeconds,
    this.holdSeconds = 0,
    required this.exhaleSeconds,
  });

  int get totalSeconds => inhaleSeconds + holdSeconds + exhaleSeconds;
}


// Recording

class Recording {
  final int? id;
  final String exerciseId;
  final String path;
  final DateTime dateTime;

  const Recording({
    this.id,
    required this.exerciseId,
    required this.path,
    required this.dateTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'exerciseId': exerciseId,
      'path': path,
      'dateTime': dateTime.toIso8601String(),
    };
  }

  factory Recording.fromMap(Map<String, dynamic> map) {
    return Recording(
      id: map['id'] as int?,
      exerciseId: map['exerciseId'] as String,
      path: map['path'] as String,
      dateTime: DateTime.parse(map['dateTime'] as String),
    );
  }
}


// Warmup (pre-calentamiento para situaciones difíciles)

enum WarmupStepType { cervical, lipTrill, humming, easyOnset }

class WarmupStep {
  final String title;
  final String instruction;
  final int durationSeconds;
  final WarmupStepType type;

  const WarmupStep({
    required this.title,
    required this.instruction,
    required this.durationSeconds,
    required this.type,
  });
}