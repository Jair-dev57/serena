package com.example.serena.data

import androidx.room.Dao
import androidx.room.Insert
import androidx.room.Query

@Dao
interface PracticeSessionDao {
    @Insert
    suspend fun insert(session: PracticeSessionEntity)

    @Query("SELECT * FROM practice_sessions ORDER BY completedAt")
    suspend fun getAll(): List<PracticeSessionEntity>
}