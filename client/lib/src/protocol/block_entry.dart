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
import 'block_severity.dart' as _i2;
import 'block_context.dart' as _i3;

abstract class BlockEntry implements _i1.SerializableModel {
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

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  DateTime dateTime;

  _i2.BlockSeverity severity;

  _i3.BlockContext context;

  String? note;

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
