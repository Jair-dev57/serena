import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class PracticeSessionEndpoint extends Endpoint {
  Future<List<PracticeSession>> getAllSessions(Session session) async {
    return PracticeSession.db.find(
      session,
      orderBy: (t) => t.date,
      orderDescending: true,
    );
  }

  Future<PracticeSession> insertSession(
    Session session,
    String exerciseTitle,
    DateTime date,
  ) async {
    final newSession = PracticeSession(
      exerciseTitle: exerciseTitle,
      date: date,
    );
    return PracticeSession.db.insertRow(session, newSession);
  }

  Future<int> getCurrentStreak(Session session) async {
    final sessions = await getAllSessions(session);
    if (sessions.isEmpty) return 0;
    final days = sessions
        .map((s) => DateTime(s.date.year, s.date.month, s.date.day))
        .toSet();
    int streak = 0;
    DateTime cursor = DateTime.now();
    cursor = DateTime(cursor.year, cursor.month, cursor.day);
    while (days.contains(cursor)) {
      streak++;
      cursor = cursor.subtract(const Duration(days: 1));
    }
    return streak;
  }
}