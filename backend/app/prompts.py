import json

from app.schemas import RecommendRequest

RECOMMENDATION_INSTRUCTIONS = """\
Elegí el ejercicio más útil para practicar AHORA, considerando:
- Si hay bloqueos fuertes muy recientes, priorizá algo calmante (Respiración) antes que nada.
- Si hay un contexto de bloqueo repetido (ej. llamadas, público), priorizá la categoría más \
relacionada con ese contexto.
- Si hay palabras difíciles marcadas, considerá ejercicios de Inicio suave o Lectura guiada.
- Si nada de lo anterior aplica claramente, recomendá el ejercicio con menos veces completado \
para variar la práctica.

Respondé ÚNICAMENTE con un JSON válido, sin texto adicional, con este formato exacto:
{"recommended_exercise_id": "<id del ejercicio elegido>", "reason": "<explicación breve, en \
español, de 1-2 oraciones, hablándole directamente a la persona>"}"""


def build_recommendation_prompt(payload: RecommendRequest) -> str:
    exercises_json = json.dumps([e.model_dump() for e in payload.exercises], ensure_ascii=False)
    progress_json = json.dumps([p.model_dump() for p in payload.progress], ensure_ascii=False)
    blocks_json = json.dumps([b.model_dump() for b in payload.recent_blocks], ensure_ascii=False)
    words_json = json.dumps([w.model_dump() for w in payload.difficult_words], ensure_ascii=False)

    return f"""Sos el motor de recomendaciones de Serena, una app de práctica de fluidez \
del habla para personas con tartamudez. Tu única tarea es elegir UN ejercicio del \
catálogo para recomendarle a la persona en este momento, y explicar brevemente por qué.

Catálogo de ejercicios disponibles (elegí el "id" de uno de estos, ninguno más):
{exercises_json}

Progreso de la persona por ejercicio (times_completed = veces que lo completó):
{progress_json}

Bloqueos del habla registrados recientemente (days_ago = hace cuántos días fue):
{blocks_json}

Palabras que la persona marcó como difíciles:
{words_json}

Racha actual: {payload.current_streak} días.
Sesiones esta semana: {payload.weekly_sessions} de una meta de {payload.weekly_target}.

{RECOMMENDATION_INSTRUCTIONS}"""