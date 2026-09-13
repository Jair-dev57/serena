package com.example.serena.ui.screens

import androidx.compose.animation.core.Animatable
import androidx.compose.animation.core.tween
import androidx.compose.foundation.Canvas
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
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
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.example.serena.data.ExerciseEntity
import com.example.serena.ui.theme.*
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch

private data class Phase(val name: String, val seconds: Int, val instruction: String, val targetSize: Float)

private val phases = listOf(
    Phase("Inhala", 4, "Inhala lento por la nariz", 1f),
    Phase("Sosten", 7, "Manten el aire, relaja los hombros", 1f),
    Phase("Exhala", 8, "Suelta el aire despacio por la boca", 0.55f)
)
private const val CYCLES = 4

@Composable
fun BreathingScreen(
    exercise: ExerciseEntity,
    onFinish: (ExerciseEntity?) -> Unit
) {
    var cycle by remember { mutableStateOf(0) }
    var phaseIndex by remember { mutableStateOf(0) }
    var secondsLeft by remember { mutableStateOf(phases[0].seconds) }
    var paused by remember { mutableStateOf(false) }
    val sizeAnim = remember { Animatable(0.55f) }
    val scope = rememberCoroutineScope()

    fun goToPhase(newCycle: Int, newPhaseIndex: Int) {
        cycle = newCycle
        phaseIndex = newPhaseIndex
        secondsLeft = phases[newPhaseIndex].seconds
        scope.launch {
            sizeAnim.animateTo(
                phases[newPhaseIndex].targetSize,
                animationSpec = tween(durationMillis = phases[newPhaseIndex].seconds * 1000)
            )
        }
    }

    fun advance(): Boolean {
        val nextPhase = phaseIndex + 1
        if (nextPhase < phases.size) {
            goToPhase(cycle, nextPhase)
            return true
        }
        val nextCycle = cycle + 1
        if (nextCycle < CYCLES) {
            goToPhase(nextCycle, 0)
            return true
        }
        onFinish(exercise)
        return false
    }

    LaunchedEffect(Unit) {
        scope.launch {
            sizeAnim.animateTo(phases[0].targetSize, animationSpec = tween(durationMillis = phases[0].seconds * 1000))
        }
        while (true) {
            delay(1000)
            if (paused) continue
            secondsLeft -= 1
            if (secondsLeft <= 0) {
                advance()
            }
        }
    }

    val currentPhase = phases[phaseIndex]

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
            repeat(CYCLES) { index ->
                Box(
                    modifier = Modifier
                        .weight(1f)
                        .height(4.dp)
                        .background(if (index < cycle) GreenSuccess else BgCardIcon, shape = RoundedCornerShape(2.dp))
                )
            }
        }
        Spacer(modifier = Modifier.height(24.dp))

        Text(exercise.name.uppercase(), color = BlueAccent, fontSize = 11.sp, textAlign = TextAlign.Center, modifier = Modifier.fillMaxWidth())
        Spacer(modifier = Modifier.height(6.dp))
        Text(currentPhase.name, color = TextPrimary, fontSize = 19.sp, fontWeight = FontWeight.Bold, textAlign = TextAlign.Center, modifier = Modifier.fillMaxWidth())
        Spacer(modifier = Modifier.height(20.dp))

        Box(
            modifier = Modifier.fillMaxWidth().weight(1f),
            contentAlignment = Alignment.Center
        ) {
            Canvas(modifier = Modifier.size(220.dp)) {
                val maxRadius = size.minDimension / 2f
                val currentRadius = maxRadius * sizeAnim.value

                drawCircle(
                    brush = Brush.radialGradient(
                        colors = listOf(BlueAccent.copy(alpha = 0.15f), Color.Transparent),
                        center = center,
                        radius = maxRadius * 1.15f
                    ),
                    radius = maxRadius * 1.15f,
                    center = center
                )

                drawCircle(
                    brush = Brush.radialGradient(
                        colors = listOf(
                            Color(0xFFA8CDEA),
                            BlueAccent,
                            Color(0xFF5A8FC4)
                        ),
                        center = Offset(center.x - currentRadius * 0.3f, center.y - currentRadius * 0.35f),
                        radius = currentRadius * 1.3f
                    ),
                    radius = currentRadius,
                    center = center
                )
            }
            Column(horizontalAlignment = Alignment.CenterHorizontally) {
                Text(secondsLeft.toString(), color = BgPage, fontSize = 30.sp, fontWeight = FontWeight.Light)
                Text("segundos", color = BgPage.copy(alpha = 0.7f), fontSize = 11.sp)
            }
        }
        Spacer(modifier = Modifier.height(16.dp))

        Text(currentPhase.instruction, color = TextSecondary, fontSize = 13.sp, textAlign = TextAlign.Center, modifier = Modifier.fillMaxWidth())
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
                Text("Siguiente paso", color = BgPage, fontSize = 14.sp, fontWeight = FontWeight.Bold)
            }
        }
    }
}