from dataclasses import dataclass
from enum import Enum


class Difficulty(Enum):
    SUAVE = "Suave"
    MEDIO = "Medio"
    RETADOR = "Retador"


class ExerciseCategory(Enum):
    RESPIRACION = "Respiración"
    LECTURA = "Lectura"
    HABLA = "Habla"


@dataclass
class Exercise:
    id: int
    name: str
    short_name: str
    description: str
    duration_minutes: int
    difficulty: Difficulty
    category: ExerciseCategory
    icon: str
    completed: bool = False
