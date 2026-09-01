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

abstract class RecommendationResult implements _i1.SerializableModel {
  RecommendationResult._({
    required this.message,
    required this.exerciseKey,
  });

  factory RecommendationResult({
    required String message,
    required String exerciseKey,
  }) = _RecommendationResultImpl;

  factory RecommendationResult.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return RecommendationResult(
      message: jsonSerialization['message'] as String,
      exerciseKey: jsonSerialization['exerciseKey'] as String,
    );
  }

  String message;

  String exerciseKey;

  /// Returns a shallow copy of this [RecommendationResult]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  RecommendationResult copyWith({
    String? message,
    String? exerciseKey,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RecommendationResult',
      'message': message,
      'exerciseKey': exerciseKey,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _RecommendationResultImpl extends RecommendationResult {
  _RecommendationResultImpl({
    required String message,
    required String exerciseKey,
  }) : super._(
         message: message,
         exerciseKey: exerciseKey,
       );

  /// Returns a shallow copy of this [RecommendationResult]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  RecommendationResult copyWith({
    String? message,
    String? exerciseKey,
  }) {
    return RecommendationResult(
      message: message ?? this.message,
      exerciseKey: exerciseKey ?? this.exerciseKey,
    );
  }
}
