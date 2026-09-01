import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';

/// Servicio genérico para hablar con la API de Anthropic.
/// No sabe nada de Serena: solo manda un prompt y devuelve el texto de respuesta.
class AnthropicService {
  static const _endpoint = 'https://api.anthropic.com/v1/messages';
  static const _model = 'claude-sonnet-5';
  static const _apiVersion = '2023-06-01';

  /// Envía [prompt] a Claude y devuelve el texto de la respuesta.
  /// Lanza una excepción si la llamada falla.
  static Future<String> sendPrompt(
    Session session,
    String prompt, {
    int maxTokens = 1024,
  }) async {
    final apiKey = session.passwords['anthropicApiKey'];
    if (apiKey == null || apiKey.isEmpty) {
      throw StateError(
        'anthropicApiKey no configurada en passwords.yaml (shared).',
      );
    }

    final response = await http.post(
      Uri.parse(_endpoint),
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': apiKey,
        'anthropic-version': _apiVersion,
      },
      body: jsonEncode({
        'model': _model,
        'max_tokens': maxTokens,
        'messages': [
          {'role': 'user', 'content': prompt},
        ],
      }),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Error llamando a Anthropic (${response.statusCode}): ${response.body}',
      );
    }

    final data = jsonDecode(utf8.decode(response.bodyBytes));
    final content = data['content'] as List<dynamic>;

    final textBlock = content.firstWhere(
      (block) => block['type'] == 'text',
      orElse: () => null,
    );

    if (textBlock == null) {
      throw Exception('La respuesta de Anthropic no contiene texto.');
    }

    return textBlock['text'] as String;
  }
}
