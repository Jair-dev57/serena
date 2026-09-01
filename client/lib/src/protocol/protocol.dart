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
import 'block/block_context.dart' as _i2;
import 'block/block_entry.dart' as _i3;
import 'block/block_severity.dart' as _i4;
import 'difficult_word/difficult_word.dart' as _i5;
import 'exercise/breathing_pattern.dart' as _i6;
import 'exercise/exercise.dart' as _i7;
import 'exercise/exercise_category.dart' as _i8;
import 'exercise/exercise_difficulty.dart' as _i9;
import 'exercise_progress/exercise_progress.dart' as _i10;
import 'greetings/greeting.dart' as _i11;
import 'practice_session/practice_session.dart' as _i12;
import 'recommendation/recommendation_result.dart' as _i13;
import 'package:serena_client/src/protocol/block/block_entry.dart' as _i14;
import 'package:serena_client/src/protocol/difficult_word/difficult_word.dart'
    as _i15;
import 'package:serena_client/src/protocol/exercise/exercise.dart' as _i16;
import 'package:serena_client/src/protocol/exercise_progress/exercise_progress.dart'
    as _i17;
import 'package:serena_client/src/protocol/practice_session/practice_session.dart'
    as _i18;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i19;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i20;
export 'block/block_context.dart';
export 'block/block_entry.dart';
export 'block/block_severity.dart';
export 'difficult_word/difficult_word.dart';
export 'exercise/breathing_pattern.dart';
export 'exercise/exercise.dart';
export 'exercise/exercise_category.dart';
export 'exercise/exercise_difficulty.dart';
export 'exercise_progress/exercise_progress.dart';
export 'greetings/greeting.dart';
export 'practice_session/practice_session.dart';
export 'recommendation/recommendation_result.dart';
export 'client.dart';

