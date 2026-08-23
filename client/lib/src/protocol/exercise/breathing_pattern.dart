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

abstract class BreathingPattern implements _i1.SerializableModel {
  BreathingPattern._({
    required this.inhaleSeconds,
    required this.holdSeconds,
    required this.exhaleSeconds,
  });

  factory BreathingPattern({
    required int inhaleSeconds,
    required int holdSeconds,
    required int exhaleSeconds,
  }) = _BreathingPatternImpl;

  factory BreathingPattern.fromJson(Map<String, dynamic> jsonSerialization) {
    return BreathingPattern(
      inhaleSeconds: jsonSerialization['inhaleSeconds'] as int,
      holdSeconds: jsonSerialization['holdSeconds'] as int,
      exhaleSeconds: jsonSerialization['exhaleSeconds'] as int,
    );
  }

  int inhaleSeconds;

  int holdSeconds;

  int exhaleSeconds;

  /// Returns a shallow copy of this [BreathingPattern]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  BreathingPattern copyWith({
    int? inhaleSeconds,
    int? holdSeconds,
    int? exhaleSeconds,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'BreathingPattern',
      'inhaleSeconds': inhaleSeconds,
      'holdSeconds': holdSeconds,
      'exhaleSeconds': exhaleSeconds,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _BreathingPatternImpl extends BreathingPattern {
  _BreathingPatternImpl({
    required int inhaleSeconds,
    required int holdSeconds,
    required int exhaleSeconds,
  }) : super._(
         inhaleSeconds: inhaleSeconds,
         holdSeconds: holdSeconds,
         exhaleSeconds: exhaleSeconds,
       );

  /// Returns a shallow copy of this [BreathingPattern]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  BreathingPattern copyWith({
    int? inhaleSeconds,
    int? holdSeconds,
    int? exhaleSeconds,
  }) {
    return BreathingPattern(
      inhaleSeconds: inhaleSeconds ?? this.inhaleSeconds,
      holdSeconds: holdSeconds ?? this.holdSeconds,
      exhaleSeconds: exhaleSeconds ?? this.exhaleSeconds,
    );
  }
}
