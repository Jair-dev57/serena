package com.example.serena.data

import androidx.room.Entity
import androidx.room.PrimaryKey

enum class BlockIntensity(val label: String) {
    LEVE("Leve"),
    MEDIO("Medio"),
    FUERTE("Fuerte")
}

@Entity(tableName = "block_entries")
data class BlockEntryEntity(
    @PrimaryKey(autoGenerate = true) val id: Int = 0,
    val word: String,
    val situation: String,
    val intensity: BlockIntensity,
    val createdAt: Long
)