class Protocol extends _i1.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  static String? getClassNameFromObjectJson(dynamic data) {
    if (data is! Map) return null;
    final className = data['__className__'] as String?;
    return className;
  }

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;

    final dataClassName = getClassNameFromObjectJson(data);
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on FormatException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _i2.BlockContext) {
      return _i2.BlockContext.fromJson(data) as T;
    }
    if (t == _i3.BlockEntry) {
      return _i3.BlockEntry.fromJson(data) as T;
    }
    if (t == _i4.BlockSeverity) {
      return _i4.BlockSeverity.fromJson(data) as T;
    }
    if (t == _i5.DifficultWord) {
      return _i5.DifficultWord.fromJson(data) as T;
    }
    if (t == _i6.BreathingPattern) {
      return _i6.BreathingPattern.fromJson(data) as T;
    }
    if (t == _i7.Exercise) {
      return _i7.Exercise.fromJson(data) as T;
    }
    if (t == _i8.ExerciseCategory) {
      return _i8.ExerciseCategory.fromJson(data) as T;
    }
    if (t == _i9.ExerciseDifficulty) {
      return _i9.ExerciseDifficulty.fromJson(data) as T;
    }
    if (t == _i10.ExerciseProgress) {
      return _i10.ExerciseProgress.fromJson(data) as T;
    }
    if (t == _i11.Greeting) {
      return _i11.Greeting.fromJson(data) as T;
    }
    if (t == _i12.PracticeSession) {
      return _i12.PracticeSession.fromJson(data) as T;
    }
    if (t == _i13.RecommendationResult) {
      return _i13.RecommendationResult.fromJson(data) as T;
    }
    if (t == _i1.getType<_i2.BlockContext?>()) {
      return (data != null ? _i2.BlockContext.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i3.BlockEntry?>()) {
      return (data != null ? _i3.BlockEntry.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i4.BlockSeverity?>()) {
      return (data != null ? _i4.BlockSeverity.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i5.DifficultWord?>()) {
      return (data != null ? _i5.DifficultWord.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.BreathingPattern?>()) {
      return (data != null ? _i6.BreathingPattern.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.Exercise?>()) {
      return (data != null ? _i7.Exercise.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.ExerciseCategory?>()) {
      return (data != null ? _i8.ExerciseCategory.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i9.ExerciseDifficulty?>()) {
      return (data != null ? _i9.ExerciseDifficulty.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i10.ExerciseProgress?>()) {
      return (data != null ? _i10.ExerciseProgress.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i11.Greeting?>()) {
      return (data != null ? _i11.Greeting.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i12.PracticeSession?>()) {
      return (data != null ? _i12.PracticeSession.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i13.RecommendationResult?>()) {
      return (data != null ? _i13.RecommendationResult.fromJson(data) : null)
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == List<_i14.BlockEntry>) {
      return (data as List).map((e) => deserialize<_i14.BlockEntry>(e)).toList()
          as T;
    }
    if (t == List<_i15.DifficultWord>) {
      return (data as List)
              .map((e) => deserialize<_i15.DifficultWord>(e))
              .toList()
          as T;
    }
    if (t == List<_i16.Exercise>) {
      return (data as List).map((e) => deserialize<_i16.Exercise>(e)).toList()
          as T;
    }
    if (t == List<_i17.ExerciseProgress>) {
      return (data as List)
              .map((e) => deserialize<_i17.ExerciseProgress>(e))
              .toList()
          as T;
    }
    if (t == List<_i18.PracticeSession>) {
      return (data as List)
              .map((e) => deserialize<_i18.PracticeSession>(e))
              .toList()
          as T;
    }
    try {
      return _i19.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i20.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i2.BlockContext => 'BlockContext',
      _i3.BlockEntry => 'BlockEntry',
      _i4.BlockSeverity => 'BlockSeverity',
      _i5.DifficultWord => 'DifficultWord',
      _i6.BreathingPattern => 'BreathingPattern',
      _i7.Exercise => 'Exercise',
      _i8.ExerciseCategory => 'ExerciseCategory',
      _i9.ExerciseDifficulty => 'ExerciseDifficulty',
      _i10.ExerciseProgress => 'ExerciseProgress',
      _i11.Greeting => 'Greeting',
      _i12.PracticeSession => 'PracticeSession',
      _i13.RecommendationResult => 'RecommendationResult',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst('serena.', '');
    }

    switch (data) {
      case _i2.BlockContext():
        return 'BlockContext';
      case _i3.BlockEntry():
        return 'BlockEntry';
      case _i4.BlockSeverity():
        return 'BlockSeverity';
      case _i5.DifficultWord():
        return 'DifficultWord';
      case _i6.BreathingPattern():
        return 'BreathingPattern';
      case _i7.Exercise():
        return 'Exercise';
      case _i8.ExerciseCategory():
        return 'ExerciseCategory';
      case _i9.ExerciseDifficulty():
        return 'ExerciseDifficulty';
      case _i10.ExerciseProgress():
        return 'ExerciseProgress';
      case _i11.Greeting():
        return 'Greeting';
      case _i12.PracticeSession():
        return 'PracticeSession';
      case _i13.RecommendationResult():
        return 'RecommendationResult';
    }
    className = _i19.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_idp.$className';
    }
    className = _i20.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_core.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'BlockContext') {
      return deserialize<_i2.BlockContext>(data['data']);
    }
    if (dataClassName == 'BlockEntry') {
      return deserialize<_i3.BlockEntry>(data['data']);
    }
    if (dataClassName == 'BlockSeverity') {
      return deserialize<_i4.BlockSeverity>(data['data']);
    }
    if (dataClassName == 'DifficultWord') {
      return deserialize<_i5.DifficultWord>(data['data']);
    }
    if (dataClassName == 'BreathingPattern') {
      return deserialize<_i6.BreathingPattern>(data['data']);
    }
    if (dataClassName == 'Exercise') {
      return deserialize<_i7.Exercise>(data['data']);
    }
    if (dataClassName == 'ExerciseCategory') {
      return deserialize<_i8.ExerciseCategory>(data['data']);
    }
    if (dataClassName == 'ExerciseDifficulty') {
      return deserialize<_i9.ExerciseDifficulty>(data['data']);
    }
    if (dataClassName == 'ExerciseProgress') {
      return deserialize<_i10.ExerciseProgress>(data['data']);
    }
    if (dataClassName == 'Greeting') {
      return deserialize<_i11.Greeting>(data['data']);
    }
    if (dataClassName == 'PracticeSession') {
      return deserialize<_i12.PracticeSession>(data['data']);
    }
    if (dataClassName == 'RecommendationResult') {
      return deserialize<_i13.RecommendationResult>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _i19.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _i20.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  /// Maps any `Record`s known to this [Protocol] to their JSON representation
  ///
  /// Throws in case the record type is not known.
  ///
  /// This method will return `null` (only) for `null` inputs.
  Map<String, dynamic>? mapRecordToJson(Record? record) {
    if (record == null) {
      return null;
    }
    try {
      return _i19.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _i20.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
