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
import '../block/block_severity.dart' as _i2;
import '../block/block_context.dart' as _i3;

abstract class BlockEntry
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  BlockEntry._({
    this.id,
    required this.dateTime,
    required this.severity,
    required this.context,
    this.note,
  });

  factory BlockEntry({
    int? id,
    required DateTime dateTime,
    required _i2.BlockSeverity severity,
    required _i3.BlockContext context,
    String? note,
  }) = _BlockEntryImpl;

  factory BlockEntry.fromJson(Map<String, dynamic> jsonSerialization) {
    return BlockEntry(
      id: jsonSerialization['id'] as int?,
      dateTime: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['dateTime'],
      ),
      severity: _i2.BlockSeverity.fromJson(
        (jsonSerialization['severity'] as String),
      ),
      context: _i3.BlockContext.fromJson(
        (jsonSerialization['context'] as String),
      ),
      note: jsonSerialization['note'] as String?,
    );
  }

  static final t = BlockEntryTable();

  static const db = BlockEntryRepository._();

  @override
  int? id;

  DateTime dateTime;

  _i2.BlockSeverity severity;

  _i3.BlockContext context;

  String? note;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [BlockEntry]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  BlockEntry copyWith({
    int? id,
    DateTime? dateTime,
    _i2.BlockSeverity? severity,
    _i3.BlockContext? context,
    String? note,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'BlockEntry',
      if (id != null) 'id': id,
      'dateTime': dateTime.toJson(),
      'severity': severity.toJson(),
      'context': context.toJson(),
      if (note != null) 'note': note,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'BlockEntry',
      if (id != null) 'id': id,
      'dateTime': dateTime.toJson(),
      'severity': severity.toJson(),
      'context': context.toJson(),
      if (note != null) 'note': note,
    };
  }

  static BlockEntryInclude include() {
    return BlockEntryInclude._();
  }

  static BlockEntryIncludeList includeList({
    _i1.WhereExpressionBuilder<BlockEntryTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<BlockEntryTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BlockEntryTable>? orderByList,
    BlockEntryInclude? include,
  }) {
    return BlockEntryIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(BlockEntry.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(BlockEntry.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _BlockEntryImpl extends BlockEntry {
  _BlockEntryImpl({
    int? id,
    required DateTime dateTime,
    required _i2.BlockSeverity severity,
    required _i3.BlockContext context,
    String? note,
  }) : super._(
         id: id,
         dateTime: dateTime,
         severity: severity,
         context: context,
         note: note,
       );

  /// Returns a shallow copy of this [BlockEntry]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  BlockEntry copyWith({
    Object? id = _Undefined,
    DateTime? dateTime,
    _i2.BlockSeverity? severity,
    _i3.BlockContext? context,
    Object? note = _Undefined,
  }) {
    return BlockEntry(
      id: id is int? ? id : this.id,
      dateTime: dateTime ?? this.dateTime,
      severity: severity ?? this.severity,
      context: context ?? this.context,
      note: note is String? ? note : this.note,
    );
  }
}

class BlockEntryUpdateTable extends _i1.UpdateTable<BlockEntryTable> {
  BlockEntryUpdateTable(super.table);

  _i1.ColumnValue<DateTime, DateTime> dateTime(DateTime value) =>
      _i1.ColumnValue(
        table.dateTime,
        value,
      );

  _i1.ColumnValue<_i2.BlockSeverity, _i2.BlockSeverity> severity(
    _i2.BlockSeverity value,
  ) => _i1.ColumnValue(
    table.severity,
    value,
  );

  _i1.ColumnValue<_i3.BlockContext, _i3.BlockContext> context(
    _i3.BlockContext value,
  ) => _i1.ColumnValue(
    table.context,
    value,
  );

  _i1.ColumnValue<String, String> note(String? value) => _i1.ColumnValue(
    table.note,
    value,
  );
}

class BlockEntryTable extends _i1.Table<int?> {
  BlockEntryTable({super.tableRelation}) : super(tableName: 'block_entry') {
    updateTable = BlockEntryUpdateTable(this);
    dateTime = _i1.ColumnDateTime(
      'dateTime',
      this,
    );
    severity = _i1.ColumnEnum(
      'severity',
      this,
      _i1.EnumSerialization.byName,
    );
    context = _i1.ColumnEnum(
      'context',
      this,
      _i1.EnumSerialization.byName,
    );
    note = _i1.ColumnString(
      'note',
      this,
    );
  }

  late final BlockEntryUpdateTable updateTable;

  late final _i1.ColumnDateTime dateTime;

  late final _i1.ColumnEnum<_i2.BlockSeverity> severity;

  late final _i1.ColumnEnum<_i3.BlockContext> context;

  late final _i1.ColumnString note;

  @override
  List<_i1.Column> get columns => [
    id,
    dateTime,
    severity,
    context,
    note,
  ];
}

class BlockEntryInclude extends _i1.IncludeObject {
  BlockEntryInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => BlockEntry.t;
}

class BlockEntryIncludeList extends _i1.IncludeList {
  BlockEntryIncludeList._({
    _i1.WhereExpressionBuilder<BlockEntryTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(BlockEntry.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => BlockEntry.t;
}

class BlockEntryRepository {
  const BlockEntryRepository._();

  /// Returns a list of [BlockEntry]s matching the given query parameters.
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
  Future<List<BlockEntry>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<BlockEntryTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<BlockEntryTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BlockEntryTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<BlockEntry>(
      where: where?.call(BlockEntry.t),
      orderBy: orderBy?.call(BlockEntry.t),
      orderByList: orderByList?.call(BlockEntry.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [BlockEntry] matching the given query parameters.
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
  Future<BlockEntry?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<BlockEntryTable>? where,
    int? offset,
    _i1.OrderByBuilder<BlockEntryTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BlockEntryTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<BlockEntry>(
      where: where?.call(BlockEntry.t),
      orderBy: orderBy?.call(BlockEntry.t),
      orderByList: orderByList?.call(BlockEntry.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [BlockEntry] by its [id] or null if no such row exists.
  Future<BlockEntry?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<BlockEntry>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [BlockEntry]s in the list and returns the inserted rows.
  ///
  /// The returned [BlockEntry]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<BlockEntry>> insert(
    _i1.DatabaseSession session,
    List<BlockEntry> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<BlockEntry>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [BlockEntry] and returns the inserted row.
  ///
  /// The returned [BlockEntry] will have its `id` field set.
  Future<BlockEntry> insertRow(
    _i1.DatabaseSession session,
    BlockEntry row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<BlockEntry>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [BlockEntry]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<BlockEntry>> update(
    _i1.DatabaseSession session,
    List<BlockEntry> rows, {
    _i1.ColumnSelections<BlockEntryTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<BlockEntry>(
      rows,
      columns: columns?.call(BlockEntry.t),
      transaction: transaction,
    );
  }

  /// Updates a single [BlockEntry]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<BlockEntry> updateRow(
    _i1.DatabaseSession session,
    BlockEntry row, {
    _i1.ColumnSelections<BlockEntryTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<BlockEntry>(
      row,
      columns: columns?.call(BlockEntry.t),
      transaction: transaction,
    );
  }

  /// Updates a single [BlockEntry] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<BlockEntry?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<BlockEntryUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<BlockEntry>(
      id,
      columnValues: columnValues(BlockEntry.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [BlockEntry]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<BlockEntry>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<BlockEntryUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<BlockEntryTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<BlockEntryTable>? orderBy,
    _i1.OrderByListBuilder<BlockEntryTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<BlockEntry>(
      columnValues: columnValues(BlockEntry.t.updateTable),
      where: where(BlockEntry.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(BlockEntry.t),
      orderByList: orderByList?.call(BlockEntry.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [BlockEntry]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<BlockEntry>> delete(
    _i1.DatabaseSession session,
    List<BlockEntry> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<BlockEntry>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [BlockEntry].
  Future<BlockEntry> deleteRow(
    _i1.DatabaseSession session,
    BlockEntry row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<BlockEntry>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<BlockEntry>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<BlockEntryTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<BlockEntry>(
      where: where(BlockEntry.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<BlockEntryTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<BlockEntry>(
      where: where?.call(BlockEntry.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [BlockEntry] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<BlockEntryTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<BlockEntry>(
      where: where(BlockEntry.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
