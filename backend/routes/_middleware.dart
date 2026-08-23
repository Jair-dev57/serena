import 'package:dart_frog/dart_frog.dart';
import 'package:dotenv/dotenv.dart' as dotenv;

import '../lib/src/recommender_service.dart';

Handler middleware(Handler handler) {
  final env = dotenv.DotEnv(includePlatformEnvironment: true);
  try {
    env.load();
  } catch (_) {
    // No hay archivo .env local (ej. en producción, donde las variables las
    // inyecta el hosting directamente). No es un error, seguimos con
    // includePlatformEnvironment.
  }

  final apiKey = env['ANTHROPIC_API_KEY'];
  if (apiKey == null || apiKey.isEmpty) {
    throw StateError(
      'Falta la variable de entorno ANTHROPIC_API_KEY. '
      'Creá un .env en backend/ (ver .env.example) o configurala en tu hosting.',
    );
  }

  final service = RecommenderService(apiKey: apiKey);

  return handler.use(provider<RecommenderService>((_) => service));
}