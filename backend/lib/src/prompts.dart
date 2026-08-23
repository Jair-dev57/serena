import 'dart:convert';

import 'models.dart';

const String recommendationInstructions = '''
Elegí el ejercicio más útil para practicar AHORA, considerando:
- Si hay bloqueos fuertes muy recientes, priorizá algo calmante (Respiración) antes que nada.
- Si hay un contexto de bloqueo repetido (ej. llamadas, público), priorizá la categoría más relacionada con ese contexto.
- Si hay palabras difíciles marcadas, considerá ejercicios de Inicio suave o Lectura guiada.
- Si nada de lo anterior aplica claramente, recomendá el ejercicio con menos veces completado para variar la práctica.

Respondé ÚNICAMENTE con un JSON válido, sin texto adicional, con este formato exacto:
{"recommended_exercise_id": "<id del ejercicio elegido>", "reason": "<explicación breve, en español, de 1-2 oraciones, hablándole directamente a la persona>"}''';

String buildRecommendationPrompt(RecommendRequest payload) {
  final exercisesJson = jsonEncode(payload.exercises.map((e) => e.toJson()).toList());
  final progressJson = jsonEncode(payload.progress.map((e) => e.toJson()).toList());
  final blocksJson = jsonEncode(payload.recentBlocks.map((e) => e.toJson()).toList());
  final wordsJson = jsonEncode(payload.difficultWords.map((e) => e.toJson()).toList());

  return '''
Sos el motor de recomendaciones de Serena, una app de práctica de fluidez del habla para personas con tartamudez. Tu única tarea es elegir UN ejercicio del catálogo para recomendarle a la persona en este momento, y explicar brevemente por qué.

Catálogo de ejercicios disponibles (elegí el "id" de uno de estos, ninguno más):
$exercisesJson

Progreso de la persona por ejercicio (times_completed = veces que lo completó):
$progressJson

Bloqueos del habla registrados recientemente (days_ago = hace cuántos días fue):
$blocksJson

Palabras que la persona marcó como difíciles:
$wordsJson

Racha actual: ${payload.currentStreak} días.
Sesiones esta semana: ${payload.weeklySessions} de una meta de ${payload.weeklyTarget}.

$recommendationInstructions''';
}