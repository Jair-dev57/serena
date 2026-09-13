package com.example.serena.ui.screens

import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Close
import androidx.compose.material.icons.filled.Pause
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
import com.example.serena.data.ExerciseEntity
import com.example.serena.ui.theme.*
import kotlinx.coroutines.delay
import android.media.AudioManager
import android.media.ToneGenerator
import androidx.compose.runtime.DisposableEffect

private val phrases = listOf(
    "El cielo se pintaba de naranja mientras el sol se escondia despacio.",
    "Camine tranquilo por el parque, sintiendo el aire fresco en mi cara.",
    "Cada palabra que digo la practico con calma y sin apuro.",
    "Hoy elijo hablar despacio, dandome el tiempo que necesito.",
    "El agua del rio corria suave entre las piedras grises.",
    "Respire profundo antes de empezar a contar mi historia."
)

@Composable
fun ReadingScreen(
    exercise: ExerciseEntity,
    onFinish: (ExerciseEntity?) -> Unit
) {
    var phraseIndex by remember { mutableStateOf(0) }
    var pulse by remember { mutableStateOf(0) }
    var paused by remember { mutableStateOf(false) }

    val toneGenerator = remember { ToneGenerator(AudioManager.STREAM_MUSIC, 80) }

    DisposableEffect(Unit) {
        onDispose { toneGenerator.release() }
    }

    fun advance(): Boolean {
        val next = phraseIndex + 1
        if (next < phrases.size) {
            phraseIndex = next
            return true
        }
        onFinish(exercise)
        return false
    }

    LaunchedEffect(Unit) {
        var secondsInPhrase = 0
        while (true) {
            delay(1000)
            if (paused) continue
            pulse = (pulse + 1) % 3
            toneGenerator.startTone(ToneGenerator.TONE_PROP_BEEP, 60)
            secondsInPhrase += 1
            if (secondsInPhrase >= 6) {
                secondsInPhrase = 0
                advance()
            }
        }
    }

    Column(
        modifier = Modifier
            .fillMaxSize()
            .background(BgPage)
            .padding(20.dp)
    ) {
        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.SpaceBetween
        ) {
            Icon(
                Icons.Filled.Close,
                contentDescription = "Cerrar",
                tint = TextSecondary,
                modifier = Modifier.clickable { onFinish(null) }
            )
        }
        Spacer(modifier = Modifier.height(16.dp))

        Row(horizontalArrangement = Arrangement.spacedBy(4.dp), modifier = Modifier.fillMaxWidth()) {
            phrases.forEachIndexed { index, _ ->
                Box(
                    modifier = Modifier
                        .weight(1f)
                        .height(4.dp)
                        .background(if (index <= phraseIndex) GreenSuccess else BgCardIcon, shape = RoundedCornerShape(2.dp))
                )
            }
        }
        Spacer(modifier = Modifier.height(24.dp))

        Text(exercise.name.uppercase(), color = BlueAccent, fontSize = 11.sp, textAlign = TextAlign.Center, modifier = Modifier.fillMaxWidth())
        Spacer(modifier = Modifier.height(20.dp))

        Box(
            modifier = Modifier
                .fillMaxWidth()
                .weight(1f)
                .background(BgCard, shape = RoundedCornerShape(16.dp))
                .padding(20.dp),
            contentAlignment = Alignment.Center
        ) {
            Text(
                phrases[phraseIndex],
                color = TextPrimary,
                fontSize = 19.sp,
                textAlign = TextAlign.Center
            )
        }
        Spacer(modifier = Modifier.height(20.dp))

        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.Center
        ) {
            repeat(3) { index ->
                Box(
                    modifier = Modifier
                        .padding(horizontal = 4.dp)
                        .size(10.dp)
                        .background(if (index == pulse) BlueAccent else BgCardIcon, shape = CircleShape)
                )
            }
        }
        Spacer(modifier = Modifier.height(6.dp))
        Text("60 ppm", color = TextSecondary, fontSize = 11.sp, textAlign = TextAlign.Center, modifier = Modifier.fillMaxWidth())
        Spacer(modifier = Modifier.height(20.dp))

        Row(horizontalArrangement = Arrangement.spacedBy(10.dp)) {
            Box(
                modifier = Modifier
                    .size(52.dp)
                    .background(BgCard, shape = RoundedCornerShape(14.dp))
                    .clickable { paused = !paused },
                contentAlignment = Alignment.Center
            ) {
                Icon(if (paused) Icons.Filled.PlayArrow else Icons.Filled.Pause, contentDescription = null, tint = TextSecondary)
            }
            Box(
                modifier = Modifier
                    .weight(1f)
                    .background(BlueAccent, shape = RoundedCornerShape(14.dp))
                    .clickable { advance() }
                    .padding(vertical = 16.dp),
                contentAlignment = Alignment.Center
            ) {
                Text("Siguiente frase", color = BgPage, fontSize = 14.sp, fontWeight = FontWeight.Bold)
            }
        }
    }
}