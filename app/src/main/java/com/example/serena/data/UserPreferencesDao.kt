package com.example.serena.data

import androidx.room.Dao
import androidx.room.Query
import androidx.room.Upsert

@Dao
interface UserPreferencesDao {
    @Query("SELECT * FROM user_preferences WHERE id = 1")
    suspend fun get(): UserPreferencesEntity?

    @Upsert
    suspend fun save(preferences: UserPreferencesEntity)
}