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

abstract class PracticeSession implements _i1.SerializableModel {
  PracticeSession._({
    this.id,
    required this.exerciseTitle,
    required this.date,
  });

  factory PracticeSession({
    int? id,
    required String exerciseTitle,
    required DateTime date,
  }) = _PracticeSessionImpl;

  factory PracticeSession.fromJson(Map<String, dynamic> jsonSerialization) {
    return PracticeSession(
      id: jsonSerialization['id'] as int?,
      exerciseTitle: jsonSerialization['exerciseTitle'] as String,
      date: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['date']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String exerciseTitle;

  DateTime date;

  /// Returns a shallow copy of this [PracticeSession]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  PracticeSession copyWith({
    int? id,
    String? exerciseTitle,
    DateTime? date,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PracticeSession',
      if (id != null) 'id': id,
      'exerciseTitle': exerciseTitle,
      'date': date.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PracticeSessionImpl extends PracticeSession {
  _PracticeSessionImpl({
    int? id,
    required String exerciseTitle,
    required DateTime date,
  }) : super._(
         id: id,
         exerciseTitle: exerciseTitle,
         date: date,
       );

  /// Returns a shallow copy of this [PracticeSession]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  PracticeSession copyWith({
    Object? id = _Undefined,
    String? exerciseTitle,
    DateTime? date,
  }) {
    return PracticeSession(
      id: id is int? ? id : this.id,
      exerciseTitle: exerciseTitle ?? this.exerciseTitle,
      date: date ?? this.date,
    );
  }
}
