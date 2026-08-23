/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import '../exercise/exercise_category.dart' as _i2;
import '../exercise/exercise_difficulty.dart' as _i3;
import '../exercise/breathing_pattern.dart' as _i4;
import 'package:serena_poc_client/src/protocol/protocol.dart' as _i5;

abstract class Exercise implements _i1.SerializableModel {
  Exercise._({
    this.id,
    required this.exerciseKey,
    required this.title,
    required this.category,
    required this.description,
    required this.steps,
    required this.difficulty,
    required this.durationMinutes,
    required this.tags,
    this.breathingPattern,
  });

  factory Exercise({
    int? id,
    required String exerciseKey,
    required String title,
    required _i2.ExerciseCategory category,
    required String description,
    required List<String> steps,
    required _i3.ExerciseDifficulty difficulty,
    required int durationMinutes,
    required List<String> tags,
    _i4.BreathingPattern? breathingPattern,
  }) = _ExerciseImpl;

  factory Exercise.fromJson(Map<String, dynamic> jsonSerialization) {
    return Exercise(
      id: jsonSerialization['id'] as int?,
      exerciseKey: jsonSerialization['exerciseKey'] as String,
      title: jsonSerialization['title'] as String,
      category: _i2.ExerciseCategory.fromJson(
        (jsonSerialization['category'] as String),
      ),
      description: jsonSerialization['description'] as String,
      steps: _i5.Protocol().deserialize<List<String>>(
        jsonSerialization['steps'],
      ),
      difficulty: _i3.ExerciseDifficulty.fromJson(
        (jsonSerialization['difficulty'] as String),
      ),
      durationMinutes: jsonSerialization['durationMinutes'] as int,
      tags: _i5.Protocol().deserialize<List<String>>(jsonSerialization['tags']),
      breathingPattern: jsonSerialization['breathingPattern'] == null
          ? null
          : _i5.Protocol().deserialize<_i4.BreathingPattern>(
              jsonSerialization['breathingPattern'],
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String exerciseKey;

  String title;

  _i2.ExerciseCategory category;

  String description;

  List<String> steps;

  _i3.ExerciseDifficulty difficulty;

  int durationMinutes;

  List<String> tags;

  _i4.BreathingPattern? breathingPattern;

  /// Returns a shallow copy of this [Exercise]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Exercise copyWith({
    int? id,
    String? exerciseKey,
    String? title,
    _i2.ExerciseCategory? category,
    String? description,
    List<String>? steps,
    _i3.ExerciseDifficulty? difficulty,
    int? durationMinutes,
    List<String>? tags,
    _i4.BreathingPattern? breathingPattern,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Exercise',
      if (id != null) 'id': id,
      'exerciseKey': exerciseKey,
      'title': title,
      'category': category.toJson(),
      'description': description,
      'steps': steps.toJson(),
      'difficulty': difficulty.toJson(),
      'durationMinutes': durationMinutes,
      'tags': tags.toJson(),
      if (breathingPattern != null)
        'breathingPattern': breathingPattern?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ExerciseImpl extends Exercise {
  _ExerciseImpl({
    int? id,
    required String exerciseKey,
    required String title,
    required _i2.ExerciseCategory category,
    required String description,
    required List<String> steps,
    required _i3.ExerciseDifficulty difficulty,
    required int durationMinutes,
    required List<String> tags,
    _i4.BreathingPattern? breathingPattern,
  }) : super._(
         id: id,
         exerciseKey: exerciseKey,
         title: title,
         category: category,
         description: description,
         steps: steps,
         difficulty: difficulty,
         durationMinutes: durationMinutes,
         tags: tags,
         breathingPattern: breathingPattern,
       );

  /// Returns a shallow copy of this [Exercise]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Exercise copyWith({
    Object? id = _Undefined,
    String? exerciseKey,
    String? title,
    _i2.ExerciseCategory? category,
    String? description,
    List<String>? steps,
    _i3.ExerciseDifficulty? difficulty,
    int? durationMinutes,
    List<String>? tags,
    Object? breathingPattern = _Undefined,
  }) {
    return Exercise(
      id: id is int? ? id : this.id,
      exerciseKey: exerciseKey ?? this.exerciseKey,
      title: title ?? this.title,
      category: category ?? this.category,
      description: description ?? this.description,
      steps: steps ?? this.steps.map((e0) => e0).toList(),
      difficulty: difficulty ?? this.difficulty,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      tags: tags ?? this.tags.map((e0) => e0).toList(),
      breathingPattern: breathingPattern is _i4.BreathingPattern?
          ? breathingPattern
          : this.breathingPattern?.copyWith(),
    );
  }
}
