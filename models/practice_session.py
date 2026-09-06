from dataclasses import dataclass
from datetime import datetime


@dataclass
class PracticeSession:
    id: int
    exercise_id: int
    completed_at: datetime
    duration_minutes: int
    fluency_score: int
