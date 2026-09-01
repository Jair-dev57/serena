import 'dart:convert';
import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import 'anthropic_service.dart';

/// Arma una recomendación de práctica personalizada usando Claude,
/// en base al historial reciente del usuario en Serena.
class RecommendationService {
  /// Devuelve `null` si no hay bloqueos recientes (no hace falta recomendar nada).
  /// Si hay bloqueos, devuelve el mensaje + el ejercicio puntual recomendado.
  static Future<RecommendationResult?> getRecommendation(
    Session session,
  ) async {
    final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));

    final recentBlocks = await BlockEntry.db.find(
      session,
      where: (t) => t.dateTime > sevenDaysAgo,
      orderBy: (t) => t.dateTime,
      orderDescending: true,
    );

    // Si no hubo bloqueos en la última semana, no hace falta molestar al usuario.
    if (recentBlocks.isEmpty) return null;

    final exercises = await Exercise.db.find(session);
    final progress = await ExerciseProgress.db.find(session);
    final recentSessions = await PracticeSession.db.find(
      session,
      where: (t) => t.date > sevenDaysAgo,
      orderBy: (t) => t.date,
      orderDescending: true,
    );
    final difficultWords = await DifficultWord.db.find(session);

    final prompt = _buildPrompt(
      exercises: exercises,
      blocks: recentBlocks,
      progress: progress,
      sessions: recentSessions,
      difficultWords: difficultWords,
    );

    final rawResponse = await AnthropicService.sendPrompt(
      session,
      prompt,
      maxTokens: 200,
    );

    return _parseResponse(rawResponse, exercises);
  }

  static String _buildPrompt({
    required List<Exercise> exercises,
    required List<BlockEntry> blocks,
    required List<ExerciseProgress> progress,
    required List<PracticeSession> sessions,
    required List<DifficultWord> difficultWords,
  }) {
    final buffer = StringBuffer();
    buffer.writeln(
      'Sos un asistente dentro de Serena, una app de práctica de fluidez '
      'del habla para personas que tartamudean. Con el siguiente resumen '
      'de la última semana del usuario, elegí UN ejercicio puntual del '
      'catálogo de abajo y escribí un mensaje MUY breve (máximo 2 frases '
      'cortas, menos de 40 palabras en total, en español, tono cálido y '
      'directo, sin emojis) explicando por qué ese ejercicio le sirve. '
      'No des consejos médicos ni reemplaces terapia profesional.',
    );

    buffer.writeln('\nCatálogo de ejercicios disponibles (key: título):');
    for (final e in exercises) {
      buffer.writeln('- ${e.exerciseKey}: ${e.title}');
    }

    buffer.writeln('\nBloqueos de la última semana (${blocks.length}):');
    for (final b in blocks) {
      buffer.writeln(
        '- ${b.severity.name}, contexto: ${b.context.name}'
        '${b.note != null ? ", nota: ${b.note}" : ""}',
      );
    }

    buffer.writeln('\nProgreso por ejercicio:');
    if (progress.isEmpty) {
      buffer.writeln('- Sin ejercicios practicados todavía.');
    } else {
      for (final p in progress) {
        buffer.writeln(
          '- ${p.exerciseId}: ${p.timesCompleted} veces'
          '${p.lastCompletedAt != null ? ", última vez ${p.lastCompletedAt}" : ""}',
        );
      }
    }

    buffer.writeln(
      '\nSesiones de práctica de la última semana (${sessions.length}):',
    );
    for (final s in sessions) {
      buffer.writeln('- ${s.exerciseTitle} (${s.date})');
    }

    buffer.writeln('\nPalabras difíciles registradas:');
    if (difficultWords.isEmpty) {
      buffer.writeln('- Ninguna registrada.');
    } else {
      for (final w in difficultWords) {
        buffer.writeln('- ${w.word}${w.note != null ? " (${w.note})" : ""}');
      }
    }

    buffer.writeln(
      '\nRespondé ÚNICAMENTE con un JSON válido, sin texto extra ni '
      'bloques de markdown, con este formato exacto: '
      '{"mensaje": "...", "exerciseKey": "..."}. '
      'El valor de exerciseKey tiene que ser EXACTAMENTE uno de los keys '
      'listados arriba en el catálogo.',
    );

    return buffer.toString();
  }

  static RecommendationResult? _parseResponse(
    String rawResponse,
    List<Exercise> exercises,
  ) {
    // Por si Claude envuelve la respuesta en ```json ... ```, lo limpiamos.
    final cleaned = rawResponse
        .replaceAll('```json', '')
        .replaceAll('```', '')
        .trim();

    try {
      final json = jsonDecode(cleaned) as Map<String, dynamic>;
      final message = json['mensaje'] as String?;
      final exerciseKey = json['exerciseKey'] as String?;

      if (message == null || exerciseKey == null) return null;

      // Validamos que el key exista de verdad en el catálogo.
      final validKey = exercises.any((e) => e.exerciseKey == exerciseKey);
      if (!validKey) return null;

      return RecommendationResult(message: message, exerciseKey: exerciseKey);
    } catch (_) {
      return null;
    }
  }
}
