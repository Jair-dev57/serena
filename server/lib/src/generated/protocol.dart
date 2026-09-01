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
import 'package:serverpod/serverpod.dart' as _i1;
import 'package:serverpod/protocol.dart' as _i2;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _i3;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _i4;
import 'block/block_context.dart' as _i5;
import 'block/block_entry.dart' as _i6;
import 'block/block_severity.dart' as _i7;
import 'difficult_word/difficult_word.dart' as _i8;
import 'exercise/breathing_pattern.dart' as _i9;
import 'exercise/exercise.dart' as _i10;
import 'exercise/exercise_category.dart' as _i11;
import 'exercise/exercise_difficulty.dart' as _i12;
import 'exercise_progress/exercise_progress.dart' as _i13;
import 'greetings/greeting.dart' as _i14;
import 'practice_session/practice_session.dart' as _i15;
import 'recommendation/recommendation_result.dart' as _i16;
import 'package:serena_server/src/generated/block/block_entry.dart' as _i17;
import 'package:serena_server/src/generated/difficult_word/difficult_word.dart'
    as _i18;
import 'package:serena_server/src/generated/exercise/exercise.dart' as _i19;
import 'package:serena_server/src/generated/exercise_progress/exercise_progress.dart'
    as _i20;
import 'package:serena_server/src/generated/practice_session/practice_session.dart'
    as _i21;
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

