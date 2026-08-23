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

abstract class DifficultWord implements _i1.SerializableModel {
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

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String word;

  DateTime dateAdded;

  String? note;

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
