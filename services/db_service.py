import random
import sqlite3
from datetime import date, datetime, timedelta
from pathlib import Path

from models.exercise import Exercise, Difficulty, ExerciseCategory
from models.practice_session import PracticeSession

DB_PATH = Path(__file__).parent.parent / "data" / "serena.db"

SEED_EXERCISES = [
    ("Respiración 4-7-8", "Sostén", "Calma el ritmo antes de hablar", 5,
     Difficulty.SUAVE, ExerciseCategory.RESPIRACION, "air"),
    ("Lectura pausada", "Lectura", "Practica leyendo con calma", 8,
     Difficulty.SUAVE, ExerciseCategory.LECTURA, "menu_book"),
    ("Sílabas rítmicas", "Ritmo", "Marca el ritmo de las sílabas", 6,
     Difficulty.MEDIO, ExerciseCategory.HABLA, "graphic_eq"),
    ("Inicio suave de palabra", "Inicio", "Suaviza el comienzo al hablar", 7,
     Difficulty.MEDIO, ExerciseCategory.HABLA, "mic"),
    ("Conversación guiada", "Charla", "Practica en una conversación real", 10,
     Difficulty.RETADOR, ExerciseCategory.HABLA, "chat_bubble"),
    ("Lectura con metrónomo", "Metrónomo", "Lee siguiendo un ritmo constante", 8,
     Difficulty.MEDIO, ExerciseCategory.LECTURA, "graphic_eq"),
]

WEEKDAY_LABELS = ["L", "M", "X", "J", "V", "S", "D"]


def get_connection() -> sqlite3.Connection:
    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row
    return conn


def init_db() -> None:
    conn = get_connection()
    conn.execute("""
        CREATE TABLE IF NOT EXISTS exercises (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            short_name TEXT NOT NULL,
            description TEXT NOT NULL,
            duration_minutes INTEGER NOT NULL,
            difficulty TEXT NOT NULL,
            category TEXT NOT NULL,
            icon TEXT NOT NULL,
            completed INTEGER NOT NULL DEFAULT 0
        )
    """)
    conn.execute("""
        CREATE TABLE IF NOT EXISTS practice_sessions (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            exercise_id INTEGER NOT NULL,
            completed_at TEXT NOT NULL,
            duration_minutes INTEGER NOT NULL,
            fluency_score INTEGER NOT NULL
        )
    """)
    conn.commit()

    count = conn.execute("SELECT COUNT(*) FROM exercises").fetchone()[0]
    if count == 0:
        conn.executemany(
            """
            INSERT INTO exercises
                (name, short_name, description, duration_minutes, difficulty, category, icon)
            VALUES (?, ?, ?, ?, ?, ?, ?)
            """,
            [
                (name, short_name, description, duration, difficulty.value, category.value, icon)
                for name, short_name, description, duration, difficulty, category, icon in SEED_EXERCISES
            ],
        )
        conn.commit()

    conn.close()


def get_all_exercises() -> list[Exercise]:
    conn = get_connection()
    rows = conn.execute("SELECT * FROM exercises ORDER BY id").fetchall()
    conn.close()

    return [
        Exercise(
            id=row["id"],
            name=row["name"],
            short_name=row["short_name"],
            description=row["description"],
            duration_minutes=row["duration_minutes"],
            difficulty=Difficulty(row["difficulty"]),
            category=ExerciseCategory(row["category"]),
            icon=row["icon"],
            completed=bool(row["completed"]),
        )
        for row in rows
    ]


def mark_completed(exercise_id: int, completed: bool = True) -> None:
    conn = get_connection()
    conn.execute(
        "UPDATE exercises SET completed = ? WHERE id = ?",
        (int(completed), exercise_id),
    )
    conn.commit()
    conn.close()


def record_session(exercise_id: int, duration_minutes: int, fluency_score: int = None) -> None:
    if fluency_score is None:
        fluency_score = random.randint(65, 92)
    conn = get_connection()
    conn.execute(
        "INSERT INTO practice_sessions (exercise_id, completed_at, duration_minutes, fluency_score) VALUES (?, ?, ?, ?)",
        (exercise_id, datetime.now().isoformat(), duration_minutes, fluency_score),
    )
    conn.commit()
    conn.close()


def get_all_sessions() -> list[PracticeSession]:
    conn = get_connection()
    rows = conn.execute("SELECT * FROM practice_sessions ORDER BY completed_at").fetchall()
    conn.close()
    return [
        PracticeSession(
            id=row["id"],
            exercise_id=row["exercise_id"],
            completed_at=datetime.fromisoformat(row["completed_at"]),
            duration_minutes=row["duration_minutes"],
            fluency_score=row["fluency_score"],
        )
        for row in rows
    ]


def get_streak_days() -> int:
    sessions = get_all_sessions()
    if not sessions:
        return 0
    session_dates = {s.completed_at.date() for s in sessions}
    streak = 0
    current_day = date.today()
    while current_day in session_dates:
        streak += 1
        current_day -= timedelta(days=1)
    return streak


def get_minutes_this_week() -> int:
    sessions = get_all_sessions()
    today = date.today()
    week_start = today - timedelta(days=today.weekday())
    return sum(s.duration_minutes for s in sessions if s.completed_at.date() >= week_start)


def get_minutes_per_day_last_7() -> list[tuple[str, int]]:
    sessions = get_all_sessions()
    today = date.today()
    days = [today - timedelta(days=i) for i in range(6, -1, -1)]
    result = []
    for d in days:
        total = sum(s.duration_minutes for s in sessions if s.completed_at.date() == d)
        result.append((WEEKDAY_LABELS[d.weekday()], total))
    return result


def get_recent_fluency_scores(n: int = 6) -> list[int]:
    sessions = get_all_sessions()
    scores = [s.fluency_score for s in sessions[-n:]]
    return scores if scores else [60]


def get_average_fluency() -> int:
    scores = get_recent_fluency_scores(10)
    return round(sum(scores) / len(scores))
