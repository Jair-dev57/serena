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

// PracticeSession

class PracticeSession {
  final int? id;
  final String exerciseTitle;
  final DateTime date;

  const PracticeSession({
    this.id,
    required this.exerciseTitle,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'exerciseTitle': exerciseTitle,
      'date': date.toIso8601String(),
    };
  }

  factory PracticeSession.fromMap(Map<String, dynamic> map) {
    return PracticeSession(
      id: map['id'] as int?,
      exerciseTitle: map['exerciseTitle'] as String,
      date: DateTime.parse(map['date'] as String),
    );
  }
}


//Dificult Word

class DifficultWord {
  final int? id;
  final String word;
  final DateTime dateAdded;
  final String? note;

  const DifficultWord({
    this.id,
    required this.word,
    required this.dateAdded,
    this.note,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'word': word,
      'dateAdded': dateAdded.toIso8601String(),
      'note': note,
    };
  }

  factory DifficultWord.fromMap(Map<String, dynamic> map) {
    return DifficultWord(
      id: map['id'] as int?,
      word: map['word'] as String,
      dateAdded: DateTime.parse(map['dateAdded'] as String),
      note: map['note'] as String?,
    );
  }
}


enum BlockSeverity { leve, moderado, fuerte }

extension BlockSeverityLabel on BlockSeverity {
  String get label {
    switch (this) {
      case BlockSeverity.leve:
        return 'Leve';
      case BlockSeverity.moderado:
        return 'Moderado';
      case BlockSeverity.fuerte:
        return 'Fuerte';
    }
  }
}

enum BlockContext { llamada, publico, desconocidos, conocidos, trabajoEscuela, otro }

extension BlockContextLabel on BlockContext {
  String get label {
    switch (this) {
      case BlockContext.llamada:
        return 'En llamada';
      case BlockContext.publico:
        return 'Hablando en público';
      case BlockContext.desconocidos:
        return 'Con desconocidos';
      case BlockContext.conocidos:
        return 'Con conocidos';
      case BlockContext.trabajoEscuela:
        return 'Trabajo/escuela';
      case BlockContext.otro:
        return 'Otro';
    }
  }
}

class BlockEntry {
  final int? id;
  final DateTime dateTime;
  final BlockSeverity severity;
  final BlockContext context;
  final String? note;

  const BlockEntry({
    this.id,
    required this.dateTime,
    required this.severity,
    required this.context,
    this.note,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'dateTime': dateTime.toIso8601String(),
      'severity': severity.name,
      'context': context.name,
      'note': note,
    };
  }

  factory BlockEntry.fromMap(Map<String, dynamic> map) {
    return BlockEntry(
      id: map['id'] as int?,
      dateTime: DateTime.parse(map['dateTime'] as String),
      severity: BlockSeverity.values.byName(map['severity'] as String),
      context: BlockContext.values.byName(map['context'] as String),
      note: map['note'] as String?,
    );
  }
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

class ExerciseProgress {
  final String exerciseId;
  final int timesCompleted;
  final DateTime? lastCompletedAt;

  const ExerciseProgress({
    required this.exerciseId,
    required this.timesCompleted,
    this.lastCompletedAt,
  });

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

  Map<String, dynamic> toMap() {
    return {
      'exerciseId': exerciseId,
      'timesCompleted': timesCompleted,
      'lastCompletedAt': lastCompletedAt?.toIso8601String(),
    };
  }

  factory ExerciseProgress.fromMap(Map<String, dynamic> map) {
    return ExerciseProgress(
      exerciseId: map['exerciseId'] as String,
      timesCompleted: map['timesCompleted'] as int,
      lastCompletedAt: map['lastCompletedAt'] != null
          ? DateTime.parse(map['lastCompletedAt'] as String)
          : null,
    );
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