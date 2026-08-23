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

abstract class ExerciseProgress
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
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

  static final t = ExerciseProgressTable();

  static const db = ExerciseProgressRepository._();

  @override
  int? id;

  String exerciseId;

  int timesCompleted;

  DateTime? lastCompletedAt;

  @override
  _i1.Table<int?> get table => t;

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
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ExerciseProgress',
      if (id != null) 'id': id,
      'exerciseId': exerciseId,
      'timesCompleted': timesCompleted,
      if (lastCompletedAt != null) 'lastCompletedAt': lastCompletedAt?.toJson(),
    };
  }

  static ExerciseProgressInclude include() {
    return ExerciseProgressInclude._();
  }

  static ExerciseProgressIncludeList includeList({
    _i1.WhereExpressionBuilder<ExerciseProgressTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ExerciseProgressTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ExerciseProgressTable>? orderByList,
    ExerciseProgressInclude? include,
  }) {
    return ExerciseProgressIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ExerciseProgress.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(ExerciseProgress.t),
      include: include,
    );
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

class ExerciseProgressUpdateTable
    extends _i1.UpdateTable<ExerciseProgressTable> {
  ExerciseProgressUpdateTable(super.table);

  _i1.ColumnValue<String, String> exerciseId(String value) => _i1.ColumnValue(
    table.exerciseId,
    value,
  );

  _i1.ColumnValue<int, int> timesCompleted(int value) => _i1.ColumnValue(
    table.timesCompleted,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> lastCompletedAt(DateTime? value) =>
      _i1.ColumnValue(
        table.lastCompletedAt,
        value,
      );
}

class ExerciseProgressTable extends _i1.Table<int?> {
  ExerciseProgressTable({super.tableRelation})
    : super(tableName: 'exercise_progress') {
    updateTable = ExerciseProgressUpdateTable(this);
    exerciseId = _i1.ColumnString(
      'exerciseId',
      this,
    );
    timesCompleted = _i1.ColumnInt(
      'timesCompleted',
      this,
    );
    lastCompletedAt = _i1.ColumnDateTime(
      'lastCompletedAt',
      this,
    );
  }

  late final ExerciseProgressUpdateTable updateTable;

  late final _i1.ColumnString exerciseId;

  late final _i1.ColumnInt timesCompleted;

  late final _i1.ColumnDateTime lastCompletedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    exerciseId,
    timesCompleted,
    lastCompletedAt,
  ];
}

class ExerciseProgressInclude extends _i1.IncludeObject {
  ExerciseProgressInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => ExerciseProgress.t;
}

class ExerciseProgressIncludeList extends _i1.IncludeList {
  ExerciseProgressIncludeList._({
    _i1.WhereExpressionBuilder<ExerciseProgressTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ExerciseProgress.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => ExerciseProgress.t;
}

class ExerciseProgressRepository {
  const ExerciseProgressRepository._();

  /// Returns a list of [ExerciseProgress]s matching the given query parameters.
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
  Future<List<ExerciseProgress>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ExerciseProgressTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ExerciseProgressTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ExerciseProgressTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ExerciseProgress>(
      where: where?.call(ExerciseProgress.t),
      orderBy: orderBy?.call(ExerciseProgress.t),
      orderByList: orderByList?.call(ExerciseProgress.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ExerciseProgress] matching the given query parameters.
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
  Future<ExerciseProgress?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ExerciseProgressTable>? where,
    int? offset,
    _i1.OrderByBuilder<ExerciseProgressTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ExerciseProgressTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ExerciseProgress>(
      where: where?.call(ExerciseProgress.t),
      orderBy: orderBy?.call(ExerciseProgress.t),
      orderByList: orderByList?.call(ExerciseProgress.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ExerciseProgress] by its [id] or null if no such row exists.
  Future<ExerciseProgress?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ExerciseProgress>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ExerciseProgress]s in the list and returns the inserted rows.
  ///
  /// The returned [ExerciseProgress]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<ExerciseProgress>> insert(
    _i1.DatabaseSession session,
    List<ExerciseProgress> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<ExerciseProgress>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [ExerciseProgress] and returns the inserted row.
  ///
  /// The returned [ExerciseProgress] will have its `id` field set.
  Future<ExerciseProgress> insertRow(
    _i1.DatabaseSession session,
    ExerciseProgress row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ExerciseProgress>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [ExerciseProgress]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<ExerciseProgress>> update(
    _i1.DatabaseSession session,
    List<ExerciseProgress> rows, {
    _i1.ColumnSelections<ExerciseProgressTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<ExerciseProgress>(
      rows,
      columns: columns?.call(ExerciseProgress.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ExerciseProgress]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ExerciseProgress> updateRow(
    _i1.DatabaseSession session,
    ExerciseProgress row, {
    _i1.ColumnSelections<ExerciseProgressTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<ExerciseProgress>(
      row,
      columns: columns?.call(ExerciseProgress.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ExerciseProgress] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ExerciseProgress?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<ExerciseProgressUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<ExerciseProgress>(
      id,
      columnValues: columnValues(ExerciseProgress.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ExerciseProgress]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<ExerciseProgress>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<ExerciseProgressUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<ExerciseProgressTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ExerciseProgressTable>? orderBy,
    _i1.OrderByListBuilder<ExerciseProgressTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<ExerciseProgress>(
      columnValues: columnValues(ExerciseProgress.t.updateTable),
      where: where(ExerciseProgress.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ExerciseProgress.t),
      orderByList: orderByList?.call(ExerciseProgress.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [ExerciseProgress]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<ExerciseProgress>> delete(
    _i1.DatabaseSession session,
    List<ExerciseProgress> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ExerciseProgress>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [ExerciseProgress].
  Future<ExerciseProgress> deleteRow(
    _i1.DatabaseSession session,
    ExerciseProgress row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ExerciseProgress>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<ExerciseProgress>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<ExerciseProgressTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ExerciseProgress>(
      where: where(ExerciseProgress.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ExerciseProgressTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ExerciseProgress>(
      where: where?.call(ExerciseProgress.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ExerciseProgress] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<ExerciseProgressTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ExerciseProgress>(
      where: where(ExerciseProgress.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
