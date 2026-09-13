package com.example.serena.data

import androidx.room.Dao
import androidx.room.Insert
import androidx.room.Query

@Dao
interface RecordingDao {
    @Insert
    suspend fun insert(recording: RecordingEntity): Long

    @Query("SELECT * FROM recordings WHERE exerciseId = :exerciseId ORDER BY id DESC LIMIT 1")
    suspend fun getLatestForExercise(exerciseId: Int): RecordingEntity?
}