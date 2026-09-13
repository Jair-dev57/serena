package com.example.serena.data

import androidx.room.Dao
import androidx.room.Insert
import androidx.room.Query

@Dao
interface ExerciseDao {
    @Query("SELECT * FROM exercises ORDER BY id")
    suspend fun getAllExercises(): List<ExerciseEntity>

    @Query("UPDATE exercises SET completed = :completed WHERE id = :exerciseId")
    suspend fun setCompleted(exerciseId: Int, completed: Boolean)

    @Insert
    suspend fun insertAll(exercises: List<ExerciseEntity>)

    @Query("SELECT COUNT(*) FROM exercises")
    suspend fun countExercises(): Int
}