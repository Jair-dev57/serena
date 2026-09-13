package com.example.serena.data
import androidx.room.TypeConverter

class Converters {
    @TypeConverter
    fun fromDifficulty(value: Difficulty): String = value.name

    @TypeConverter
    fun toDifficulty(value: String): Difficulty = Difficulty.valueOf(value)

    @TypeConverter
    fun fromCategory(value: ExerciseCategory): String = value.name

    @TypeConverter
    fun toCategory(value: String): ExerciseCategory = ExerciseCategory.valueOf(value)

    @TypeConverter
    fun fromBlockIntensity(value: BlockIntensity): String = value.name

    @TypeConverter
    fun toBlockIntensity(value: String): BlockIntensity = BlockIntensity.valueOf(value)
}