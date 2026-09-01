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

abstract class WeeklySummary
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  WeeklySummary._({
    this.id,
    required this.weekStartDate,
    required this.summaryText,
    required this.createdAt,
  });

  factory WeeklySummary({
    int? id,
    required DateTime weekStartDate,
    required String summaryText,
    required DateTime createdAt,
  }) = _WeeklySummaryImpl;

  factory WeeklySummary.fromJson(Map<String, dynamic> jsonSerialization) {
    return WeeklySummary(
      id: jsonSerialization['id'] as int?,
      weekStartDate: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['weekStartDate'],
      ),
      summaryText: jsonSerialization['summaryText'] as String,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  static final t = WeeklySummaryTable();

  static const db = WeeklySummaryRepository._();

  @override
  int? id;

  DateTime weekStartDate;

  String summaryText;

  DateTime createdAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [WeeklySummary]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  WeeklySummary copyWith({
    int? id,
    DateTime? weekStartDate,
    String? summaryText,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'WeeklySummary',
      if (id != null) 'id': id,
      'weekStartDate': weekStartDate.toJson(),
      'summaryText': summaryText,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'WeeklySummary',
      if (id != null) 'id': id,
      'weekStartDate': weekStartDate.toJson(),
      'summaryText': summaryText,
      'createdAt': createdAt.toJson(),
    };
  }

  static WeeklySummaryInclude include() {
    return WeeklySummaryInclude._();
  }

  static WeeklySummaryIncludeList includeList({
    _i1.WhereExpressionBuilder<WeeklySummaryTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<WeeklySummaryTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<WeeklySummaryTable>? orderByList,
    WeeklySummaryInclude? include,
  }) {
    return WeeklySummaryIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(WeeklySummary.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(WeeklySummary.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _WeeklySummaryImpl extends WeeklySummary {
  _WeeklySummaryImpl({
    int? id,
    required DateTime weekStartDate,
    required String summaryText,
    required DateTime createdAt,
  }) : super._(
         id: id,
         weekStartDate: weekStartDate,
         summaryText: summaryText,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [WeeklySummary]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  WeeklySummary copyWith({
    Object? id = _Undefined,
    DateTime? weekStartDate,
    String? summaryText,
    DateTime? createdAt,
  }) {
    return WeeklySummary(
      id: id is int? ? id : this.id,
      weekStartDate: weekStartDate ?? this.weekStartDate,
      summaryText: summaryText ?? this.summaryText,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class WeeklySummaryUpdateTable extends _i1.UpdateTable<WeeklySummaryTable> {
  WeeklySummaryUpdateTable(super.table);

  _i1.ColumnValue<DateTime, DateTime> weekStartDate(DateTime value) =>
      _i1.ColumnValue(
        table.weekStartDate,
        value,
      );

  _i1.ColumnValue<String, String> summaryText(String value) => _i1.ColumnValue(
    table.summaryText,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );
}

class WeeklySummaryTable extends _i1.Table<int?> {
  WeeklySummaryTable({super.tableRelation})
    : super(tableName: 'weekly_summary') {
    updateTable = WeeklySummaryUpdateTable(this);
    weekStartDate = _i1.ColumnDateTime(
      'weekStartDate',
      this,
    );
    summaryText = _i1.ColumnString(
      'summaryText',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final WeeklySummaryUpdateTable updateTable;

  late final _i1.ColumnDateTime weekStartDate;

  late final _i1.ColumnString summaryText;

  late final _i1.ColumnDateTime createdAt;

  @override
  List<_i1.Column> get columns => [
    id,
    weekStartDate,
    summaryText,
    createdAt,
  ];
}

class WeeklySummaryInclude extends _i1.IncludeObject {
  WeeklySummaryInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => WeeklySummary.t;
}

class WeeklySummaryIncludeList extends _i1.IncludeList {
  WeeklySummaryIncludeList._({
    _i1.WhereExpressionBuilder<WeeklySummaryTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(WeeklySummary.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => WeeklySummary.t;
}

class WeeklySummaryRepository {
  const WeeklySummaryRepository._();

  /// Returns a list of [WeeklySummary]s matching the given query parameters.
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
  Future<List<WeeklySummary>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<WeeklySummaryTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<WeeklySummaryTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<WeeklySummaryTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<WeeklySummary>(
      where: where?.call(WeeklySummary.t),
      orderBy: orderBy?.call(WeeklySummary.t),
      orderByList: orderByList?.call(WeeklySummary.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [WeeklySummary] matching the given query parameters.
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
  Future<WeeklySummary?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<WeeklySummaryTable>? where,
    int? offset,
    _i1.OrderByBuilder<WeeklySummaryTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<WeeklySummaryTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<WeeklySummary>(
      where: where?.call(WeeklySummary.t),
      orderBy: orderBy?.call(WeeklySummary.t),
      orderByList: orderByList?.call(WeeklySummary.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [WeeklySummary] by its [id] or null if no such row exists.
  Future<WeeklySummary?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<WeeklySummary>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [WeeklySummary]s in the list and returns the inserted rows.
  ///
  /// The returned [WeeklySummary]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<WeeklySummary>> insert(
    _i1.DatabaseSession session,
    List<WeeklySummary> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<WeeklySummary>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [WeeklySummary] and returns the inserted row.
  ///
  /// The returned [WeeklySummary] will have its `id` field set.
  Future<WeeklySummary> insertRow(
    _i1.DatabaseSession session,
    WeeklySummary row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<WeeklySummary>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [WeeklySummary]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<WeeklySummary>> update(
    _i1.DatabaseSession session,
    List<WeeklySummary> rows, {
    _i1.ColumnSelections<WeeklySummaryTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<WeeklySummary>(
      rows,
      columns: columns?.call(WeeklySummary.t),
      transaction: transaction,
    );
  }

  /// Updates a single [WeeklySummary]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<WeeklySummary> updateRow(
    _i1.DatabaseSession session,
    WeeklySummary row, {
    _i1.ColumnSelections<WeeklySummaryTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<WeeklySummary>(
      row,
      columns: columns?.call(WeeklySummary.t),
      transaction: transaction,
    );
  }

  /// Updates a single [WeeklySummary] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<WeeklySummary?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<WeeklySummaryUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<WeeklySummary>(
      id,
      columnValues: columnValues(WeeklySummary.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [WeeklySummary]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<WeeklySummary>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<WeeklySummaryUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<WeeklySummaryTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<WeeklySummaryTable>? orderBy,
    _i1.OrderByListBuilder<WeeklySummaryTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<WeeklySummary>(
      columnValues: columnValues(WeeklySummary.t.updateTable),
      where: where(WeeklySummary.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(WeeklySummary.t),
      orderByList: orderByList?.call(WeeklySummary.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [WeeklySummary]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<WeeklySummary>> delete(
    _i1.DatabaseSession session,
    List<WeeklySummary> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<WeeklySummary>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [WeeklySummary].
  Future<WeeklySummary> deleteRow(
    _i1.DatabaseSession session,
    WeeklySummary row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<WeeklySummary>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<WeeklySummary>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<WeeklySummaryTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<WeeklySummary>(
      where: where(WeeklySummary.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<WeeklySummaryTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<WeeklySummary>(
      where: where?.call(WeeklySummary.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [WeeklySummary] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<WeeklySummaryTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<WeeklySummary>(
      where: where(WeeklySummary.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
