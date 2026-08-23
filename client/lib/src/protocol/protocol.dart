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
import 'block_context.dart' as _i2;
import 'block_entry.dart' as _i3;
import 'block_severity.dart' as _i4;
import 'difficult_word.dart' as _i5;
import 'exercise_progress.dart' as _i6;
import 'greetings/greeting.dart' as _i7;
import 'practice_session.dart' as _i8;
import 'package:serena_poc_client/src/protocol/block_entry.dart' as _i9;
import 'package:serena_poc_client/src/protocol/difficult_word.dart' as _i10;
import 'package:serena_poc_client/src/protocol/exercise_progress.dart' as _i11;
import 'package:serena_poc_client/src/protocol/practice_session.dart' as _i12;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i13;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i14;
export 'block_context.dart';
export 'block_entry.dart';
export 'block_severity.dart';
export 'difficult_word.dart';
export 'exercise_progress.dart';
export 'greetings/greeting.dart';
export 'practice_session.dart';
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
    if (t == _i6.ExerciseProgress) {
      return _i6.ExerciseProgress.fromJson(data) as T;
    }
    if (t == _i7.Greeting) {
      return _i7.Greeting.fromJson(data) as T;
    }
    if (t == _i8.PracticeSession) {
      return _i8.PracticeSession.fromJson(data) as T;
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
    if (t == _i1.getType<_i6.ExerciseProgress?>()) {
      return (data != null ? _i6.ExerciseProgress.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.Greeting?>()) {
      return (data != null ? _i7.Greeting.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.PracticeSession?>()) {
      return (data != null ? _i8.PracticeSession.fromJson(data) : null) as T;
    }
    if (t == List<_i9.BlockEntry>) {
      return (data as List).map((e) => deserialize<_i9.BlockEntry>(e)).toList()
          as T;
    }
    if (t == List<_i10.DifficultWord>) {
      return (data as List)
              .map((e) => deserialize<_i10.DifficultWord>(e))
              .toList()
          as T;
    }
    if (t == List<_i11.ExerciseProgress>) {
      return (data as List)
              .map((e) => deserialize<_i11.ExerciseProgress>(e))
              .toList()
          as T;
    }
    if (t == List<_i12.PracticeSession>) {
      return (data as List)
              .map((e) => deserialize<_i12.PracticeSession>(e))
              .toList()
          as T;
    }
    try {
      return _i13.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i14.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i2.BlockContext => 'BlockContext',
      _i3.BlockEntry => 'BlockEntry',
      _i4.BlockSeverity => 'BlockSeverity',
      _i5.DifficultWord => 'DifficultWord',
      _i6.ExerciseProgress => 'ExerciseProgress',
      _i7.Greeting => 'Greeting',
      _i8.PracticeSession => 'PracticeSession',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst('serena_poc.', '');
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
      case _i6.ExerciseProgress():
        return 'ExerciseProgress';
      case _i7.Greeting():
        return 'Greeting';
      case _i8.PracticeSession():
        return 'PracticeSession';
    }
    className = _i13.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_idp.$className';
    }
    className = _i14.Protocol().getClassNameForObject(data);
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
    if (dataClassName == 'ExerciseProgress') {
      return deserialize<_i6.ExerciseProgress>(data['data']);
    }
    if (dataClassName == 'Greeting') {
      return deserialize<_i7.Greeting>(data['data']);
    }
    if (dataClassName == 'PracticeSession') {
      return deserialize<_i8.PracticeSession>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _i13.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _i14.Protocol().deserializeByClassName(data);
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
      return _i13.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _i14.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
