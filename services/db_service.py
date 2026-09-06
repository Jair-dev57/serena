import sqlite3
from pathlib import Path

from models.exercise import Exercise, Difficulty, ExerciseCategory

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
