import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../services/recommendation_service.dart';

class RecommendationEndpoint extends Endpoint {
  /// Devuelve una recomendación de práctica (mensaje + ejercicio puntual) si
  /// hubo bloqueos en la última semana, o `null` si no hace falta recomendar nada.
  Future<RecommendationResult?> getRecommendation(Session session) async {
    return RecommendationService.getRecommendation(session);
  }
}
