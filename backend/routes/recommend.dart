import 'package:dart_frog/dart_frog.dart';

import '../lib/src/models.dart';
import '../lib/src/recommender_service.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    return Response.json(
      statusCode: 405,
      body: {'detail': 'Método no permitido, usá POST'},
    );
  }

  final Map<String, dynamic> json;
  try {
    json = await context.request.json() as Map<String, dynamic>;
  } catch (e) {
    return Response.json(statusCode: 400, body: {'detail': 'JSON inválido: $e'});
  }

  final RecommendRequest payload;
  try {
    payload = RecommendRequest.fromJson(json);
  } catch (e) {
    return Response.json(statusCode: 400, body: {'detail': 'Payload inválido: $e'});
  }

  final service = context.read<RecommenderService>();

  try {
    final result = await service.recommend(payload);
    return Response.json(body: result.toJson());
  } on RecommendationException catch (e) {
    return Response.json(statusCode: e.statusCode, body: {'detail': e.message});
  }
}