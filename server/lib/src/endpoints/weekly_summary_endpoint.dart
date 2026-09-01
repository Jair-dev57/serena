import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../services/weekly_summary_service.dart';

class WeeklySummaryEndpoint extends Endpoint {
  /// Devuelve el resumen de la semana actual (lunes a lunes). Si todavía
  /// no existe uno para esta semana, lo genera con Claude y lo guarda.
  Future<WeeklySummary> getSummary(Session session) async {
    return WeeklySummaryService.getOrGenerate(session);
  }
}
