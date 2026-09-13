package com.example.serena.ui.screens

import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Text
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.example.serena.data.AppDatabase
import com.example.serena.data.BlockEntryEntity
import com.example.serena.data.BlockIntensity
import com.example.serena.ui.theme.*
import kotlinx.coroutines.launch
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

private data class WordSummary(val word: String, val count: Int, val mostCommonSituation: String, val latestIntensity: BlockIntensity)

private fun summarize(entries: List<BlockEntryEntity>): List<WordSummary> {
    return entries.groupBy { it.word.lowercase() }
        .map { (word, group) ->
            val mostCommonSituation = group.groupBy { it.situation }
                .maxByOrNull { it.value.size }?.key ?: ""
            val latest = group.maxByOrNull { it.createdAt }!!
            WordSummary(word, group.size, mostCommonSituation, latest.intensity)
        }
        .sortedByDescending { it.count }
}

private fun intensityColor(intensity: BlockIntensity) = when (intensity) {
    BlockIntensity.LEVE -> GreenSuccess
    BlockIntensity.MEDIO -> AmberMedium
    BlockIntensity.FUERTE -> RedChallenging
}

@Composable
fun BlockJournalScreen() {
    val context = LocalContext.current
    val db = remember { AppDatabase.getInstance(context) }
    val scope = rememberCoroutineScope()

    var entries by remember { mutableStateOf(listOf<BlockEntryEntity>()) }
    var showForm by remember { mutableStateOf(false) }

    suspend fun reload() {
        entries = db.blockEntryDao().getAll()
    }

    LaunchedEffect(Unit) { reload() }

    if (showForm) {
        AddBlockEntryScreen(
            onCancel = { showForm = false },
            onSave = { word, situation, intensity ->
                scope.launch {
                    db.blockEntryDao().insert(
                        BlockEntryEntity(
                            word = word,
                            situation = situation,
                            intensity = intensity,
                            createdAt = System.currentTimeMillis()
                        )
                    )
                    reload()
                    showForm = false
                }
            }
        )
        return
    }

    val summaries = summarize(entries)
    val dateFormat = remember { SimpleDateFormat("d MMM, HH:mm", Locale("es")) }

    Column(
        modifier = Modifier
            .fillMaxSize()
            .background(BgPage)
            .padding(horizontal = 20.dp, vertical = 16.dp)
    ) {
        Text("MI DIARIO", color = BlueAccent, fontSize = 11.sp)
        Text("Bloqueos", color = TextPrimary, fontSize = 22.sp, fontWeight = FontWeight.Bold)
        Spacer(modifier = Modifier.height(14.dp))

        Box(
            modifier = Modifier
                .fillMaxWidth()
                .background(BlueAccent, shape = RoundedCornerShape(12.dp))
                .clickable { showForm = true }
                .padding(vertical = 12.dp),
            contentAlignment = Alignment.Center
        ) {
            Text("+ Registrar bloqueo", color = BgPage, fontSize = 13.sp, fontWeight = FontWeight.Bold)
        }
        Spacer(modifier = Modifier.height(16.dp))

        LazyColumn(modifier = Modifier.weight(1f), verticalArrangement = Arrangement.spacedBy(10.dp)) {
            if (summaries.isNotEmpty()) {
                item {
                    Text("PALABRAS DIFICILES", color = BlueAccent, fontSize = 11.sp)
                }
                items(summaries) { summary ->
                    Row(
                        modifier = Modifier
                            .fillMaxWidth()
                            .background(BgCard, shape = RoundedCornerShape(12.dp))
                            .padding(12.dp),
                        horizontalArrangement = Arrangement.SpaceBetween,
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Column {
                            Text("\"${summary.word}\"", color = TextPrimary, fontSize = 13.sp, fontWeight = FontWeight.Bold)
                            Text(
                                "${summary.count} ${if (summary.count == 1) "vez" else "veces"} - ${summary.mostCommonSituation}",
                                color = TextSecondary,
                                fontSize = 10.sp
                            )
                        }
                        Box(
                            modifier = Modifier
                                .background(intensityColor(summary.latestIntensity), shape = RoundedCornerShape(8.dp))
                                .padding(horizontal = 8.dp, vertical = 3.dp)
                        ) {
                            Text(summary.latestIntensity.label, color = BgPage, fontSize = 9.sp, fontWeight = FontWeight.Bold)
                        }
                    }
                }
            } else {
                item {
                    Box(
                        modifier = Modifier
                            .fillMaxWidth()
                            .background(BgCard, shape = RoundedCornerShape(12.dp))
                            .padding(16.dp)
                    ) {
                        Text(
                            "Todavia no tenes registros. Agrega tu primer bloqueo para empezar a ver patrones.",
                            color = TextSecondary,
                            fontSize = 12.sp
                        )
                    }
                }
            }

            if (entries.isNotEmpty()) {
                item {
                    Spacer(modifier = Modifier.height(6.dp))
                    Text("REGISTROS RECIENTES", color = BlueAccent, fontSize = 11.sp)
                }
                items(entries.take(10)) { entry ->
                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.SpaceBetween,
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Text(
                            "\"${entry.word}\" - ${dateFormat.format(Date(entry.createdAt))}",
                            color = TextSecondary,
                            fontSize = 11.sp
                        )
                        Box(
                            modifier = Modifier
                                .size(8.dp)
                                .background(intensityColor(entry.intensity), shape = androidx.compose.foundation.shape.CircleShape)
                        )
                    }
                }
            }
        }
    }
}