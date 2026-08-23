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

abstract class ExerciseProgress implements _i1.SerializableModel {
  ExerciseProgress._({
    this.id,
    required this.exerciseId,
    required this.timesCompleted,
    this.lastCompletedAt,
  });

  factory ExerciseProgress({
    int? id,
    required String exerciseId,
    required int timesCompleted,
    DateTime? lastCompletedAt,
  }) = _ExerciseProgressImpl;

  factory ExerciseProgress.fromJson(Map<String, dynamic> jsonSerialization) {
    return ExerciseProgress(
      id: jsonSerialization['id'] as int?,
      exerciseId: jsonSerialization['exerciseId'] as String,
      timesCompleted: jsonSerialization['timesCompleted'] as int,
      lastCompletedAt: jsonSerialization['lastCompletedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['lastCompletedAt'],
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String exerciseId;

  int timesCompleted;

  DateTime? lastCompletedAt;

  /// Returns a shallow copy of this [ExerciseProgress]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ExerciseProgress copyWith({
    int? id,
    String? exerciseId,
    int? timesCompleted,
    DateTime? lastCompletedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ExerciseProgress',
      if (id != null) 'id': id,
      'exerciseId': exerciseId,
      'timesCompleted': timesCompleted,
      if (lastCompletedAt != null) 'lastCompletedAt': lastCompletedAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ExerciseProgressImpl extends ExerciseProgress {
  _ExerciseProgressImpl({
    int? id,
    required String exerciseId,
    required int timesCompleted,
    DateTime? lastCompletedAt,
  }) : super._(
         id: id,
         exerciseId: exerciseId,
         timesCompleted: timesCompleted,
         lastCompletedAt: lastCompletedAt,
       );

  /// Returns a shallow copy of this [ExerciseProgress]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ExerciseProgress copyWith({
    Object? id = _Undefined,
    String? exerciseId,
    int? timesCompleted,
    Object? lastCompletedAt = _Undefined,
  }) {
    return ExerciseProgress(
      id: id is int? ? id : this.id,
      exerciseId: exerciseId ?? this.exerciseId,
      timesCompleted: timesCompleted ?? this.timesCompleted,
      lastCompletedAt: lastCompletedAt is DateTime?
          ? lastCompletedAt
          : this.lastCompletedAt,
    );
  }
}
