import '../generated/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'anthropic_service.dart';

/// Genera y guarda un resumen semanal (lunes a lunes) del progreso del
/// usuario en Serena, comparando la semana actual con la anterior.
class WeeklySummaryService {
  /// Devuelve el resumen de la semana actual. Si ya existe uno guardado
  /// para esta semana, lo reutiliza en vez de volver a llamar a Claude.
  static Future<WeeklySummary> getOrGenerate(Session session) async {
    final weekStart = _mostRecentMonday(DateTime.now());

    final existing = await WeeklySummary.db.findFirstRow(
      session,
      where: (t) => t.weekStartDate.equals(weekStart),
    );
    if (existing != null) return existing;

    final summaryText = await _generateSummary(session, weekStart);

    final newSummary = WeeklySummary(
      weekStartDate: weekStart,
      summaryText: summaryText,
      createdAt: DateTime.now(),
    );
    return WeeklySummary.db.insertRow(session, newSummary);
  }

  /// Devuelve la medianoche del lunes de la semana de [date].
  static DateTime _mostRecentMonday(DateTime date) {
    final daysSinceMonday = date.weekday - DateTime.monday;
    final monday = date.subtract(Duration(days: daysSinceMonday));
    return DateTime(monday.year, monday.month, monday.day);
  }

  static Future<String> _generateSummary(
    Session session,
    DateTime weekStart,
  ) async {
    final previousWeekStart = weekStart.subtract(const Duration(days: 7));

    final thisWeekBlocks = await BlockEntry.db.find(
      session,
      where: (t) => t.dateTime >= weekStart,
      orderBy: (t) => t.dateTime,
    );
    final lastWeekBlocks = await BlockEntry.db.find(
      session,
      where: (t) => (t.dateTime >= previousWeekStart) & (t.dateTime < weekStart),
      orderBy: (t) => t.dateTime,
    );
    final thisWeekSessions = await PracticeSession.db.find(
      session,
      where: (t) => t.date >= weekStart,
    );
    final lastWeekSessions = await PracticeSession.db.find(
      session,
      where: (t) => (t.date >= previousWeekStart) & (t.date < weekStart),
    );

    final prompt = _buildPrompt(
      thisWeekBlocks: thisWeekBlocks,
      lastWeekBlocks: lastWeekBlocks,
      thisWeekSessions: thisWeekSessions,
      lastWeekSessions: lastWeekSessions,
    );

    return AnthropicService.sendPrompt(session, prompt, maxTokens: 200);
  }

  static String _buildPrompt({
    required List<BlockEntry> thisWeekBlocks,
    required List<BlockEntry> lastWeekBlocks,
    required List<PracticeSession> thisWeekSessions,
    required List<PracticeSession> lastWeekSessions,
  }) {
    final buffer = StringBuffer();
    buffer.writeln(
      'Sos un asistente dentro de Serena, una app de práctica de fluidez '
      'del habla para personas que tartamudean. Con los datos de esta '
      'semana comparados con la semana anterior, escribí un resumen breve '
      '(máximo 3 frases cortas, menos de 55 palabras, en español, tono '
      'cálido y objetivo, sin emojis) sobre cómo viene la semana del '
      'usuario. No es un diagnóstico médico ni reemplaza terapia '
      'profesional, así que no uses lenguaje clínico ni alarmante.',
    );

    buffer.writeln('\nEsta semana:');
    buffer.writeln('- Bloqueos: ${thisWeekBlocks.length}');
    buffer.writeln(
      '- Severidades: '
      '${thisWeekBlocks.map((b) => b.severity.name).join(", ")}',
    );
    buffer.writeln('- Sesiones de práctica: ${thisWeekSessions.length}');

    buffer.writeln('\nSemana anterior:');
    buffer.writeln('- Bloqueos: ${lastWeekBlocks.length}');
    buffer.writeln(
      '- Severidades: '
      '${lastWeekBlocks.map((b) => b.severity.name).join(", ")}',
    );
    buffer.writeln('- Sesiones de práctica: ${lastWeekSessions.length}');

    return buffer.toString();
  }
}
