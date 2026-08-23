class ExerciseInfo {
  final String id;
  final String title;
  final String category;
  final String difficulty;

  const ExerciseInfo({
    required this.id,
    required this.title,
    required this.category,
    required this.difficulty,
  });

  factory ExerciseInfo.fromJson(Map<String, dynamic> json) {
    return ExerciseInfo(
      id: json['id'] as String,
      title: json['title'] as String,
      category: json['category'] as String,
      difficulty: json['difficulty'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'category': category,
        'difficulty': difficulty,
      };
}

class ProgressInfo {
  final String exerciseId;
  final int timesCompleted;

  const ProgressInfo({required this.exerciseId, required this.timesCompleted});

  factory ProgressInfo.fromJson(Map<String, dynamic> json) {
    return ProgressInfo(
      exerciseId: json['exercise_id'] as String,
      timesCompleted: json['times_completed'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
        'exercise_id': exerciseId,
        'times_completed': timesCompleted,
      };
}

class BlockInfo {
  final String severity;
  final String context;
  final int daysAgo;

  const BlockInfo({
    required this.severity,
    required this.context,
    required this.daysAgo,
  });

  factory BlockInfo.fromJson(Map<String, dynamic> json) {
    return BlockInfo(
      severity: json['severity'] as String,
      context: json['context'] as String,
      daysAgo: json['days_ago'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
        'severity': severity,
        'context': context,
        'days_ago': daysAgo,
      };
}

class DifficultWordInfo {
  final String word;
  final String? note;

  const DifficultWordInfo({required this.word, this.note});

  factory DifficultWordInfo.fromJson(Map<String, dynamic> json) {
    return DifficultWordInfo(
      word: json['word'] as String,
      note: json['note'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {'word': word, 'note': note};
}

class RecommendRequest {
  final List<ExerciseInfo> exercises;
  final List<ProgressInfo> progress;
  final List<BlockInfo> recentBlocks;
  final List<DifficultWordInfo> difficultWords;
  final int currentStreak;
  final int weeklySessions;
  final int weeklyTarget;

  const RecommendRequest({
    required this.exercises,
    this.progress = const [],
    this.recentBlocks = const [],
    this.difficultWords = const [],
    this.currentStreak = 0,
    this.weeklySessions = 0,
    this.weeklyTarget = 0,
  });

  factory RecommendRequest.fromJson(Map<String, dynamic> json) {
    final exercisesJson = json['exercises'] as List<dynamic>?;
    if (exercisesJson == null || exercisesJson.isEmpty) {
      throw const FormatException('El campo "exercises" es obligatorio y no puede estar vacío');
    }
    return RecommendRequest(
      exercises: exercisesJson
          .map((e) => ExerciseInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
      progress: (json['progress'] as List<dynamic>? ?? [])
          .map((e) => ProgressInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
      recentBlocks: (json['recent_blocks'] as List<dynamic>? ?? [])
          .map((e) => BlockInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
      difficultWords: (json['difficult_words'] as List<dynamic>? ?? [])
          .map((e) => DifficultWordInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
      currentStreak: json['current_streak'] as int? ?? 0,
      weeklySessions: json['weekly_sessions'] as int? ?? 0,
      weeklyTarget: json['weekly_target'] as int? ?? 0,
    );
  }
}

class RecommendResponse {
  final String recommendedExerciseId;
  final String reason;

  const RecommendResponse({required this.recommendedExerciseId, required this.reason});

  factory RecommendResponse.fromJson(Map<String, dynamic> json) {
    return RecommendResponse(
      recommendedExerciseId: json['recommended_exercise_id'] as String,
      reason: json['reason'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'recommended_exercise_id': recommendedExerciseId,
        'reason': reason,
      };
}