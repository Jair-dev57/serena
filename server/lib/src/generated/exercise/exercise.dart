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
import '../exercise/exercise_category.dart' as _i2;
import '../exercise/exercise_difficulty.dart' as _i3;
import '../exercise/breathing_pattern.dart' as _i4;
import 'package:serena_poc_server/src/generated/protocol.dart' as _i5;

abstract class Exercise
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
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

  static final t = ExerciseTable();

  static const db = ExerciseRepository._();

  @override
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

  @override
  _i1.Table<int?> get table => t;

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
  Map<String, dynamic> toJsonForProtocol() {
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
        'breathingPattern': breathingPattern?.toJsonForProtocol(),
    };
  }

  static ExerciseInclude include() {
    return ExerciseInclude._();
  }

  static ExerciseIncludeList includeList({
    _i1.WhereExpressionBuilder<ExerciseTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ExerciseTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ExerciseTable>? orderByList,
    ExerciseInclude? include,
  }) {
    return ExerciseIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Exercise.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Exercise.t),
      include: include,
    );
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

class ExerciseUpdateTable extends _i1.UpdateTable<ExerciseTable> {
  ExerciseUpdateTable(super.table);

  _i1.ColumnValue<String, String> exerciseKey(String value) => _i1.ColumnValue(
    table.exerciseKey,
    value,
  );

  _i1.ColumnValue<String, String> title(String value) => _i1.ColumnValue(
    table.title,
    value,
  );

  _i1.ColumnValue<_i2.ExerciseCategory, _i2.ExerciseCategory> category(
    _i2.ExerciseCategory value,
  ) => _i1.ColumnValue(
    table.category,
    value,
  );

  _i1.ColumnValue<String, String> description(String value) => _i1.ColumnValue(
    table.description,
    value,
  );

  _i1.ColumnValue<List<String>, List<String>> steps(List<String> value) =>
      _i1.ColumnValue(
        table.steps,
        value,
      );

  _i1.ColumnValue<_i3.ExerciseDifficulty, _i3.ExerciseDifficulty> difficulty(
    _i3.ExerciseDifficulty value,
  ) => _i1.ColumnValue(
    table.difficulty,
    value,
  );

  _i1.ColumnValue<int, int> durationMinutes(int value) => _i1.ColumnValue(
    table.durationMinutes,
    value,
  );

  _i1.ColumnValue<List<String>, List<String>> tags(List<String> value) =>
      _i1.ColumnValue(
        table.tags,
        value,
      );

  _i1.ColumnValue<_i4.BreathingPattern, _i4.BreathingPattern> breathingPattern(
    _i4.BreathingPattern? value,
  ) => _i1.ColumnValue(
    table.breathingPattern,
    value,
  );
}

class ExerciseTable extends _i1.Table<int?> {
  ExerciseTable({super.tableRelation}) : super(tableName: 'exercise') {
    updateTable = ExerciseUpdateTable(this);
    exerciseKey = _i1.ColumnString(
      'exerciseKey',
      this,
    );
    title = _i1.ColumnString(
      'title',
      this,
    );
    category = _i1.ColumnEnum(
      'category',
      this,
      _i1.EnumSerialization.byName,
    );
    description = _i1.ColumnString(
      'description',
      this,
    );
    steps = _i1.ColumnSerializable<List<String>>(
      'steps',
      this,
    );
    difficulty = _i1.ColumnEnum(
      'difficulty',
      this,
      _i1.EnumSerialization.byName,
    );
    durationMinutes = _i1.ColumnInt(
      'durationMinutes',
      this,
    );
    tags = _i1.ColumnSerializable<List<String>>(
      'tags',
      this,
    );
    breathingPattern = _i1.ColumnSerializable<_i4.BreathingPattern>(
      'breathingPattern',
      this,
    );
  }

  late final ExerciseUpdateTable updateTable;

  late final _i1.ColumnString exerciseKey;

  late final _i1.ColumnString title;

  late final _i1.ColumnEnum<_i2.ExerciseCategory> category;

  late final _i1.ColumnString description;

  late final _i1.ColumnSerializable<List<String>> steps;

  late final _i1.ColumnEnum<_i3.ExerciseDifficulty> difficulty;

  late final _i1.ColumnInt durationMinutes;

  late final _i1.ColumnSerializable<List<String>> tags;

  late final _i1.ColumnSerializable<_i4.BreathingPattern> breathingPattern;

  @override
  List<_i1.Column> get columns => [
    id,
    exerciseKey,
    title,
    category,
    description,
    steps,
    difficulty,
    durationMinutes,
    tags,
    breathingPattern,
  ];
}

class ExerciseInclude extends _i1.IncludeObject {
  ExerciseInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => Exercise.t;
}

class ExerciseIncludeList extends _i1.IncludeList {
  ExerciseIncludeList._({
    _i1.WhereExpressionBuilder<ExerciseTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Exercise.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Exercise.t;
}

class ExerciseRepository {
  const ExerciseRepository._();

  /// Returns a list of [Exercise]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<Exercise>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ExerciseTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ExerciseTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ExerciseTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Exercise>(
      where: where?.call(Exercise.t),
      orderBy: orderBy?.call(Exercise.t),
      orderByList: orderByList?.call(Exercise.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Exercise] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<Exercise?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ExerciseTable>? where,
    int? offset,
    _i1.OrderByBuilder<ExerciseTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ExerciseTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Exercise>(
      where: where?.call(Exercise.t),
      orderBy: orderBy?.call(Exercise.t),
      orderByList: orderByList?.call(Exercise.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Exercise] by its [id] or null if no such row exists.
  Future<Exercise?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Exercise>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Exercise]s in the list and returns the inserted rows.
  ///
  /// The returned [Exercise]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<Exercise>> insert(
    _i1.DatabaseSession session,
    List<Exercise> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<Exercise>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [Exercise] and returns the inserted row.
  ///
  /// The returned [Exercise] will have its `id` field set.
  Future<Exercise> insertRow(
    _i1.DatabaseSession session,
    Exercise row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Exercise>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Exercise]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Exercise>> update(
    _i1.DatabaseSession session,
    List<Exercise> rows, {
    _i1.ColumnSelections<ExerciseTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Exercise>(
      rows,
      columns: columns?.call(Exercise.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Exercise]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Exercise> updateRow(
    _i1.DatabaseSession session,
    Exercise row, {
    _i1.ColumnSelections<ExerciseTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Exercise>(
      row,
      columns: columns?.call(Exercise.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Exercise] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Exercise?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<ExerciseUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<Exercise>(
      id,
      columnValues: columnValues(Exercise.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Exercise]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<Exercise>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<ExerciseUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<ExerciseTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ExerciseTable>? orderBy,
    _i1.OrderByListBuilder<ExerciseTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<Exercise>(
      columnValues: columnValues(Exercise.t.updateTable),
      where: where(Exercise.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Exercise.t),
      orderByList: orderByList?.call(Exercise.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [Exercise]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Exercise>> delete(
    _i1.DatabaseSession session,
    List<Exercise> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Exercise>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Exercise].
  Future<Exercise> deleteRow(
    _i1.DatabaseSession session,
    Exercise row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Exercise>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Exercise>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<ExerciseTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Exercise>(
      where: where(Exercise.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ExerciseTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Exercise>(
      where: where?.call(Exercise.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Exercise] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<ExerciseTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Exercise>(
      where: where(Exercise.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
