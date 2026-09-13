package com.example.serena.data

import androidx.room.Dao
import androidx.room.Insert
import androidx.room.Query

@Dao
interface BlockEntryDao {
    @Insert
    suspend fun insert(entry: BlockEntryEntity)

    @Query("SELECT * FROM block_entries ORDER BY createdAt DESC")
    suspend fun getAll(): List<BlockEntryEntity>
}