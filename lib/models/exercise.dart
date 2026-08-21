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

class Exercise {
  final String title;
  final ExerciseCategory category;
  final String description;
  final List<String> steps;

  const Exercise({
    required this.title,
    required this.category,
    required this.description,
    required this.steps,
  });
}


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