package com.example.serena.data

import androidx.room.Entity
import androidx.room.PrimaryKey

enum class Difficulty(val label: String) {
    SUAVE("Suave"),
    MEDIO("Medio"),
    RETADOR("Retador")
}

enum class ExerciseCategory(val label: String) {
    RESPIRACION("Respiracion"),
    LECTURA("Lectura"),
    HABLA("Habla"),
    CONCIENCIACION("Concienciacion")
}

@Entity(tableName = "exercises")
data class ExerciseEntity(
    @PrimaryKey(autoGenerate = true) val id: Int = 0,
    val name: String,
    val shortName: String,
    val description: String,
    val durationMinutes: Int,
    val difficulty: Difficulty,
    val category: ExerciseCategory,
    val icon: String,
    val completed: Boolean = false
)