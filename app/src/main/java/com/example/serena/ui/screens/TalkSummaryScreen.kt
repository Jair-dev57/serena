package com.example.serena.ui.screens

import android.media.MediaPlayer
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Check
import androidx.compose.material.icons.filled.PlayArrow
import androidx.compose.material3.Icon
import androidx.compose.material3.Text
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.example.serena.data.RecordingEntity
import com.example.serena.ui.theme.*

@Composable
fun TalkSummaryScreen(
    recordings: List<RecordingEntity>,
    prompts: List<String>,
    onDone: () -> Unit
) {
    var player by remember { mutableStateOf<MediaPlayer?>(null) }

    DisposableEffect(Unit) {
        onDispose { player?.release() }
    }

    fun play(path: String) {
        player?.release()
        player = MediaPlayer().apply {
            setDataSource(path)
            prepare()
            start()
        }
    }

    Column(
        modifier = Modifier
            .fillMaxSize()
            .background(BgPage)
            .padding(20.dp)
    ) {
        Spacer(modifier = Modifier.height(20.dp))
        Box(
            modifier = Modifier.fillMaxWidth(),
            contentAlignment = Alignment.Center
        ) {
            Box(
                modifier = Modifier
                    .size(56.dp)
                    .background(GreenSuccess, shape = CircleShape),
                contentAlignment = Alignment.Center
            ) {
                Icon(Icons.Filled.Check, contentDescription = null, tint = BgPage, modifier = Modifier.size(26.dp))
            }
        }
        Spacer(modifier = Modifier.height(12.dp))
        Text(
            "Ejercicio completado",
            color = TextPrimary,
            fontSize = 17.sp,
            fontWeight = FontWeight.Bold,
            textAlign = TextAlign.Center,
            modifier = Modifier.fillMaxWidth()
        )
        Text(
            "${recordings.size} respuestas grabadas",
            color = TextSecondary,
            fontSize = 12.sp,
            textAlign = TextAlign.Center,
            modifier = Modifier.fillMaxWidth()
        )
        Spacer(modifier = Modifier.height(16.dp))
        Box(modifier = Modifier.fillMaxWidth().height(1.dp).background(BgCardIcon))
        Spacer(modifier = Modifier.height(16.dp))
        Text("TUS RESPUESTAS", color = BlueAccent, fontSize = 11.sp)
        Spacer(modifier = Modifier.height(10.dp))

        Column(
            modifier = Modifier.weight(1f),
            verticalArrangement = Arrangement.spacedBy(10.dp)
        ) {
            recordings.forEachIndexed { index, recording ->
                Row(
                    modifier = Modifier
                        .fillMaxWidth()
                        .background(BgCard, shape = RoundedCornerShape(12.dp))
                        .clickable { play(recording.filePath) }
                        .padding(12.dp),
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Box(
                        modifier = Modifier
                            .size(32.dp)
                            .background(BlueAccent, shape = CircleShape),
                        contentAlignment = Alignment.Center
                    ) {
                        Icon(Icons.Filled.PlayArrow, contentDescription = null, tint = BgPage, modifier = Modifier.size(16.dp))
                    }
                    Spacer(modifier = Modifier.width(10.dp))
                    Column {
                        val promptText = prompts.getOrElse(index) { "Respuesta ${index + 1}" }
                        Text(
                            promptText.take(30) + if (promptText.length > 30) "..." else "",
                            color = TextPrimary,
                            fontSize = 12.sp,
                            fontWeight = FontWeight.Bold
                        )
                    }
                }
            }
        }

        Spacer(modifier = Modifier.height(16.dp))
        Box(
            modifier = Modifier
                .fillMaxWidth()
                .background(BlueAccent, shape = RoundedCornerShape(14.dp))
                .clickable { onDone() }
                .padding(vertical = 14.dp),
            contentAlignment = Alignment.Center
        ) {
            Text("Volver a Inicio", color = BgPage, fontSize = 14.sp, fontWeight = FontWeight.Bold)
        }
    }
}