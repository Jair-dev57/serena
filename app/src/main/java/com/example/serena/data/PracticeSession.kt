package com.example.serena.data

import androidx.room.Entity
import androidx.room.PrimaryKey

@Entity(tableName = "practice_sessions")
data class PracticeSessionEntity(
    @PrimaryKey(autoGenerate = true) val id: Int = 0,
    val exerciseId: Int,
    val completedAt: Long,
    val durationMinutes: Int,
    val fluencyScore: Int
)