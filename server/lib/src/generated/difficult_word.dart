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

abstract class DifficultWord
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  DifficultWord._({
    this.id,
    required this.word,
    required this.dateAdded,
    this.note,
  });

  factory DifficultWord({
    int? id,
    required String word,
    required DateTime dateAdded,
    String? note,
  }) = _DifficultWordImpl;

  factory DifficultWord.fromJson(Map<String, dynamic> jsonSerialization) {
    return DifficultWord(
      id: jsonSerialization['id'] as int?,
      word: jsonSerialization['word'] as String,
      dateAdded: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['dateAdded'],
      ),
      note: jsonSerialization['note'] as String?,
    );
  }

  static final t = DifficultWordTable();

  static const db = DifficultWordRepository._();

  @override
  int? id;

  String word;

  DateTime dateAdded;

  String? note;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [DifficultWord]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  DifficultWord copyWith({
    int? id,
    String? word,
    DateTime? dateAdded,
    String? note,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DifficultWord',
      if (id != null) 'id': id,
      'word': word,
      'dateAdded': dateAdded.toJson(),
      if (note != null) 'note': note,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DifficultWord',
      if (id != null) 'id': id,
      'word': word,
      'dateAdded': dateAdded.toJson(),
      if (note != null) 'note': note,
    };
  }

  static DifficultWordInclude include() {
    return DifficultWordInclude._();
  }

  static DifficultWordIncludeList includeList({
    _i1.WhereExpressionBuilder<DifficultWordTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<DifficultWordTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<DifficultWordTable>? orderByList,
    DifficultWordInclude? include,
  }) {
    return DifficultWordIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DifficultWord.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(DifficultWord.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DifficultWordImpl extends DifficultWord {
  _DifficultWordImpl({
    int? id,
    required String word,
    required DateTime dateAdded,
    String? note,
  }) : super._(
         id: id,
         word: word,
         dateAdded: dateAdded,
         note: note,
       );

  /// Returns a shallow copy of this [DifficultWord]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  DifficultWord copyWith({
    Object? id = _Undefined,
    String? word,
    DateTime? dateAdded,
    Object? note = _Undefined,
  }) {
    return DifficultWord(
      id: id is int? ? id : this.id,
      word: word ?? this.word,
      dateAdded: dateAdded ?? this.dateAdded,
      note: note is String? ? note : this.note,
    );
  }
}

class DifficultWordUpdateTable extends _i1.UpdateTable<DifficultWordTable> {
  DifficultWordUpdateTable(super.table);

  _i1.ColumnValue<String, String> word(String value) => _i1.ColumnValue(
    table.word,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> dateAdded(DateTime value) =>
      _i1.ColumnValue(
        table.dateAdded,
        value,
      );

  _i1.ColumnValue<String, String> note(String? value) => _i1.ColumnValue(
    table.note,
    value,
  );
}

class DifficultWordTable extends _i1.Table<int?> {
  DifficultWordTable({super.tableRelation})
    : super(tableName: 'difficult_word') {
    updateTable = DifficultWordUpdateTable(this);
    word = _i1.ColumnString(
      'word',
      this,
    );
    dateAdded = _i1.ColumnDateTime(
      'dateAdded',
      this,
    );
    note = _i1.ColumnString(
      'note',
      this,
    );
  }

  late final DifficultWordUpdateTable updateTable;

  late final _i1.ColumnString word;

  late final _i1.ColumnDateTime dateAdded;

  late final _i1.ColumnString note;

  @override
  List<_i1.Column> get columns => [
    id,
    word,
    dateAdded,
    note,
  ];
}

class DifficultWordInclude extends _i1.IncludeObject {
  DifficultWordInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => DifficultWord.t;
}

class DifficultWordIncludeList extends _i1.IncludeList {
  DifficultWordIncludeList._({
    _i1.WhereExpressionBuilder<DifficultWordTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(DifficultWord.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => DifficultWord.t;
}

class DifficultWordRepository {
  const DifficultWordRepository._();

  /// Returns a list of [DifficultWord]s matching the given query parameters.
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
  Future<List<DifficultWord>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<DifficultWordTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<DifficultWordTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<DifficultWordTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<DifficultWord>(
      where: where?.call(DifficultWord.t),
      orderBy: orderBy?.call(DifficultWord.t),
      orderByList: orderByList?.call(DifficultWord.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [DifficultWord] matching the given query parameters.
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
  Future<DifficultWord?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<DifficultWordTable>? where,
    int? offset,
    _i1.OrderByBuilder<DifficultWordTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<DifficultWordTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<DifficultWord>(
      where: where?.call(DifficultWord.t),
      orderBy: orderBy?.call(DifficultWord.t),
      orderByList: orderByList?.call(DifficultWord.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [DifficultWord] by its [id] or null if no such row exists.
  Future<DifficultWord?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<DifficultWord>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [DifficultWord]s in the list and returns the inserted rows.
  ///
  /// The returned [DifficultWord]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<DifficultWord>> insert(
    _i1.DatabaseSession session,
    List<DifficultWord> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<DifficultWord>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [DifficultWord] and returns the inserted row.
  ///
  /// The returned [DifficultWord] will have its `id` field set.
  Future<DifficultWord> insertRow(
    _i1.DatabaseSession session,
    DifficultWord row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<DifficultWord>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [DifficultWord]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<DifficultWord>> update(
    _i1.DatabaseSession session,
    List<DifficultWord> rows, {
    _i1.ColumnSelections<DifficultWordTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<DifficultWord>(
      rows,
      columns: columns?.call(DifficultWord.t),
      transaction: transaction,
    );
  }

  /// Updates a single [DifficultWord]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<DifficultWord> updateRow(
    _i1.DatabaseSession session,
    DifficultWord row, {
    _i1.ColumnSelections<DifficultWordTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<DifficultWord>(
      row,
      columns: columns?.call(DifficultWord.t),
      transaction: transaction,
    );
  }

  /// Updates a single [DifficultWord] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<DifficultWord?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<DifficultWordUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<DifficultWord>(
      id,
      columnValues: columnValues(DifficultWord.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [DifficultWord]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<DifficultWord>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<DifficultWordUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<DifficultWordTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<DifficultWordTable>? orderBy,
    _i1.OrderByListBuilder<DifficultWordTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<DifficultWord>(
      columnValues: columnValues(DifficultWord.t.updateTable),
      where: where(DifficultWord.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DifficultWord.t),
      orderByList: orderByList?.call(DifficultWord.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [DifficultWord]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<DifficultWord>> delete(
    _i1.DatabaseSession session,
    List<DifficultWord> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<DifficultWord>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [DifficultWord].
  Future<DifficultWord> deleteRow(
    _i1.DatabaseSession session,
    DifficultWord row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<DifficultWord>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<DifficultWord>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<DifficultWordTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<DifficultWord>(
      where: where(DifficultWord.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<DifficultWordTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<DifficultWord>(
      where: where?.call(DifficultWord.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [DifficultWord] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<DifficultWordTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<DifficultWord>(
      where: where(DifficultWord.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
