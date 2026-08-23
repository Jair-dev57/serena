import 'dart:convert';

import 'package:http/http.dart' as http;

import 'models.dart';
import 'prompts.dart';

class RecommendationException implements Exception {
  final int statusCode;
  final String message;

  const RecommendationException(this.statusCode, this.message);
}

class RecommenderService {
  final String apiKey;
  final String model;
  final http.Client _client;

  static const String _anthropicUrl = 'https://api.anthropic.com/v1/messages';
  static const String _anthropicVersion = '2023-06-01';

  RecommenderService({
    required this.apiKey,
    this.model = 'claude-sonnet-5',
    http.Client? client,
  }) : _client = client ?? http.Client();

  Future<RecommendResponse> recommend(RecommendRequest payload) async {
    if (payload.exercises.isEmpty) {
      throw const RecommendationException(400, 'No se envió el catálogo de ejercicios');
    }

    final validIds = payload.exercises.map((e) => e.id).toSet();

    final response = await _client.post(
      Uri.parse(_anthropicUrl),
      headers: {
        'x-api-key': apiKey,
        'anthropic-version': _anthropicVersion,
        'content-type': 'application/json',
      },
      body: jsonEncode({
        'model': model,
        'max_tokens': 300,
        'messages': [
          {'role': 'user', 'content': buildRecommendationPrompt(payload)},
        ],
      }),
    );

    if (response.statusCode != 200) {
      throw RecommendationException(
        502,
        'Error al llamar a Claude (${response.statusCode}): ${response.body}',
      );
    }

    final Map<String, dynamic> decoded;
    try {
      decoded = jsonDecode(response.body) as Map<String, dynamic>;
    } on FormatException catch (e) {
      throw RecommendationException(502, 'Respuesta inválida de Claude: $e');
    }

    final contentBlocks = decoded['content'] as List<dynamic>? ?? [];
    final rawText = contentBlocks
        .where((block) => (block as Map<String, dynamic>)['type'] == 'text')
        .map((block) => (block as Map<String, dynamic>)['text'] as String)
        .join()
        .trim();

    final Map<String, dynamic> parsed;
    try {
      parsed = jsonDecode(rawText) as Map<String, dynamic>;
    } on FormatException catch (e) {
      throw RecommendationException(502, 'Respuesta del modelo no es JSON válido: $e');
    }

    final RecommendResponse result;
    try {
      result = RecommendResponse.fromJson(parsed);
    } catch (e) {
      throw RecommendationException(502, 'Formato de respuesta inesperado: $e');
    }

    if (!validIds.contains(result.recommendedExerciseId)) {
      throw const RecommendationException(502, 'El modelo recomendó un ejercicio inexistente');
    }

    return result;
  }

  void close() => _client.close();
}