class Protocol extends _i1.SerializationManagerServer {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  static final List<_i2.TableDefinition> targetTableDefinitions = [
    _i2.TableDefinition(
      name: 'block_entry',
      dartName: 'BlockEntry',
      schema: 'public',
      module: 'serena',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'block_entry_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'dateTime',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'severity',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:BlockSeverity',
        ),
        _i2.ColumnDefinition(
          name: 'context',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:BlockContext',
        ),
        _i2.ColumnDefinition(
          name: 'note',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'block_entry_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'difficult_word',
      dartName: 'DifficultWord',
      schema: 'public',
      module: 'serena',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'difficult_word_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'word',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'dateAdded',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'note',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'difficult_word_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'exercise',
      dartName: 'Exercise',
      schema: 'public',
      module: 'serena',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'exercise_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'exerciseKey',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'title',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'category',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:ExerciseCategory',
        ),
        _i2.ColumnDefinition(
          name: 'description',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'steps',
          columnType: _i2.ColumnType.json,
          isNullable: false,
          dartType: 'List<String>',
        ),
        _i2.ColumnDefinition(
          name: 'difficulty',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:ExerciseDifficulty',
        ),
        _i2.ColumnDefinition(
          name: 'durationMinutes',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'tags',
          columnType: _i2.ColumnType.json,
          isNullable: false,
          dartType: 'List<String>',
        ),
        _i2.ColumnDefinition(
          name: 'breathingPattern',
          columnType: _i2.ColumnType.json,
          isNullable: true,
          dartType: 'protocol:BreathingPattern?',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'exercise_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'exercise_key_unique',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'exerciseKey',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'exercise_progress',
      dartName: 'ExerciseProgress',
      schema: 'public',
      module: 'serena',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'exercise_progress_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'exerciseId',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'timesCompleted',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'lastCompletedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'exercise_progress_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'exercise_progress_exercise_id_unique',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'exerciseId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'practice_session',
      dartName: 'PracticeSession',
      schema: 'public',
      module: 'serena',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'practice_session_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'exerciseTitle',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'date',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'practice_session_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    ..._i3.Protocol.targetTableDefinitions,
    ..._i4.Protocol.targetTableDefinitions,
    ..._i2.Protocol.targetTableDefinitions,
  ];

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

    if (t == _i5.BlockContext) {
      return _i5.BlockContext.fromJson(data) as T;
    }
    if (t == _i6.BlockEntry) {
      return _i6.BlockEntry.fromJson(data) as T;
    }
    if (t == _i7.BlockSeverity) {
      return _i7.BlockSeverity.fromJson(data) as T;
    }
    if (t == _i8.DifficultWord) {
      return _i8.DifficultWord.fromJson(data) as T;
    }
    if (t == _i9.BreathingPattern) {
      return _i9.BreathingPattern.fromJson(data) as T;
    }
    if (t == _i10.Exercise) {
      return _i10.Exercise.fromJson(data) as T;
    }
    if (t == _i11.ExerciseCategory) {
      return _i11.ExerciseCategory.fromJson(data) as T;
    }
    if (t == _i12.ExerciseDifficulty) {
      return _i12.ExerciseDifficulty.fromJson(data) as T;
    }
    if (t == _i13.ExerciseProgress) {
      return _i13.ExerciseProgress.fromJson(data) as T;
    }
    if (t == _i14.Greeting) {
      return _i14.Greeting.fromJson(data) as T;
    }
    if (t == _i15.PracticeSession) {
      return _i15.PracticeSession.fromJson(data) as T;
    }
    if (t == _i16.RecommendationResult) {
      return _i16.RecommendationResult.fromJson(data) as T;
    }
    if (t == _i1.getType<_i5.BlockContext?>()) {
      return (data != null ? _i5.BlockContext.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.BlockEntry?>()) {
      return (data != null ? _i6.BlockEntry.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.BlockSeverity?>()) {
      return (data != null ? _i7.BlockSeverity.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.DifficultWord?>()) {
      return (data != null ? _i8.DifficultWord.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i9.BreathingPattern?>()) {
      return (data != null ? _i9.BreathingPattern.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i10.Exercise?>()) {
      return (data != null ? _i10.Exercise.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i11.ExerciseCategory?>()) {
      return (data != null ? _i11.ExerciseCategory.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i12.ExerciseDifficulty?>()) {
      return (data != null ? _i12.ExerciseDifficulty.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i13.ExerciseProgress?>()) {
      return (data != null ? _i13.ExerciseProgress.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i14.Greeting?>()) {
      return (data != null ? _i14.Greeting.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i15.PracticeSession?>()) {
      return (data != null ? _i15.PracticeSession.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i16.RecommendationResult?>()) {
      return (data != null ? _i16.RecommendationResult.fromJson(data) : null)
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == List<_i17.BlockEntry>) {
      return (data as List).map((e) => deserialize<_i17.BlockEntry>(e)).toList()
          as T;
    }
    if (t == List<_i18.DifficultWord>) {
      return (data as List)
              .map((e) => deserialize<_i18.DifficultWord>(e))
              .toList()
          as T;
    }
    if (t == List<_i19.Exercise>) {
      return (data as List).map((e) => deserialize<_i19.Exercise>(e)).toList()
          as T;
    }
    if (t == List<_i20.ExerciseProgress>) {
      return (data as List)
              .map((e) => deserialize<_i20.ExerciseProgress>(e))
              .toList()
          as T;
    }
    if (t == List<_i21.PracticeSession>) {
      return (data as List)
              .map((e) => deserialize<_i21.PracticeSession>(e))
              .toList()
          as T;
    }
    try {
      return _i3.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i4.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i2.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i5.BlockContext => 'BlockContext',
      _i6.BlockEntry => 'BlockEntry',
      _i7.BlockSeverity => 'BlockSeverity',
      _i8.DifficultWord => 'DifficultWord',
      _i9.BreathingPattern => 'BreathingPattern',
      _i10.Exercise => 'Exercise',
      _i11.ExerciseCategory => 'ExerciseCategory',
      _i12.ExerciseDifficulty => 'ExerciseDifficulty',
      _i13.ExerciseProgress => 'ExerciseProgress',
      _i14.Greeting => 'Greeting',
      _i15.PracticeSession => 'PracticeSession',
      _i16.RecommendationResult => 'RecommendationResult',
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
      case _i5.BlockContext():
        return 'BlockContext';
      case _i6.BlockEntry():
        return 'BlockEntry';
      case _i7.BlockSeverity():
        return 'BlockSeverity';
      case _i8.DifficultWord():
        return 'DifficultWord';
      case _i9.BreathingPattern():
        return 'BreathingPattern';
      case _i10.Exercise():
        return 'Exercise';
      case _i11.ExerciseCategory():
        return 'ExerciseCategory';
      case _i12.ExerciseDifficulty():
        return 'ExerciseDifficulty';
      case _i13.ExerciseProgress():
        return 'ExerciseProgress';
      case _i14.Greeting():
        return 'Greeting';
      case _i15.PracticeSession():
        return 'PracticeSession';
      case _i16.RecommendationResult():
        return 'RecommendationResult';
    }
    className = _i2.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod.$className';
    }
    className = _i3.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_idp.$className';
    }
    className = _i4.Protocol().getClassNameForObject(data);
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
      return deserialize<_i5.BlockContext>(data['data']);
    }
    if (dataClassName == 'BlockEntry') {
      return deserialize<_i6.BlockEntry>(data['data']);
    }
    if (dataClassName == 'BlockSeverity') {
      return deserialize<_i7.BlockSeverity>(data['data']);
    }
    if (dataClassName == 'DifficultWord') {
      return deserialize<_i8.DifficultWord>(data['data']);
    }
    if (dataClassName == 'BreathingPattern') {
      return deserialize<_i9.BreathingPattern>(data['data']);
    }
    if (dataClassName == 'Exercise') {
      return deserialize<_i10.Exercise>(data['data']);
    }
    if (dataClassName == 'ExerciseCategory') {
      return deserialize<_i11.ExerciseCategory>(data['data']);
    }
    if (dataClassName == 'ExerciseDifficulty') {
      return deserialize<_i12.ExerciseDifficulty>(data['data']);
    }
    if (dataClassName == 'ExerciseProgress') {
      return deserialize<_i13.ExerciseProgress>(data['data']);
    }
    if (dataClassName == 'Greeting') {
      return deserialize<_i14.Greeting>(data['data']);
    }
    if (dataClassName == 'PracticeSession') {
      return deserialize<_i15.PracticeSession>(data['data']);
    }
    if (dataClassName == 'RecommendationResult') {
      return deserialize<_i16.RecommendationResult>(data['data']);
    }
    if (dataClassName.startsWith('serverpod.')) {
      data['className'] = dataClassName.substring(10);
      return _i2.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _i3.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _i4.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  @override
  _i1.Table? getTableForType(Type t) {
    {
      var table = _i3.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _i4.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _i2.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    switch (t) {
      case _i6.BlockEntry:
        return _i6.BlockEntry.t;
      case _i8.DifficultWord:
        return _i8.DifficultWord.t;
      case _i10.Exercise:
        return _i10.Exercise.t;
      case _i13.ExerciseProgress:
        return _i13.ExerciseProgress.t;
      case _i15.PracticeSession:
        return _i15.PracticeSession.t;
    }
    return null;
  }

  @override
  List<_i2.TableDefinition> getTargetTableDefinitions() =>
      targetTableDefinitions;

  @override
  String getModuleName() => 'serena';

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
      return _i3.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _i4.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
