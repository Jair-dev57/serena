import 'package:shared_preferences/shared_preferences.dart';
import 'package:serena_client/serena_client.dart' show PracticeSession;

class WeeklyGoalManager {
  static const String _key = 'weeklyGoalTarget';
  static const int defaultTarget = 3;
  static const int minTarget = 1;
  static const int maxTarget = 7;

  static Future<int> getTarget() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_key) ?? defaultTarget;
  }

  static Future<void> setTarget(int target) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_key, target.clamp(minTarget, maxTarget));
  }

  /// Lunes de la semana que contiene [date] (a medianoche).
  static DateTime startOfWeek(DateTime date) {
    final day = DateTime(date.year, date.month, date.day);
    return day.subtract(Duration(days: day.weekday - 1));
  }

  /// Cuenta días únicos con al menos una sesión practicada desde el lunes actual.
  /// Usa días únicos (no sesiones totales) para que sea consistente con la racha
  /// y no se pueda "trampear" la meta repitiendo el mismo ejercicio varias veces el mismo día.
  static int sessionsThisWeek(List<PracticeSession> sessions, {DateTime? now}) {
    final reference = now ?? DateTime.now();
    final start = startOfWeek(reference);
    final uniqueDays = sessions
        .where((s) => !s.date.isBefore(start))
        .map((s) => DateTime(s.date.year, s.date.month, s.date.day))
        .toSet();
    return uniqueDays.length;
  }
}