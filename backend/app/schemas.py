from typing import Literal

from pydantic import BaseModel, Field


class ExerciseInfo(BaseModel):
    id: str
    title: str
    category: str
    difficulty: str


class ProgressInfo(BaseModel):
    exercise_id: str
    times_completed: int


class BlockInfo(BaseModel):
    severity: Literal["leve", "moderado", "fuerte"]
    context: str
    days_ago: int


class DifficultWordInfo(BaseModel):
    word: str
    note: str | None = None


class RecommendRequest(BaseModel):
    exercises: list[ExerciseInfo] = Field(..., description="Catálogo completo de ejercicios disponibles")
    progress: list[ProgressInfo] = Field(default_factory=list)
    recent_blocks: list[BlockInfo] = Field(default_factory=list)
    difficult_words: list[DifficultWordInfo] = Field(default_factory=list)
    current_streak: int = 0
    weekly_sessions: int = 0
    weekly_target: int = 0


class RecommendResponse(BaseModel):
    recommended_exercise_id: str
    reason: str