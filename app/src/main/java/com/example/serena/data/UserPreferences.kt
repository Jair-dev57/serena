package com.example.serena.data

import androidx.room.Entity
import androidx.room.PrimaryKey

@Entity(tableName = "user_preferences")
data class UserPreferencesEntity(
    @PrimaryKey val id: Int = 1,
    val dailyGoal: Int = 15,
    val remindersEnabled: Boolean = true,
    val soundsEnabled: Boolean = true,
    val shareTherapist: Boolean = false
)