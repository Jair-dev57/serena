from functools import lru_cache
import json

from anthropic import Anthropic
from fastapi import HTTPException

from app.config import get_settings
from app.prompts import build_recommendation_prompt
from app.schemas import RecommendRequest, RecommendResponse


class RecommenderService:
    def __init__(self) -> None:
        settings = get_settings()
        self._client = Anthropic(api_key=settings.anthropic_api_key)
        self._model = settings.claude_model

    def recommend(self, payload: RecommendRequest) -> RecommendResponse:
        if not payload.exercises:
            raise HTTPException(status_code=400, detail="No se envió el catálogo de ejercicios")

        valid_ids = {exercise.id for exercise in payload.exercises}

        message = self._client.messages.create(
            model=self._model,
            max_tokens=300,
            messages=[{"role": "user", "content": build_recommendation_prompt(payload)}],
        )
        raw_text = "".join(block.text for block in message.content if block.type == "text").strip()

        try:
            parsed = json.loads(raw_text)
            result = RecommendResponse(**parsed)
        except (json.JSONDecodeError, TypeError, ValueError) as exc:
            raise HTTPException(status_code=502, detail=f"Respuesta inválida del modelo: {exc}") from exc

        if result.recommended_exercise_id not in valid_ids:
            raise HTTPException(status_code=502, detail="El modelo recomendó un ejercicio inexistente")

        return result


@lru_cache
def get_recommender_service() -> RecommenderService:
    return RecommenderService()