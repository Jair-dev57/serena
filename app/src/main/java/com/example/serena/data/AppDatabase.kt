package com.example.serena.data

import android.content.Context
import androidx.room.Database
import androidx.room.Room
import androidx.room.RoomDatabase
import androidx.room.TypeConverters

@Database(
    entities = [
        ExerciseEntity::class,
        RecordingEntity::class,
        PracticeSessionEntity::class,
        UserPreferencesEntity::class,
        BlockEntryEntity::class
    ],
    version = 5,
    exportSchema = false
)
@TypeConverters(Converters::class)
abstract class AppDatabase : RoomDatabase() {
    abstract fun exerciseDao(): ExerciseDao
    abstract fun recordingDao(): RecordingDao
    abstract fun practiceSessionDao(): PracticeSessionDao
    abstract fun userPreferencesDao(): UserPreferencesDao
    abstract fun blockEntryDao(): BlockEntryDao

    companion object {
        @Volatile
        private var INSTANCE: AppDatabase? = null

        fun getInstance(context: Context): AppDatabase {
            return INSTANCE ?: synchronized(this) {
                val instance = Room.databaseBuilder(
                    context.applicationContext,
                    AppDatabase::class.java,
                    "serena.db"
                )
                    .fallbackToDestructiveMigration(false)
                    .build()
                INSTANCE = instance
                instance
            }
        }
    }
}