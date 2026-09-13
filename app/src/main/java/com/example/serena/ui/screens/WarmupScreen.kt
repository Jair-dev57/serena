package com.example.serena.ui.screens

import androidx.compose.animation.core.Animatable
import androidx.compose.animation.core.RepeatMode
import androidx.compose.animation.core.animateFloat
import androidx.compose.animation.core.infiniteRepeatable
import androidx.compose.animation.core.rememberInfiniteTransition
import androidx.compose.animation.core.tween
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Close
import androidx.compose.material3.Icon
import androidx.compose.material3.Text
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.scale
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.example.serena.ui.theme.*
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch

private data class WarmupStep(val title: String, val instruction: String, val seconds: Int, val mode: WarmupMode)
private enum class WarmupMode { BREATHING, HUMMING, PHRASE }
private data class BreathPhase(val label: String, val seconds: Int)

private val breathCycle = listOf(
    BreathPhase("Inhala", 4),
    BreathPhase("Sosten", 4),
    BreathPhase("Exhala", 6)
)

private val warmupSteps = listOf(
    WarmupStep("Respiracion calmante", "Sigue el ritmo del circulo", 60, WarmupMode.BREATHING),
    WarmupStep("Zumbido vocal", "Tararea suave \"mmmm\" sin forzar", 60, WarmupMode.HUMMING),
    WarmupStep("Inicio suave de voz", "Deja salir el aire antes de hablar", 60, WarmupMode.PHRASE)
)

@Composable
fun WarmupScreen(onFinish: () -> Unit) {
    var stepIndex by remember { mutableStateOf(0) }
    var secondsLeft by remember { mutableStateOf(warmupSteps[0].seconds) }
    var breathPhaseIndex by remember { mutableStateOf(0) }
    val scale = remember { Animatable(1f) }
    val scope = rememberCoroutineScope()

    val pulseTransition = rememberInfiniteTransition(label = "pulse")
    val pulseScale by pulseTransition.animateFloat(
        initialValue = 1f,
        targetValue = 1.12f,
        animationSpec = infiniteRepeatable(
            animation = tween(durationMillis = 900),
            repeatMode = RepeatMode.Reverse
        ),
        label = "pulseScale"
    )

    fun advance(): Boolean {
        val next = stepIndex + 1
        if (next < warmupSteps.size) {
            stepIndex = next
            secondsLeft = warmupSteps[next].seconds
            breathPhaseIndex = 0
            scope.launch { scale.snapTo(1f) }
            return true
        }
        onFinish()
        return false
    }

    LaunchedEffect(Unit) {
        while (true) {
            delay(1000)
            secondsLeft -= 1
            if (secondsLeft <= 0) {
                advance()
            }
        }
    }

    LaunchedEffect(stepIndex) {
        if (warmupSteps[stepIndex].mode != WarmupMode.BREATHING) return@LaunchedEffect
        var elapsedInPhase = 0
        while (true) {
            delay(1000)
            elapsedInPhase += 1
            val currentPhase = breathCycle[breathPhaseIndex]
            if (elapsedInPhase >= currentPhase.seconds) {
                elapsedInPhase = 0
                breathPhaseIndex = (breathPhaseIndex + 1) % breathCycle.size
                val targetScale = if (breathCycle[breathPhaseIndex].label == "Exhala") 0.85f else 1.15f
                scope.launch {
                    scale.animateTo(targetScale, animationSpec = tween(durationMillis = breathCycle[breathPhaseIndex].seconds * 1000))
                }
            }
        }
    }

    val currentStep = warmupSteps[stepIndex]

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
                modifier = Modifier.clickable { onFinish() }
            )
        }
        Spacer(modifier = Modifier.height(16.dp))

        Row(horizontalArrangement = Arrangement.spacedBy(4.dp), modifier = Modifier.fillMaxWidth()) {
            warmupSteps.forEachIndexed { index, _ ->
                Box(
                    modifier = Modifier
                        .weight(1f)
                        .height(4.dp)
                        .background(if (index < stepIndex) GreenSuccess else if (index == stepIndex) BlueAccent else BgCardIcon, shape = RoundedCornerShape(2.dp))
                )
            }
        }
        Spacer(modifier = Modifier.height(24.dp))

        Text(
            "CALENTAMIENTO - PASO ${stepIndex + 1} DE ${warmupSteps.size}",
            color = BlueAccent,
            fontSize = 11.sp,
            textAlign = TextAlign.Center,
            modifier = Modifier.fillMaxWidth()
        )
        Spacer(modifier = Modifier.height(8.dp))
        Text(
            currentStep.title,
            color = TextPrimary,
            fontSize = 19.sp,
            fontWeight = FontWeight.Bold,
            textAlign = TextAlign.Center,
            modifier = Modifier.fillMaxWidth()
        )
        Spacer(modifier = Modifier.height(20.dp))

        Box(
            modifier = Modifier.fillMaxWidth().weight(1f),
            contentAlignment = Alignment.Center
        ) {
            when (currentStep.mode) {
                WarmupMode.BREATHING -> {
                    Box(
                        modifier = Modifier
                            .size(120.dp)
                            .scale(scale.value)
                            .background(
                                brush = Brush.radialGradient(
                                    colors = listOf(Color(0xFFA8CDEA), BlueAccent, Color(0xFF5A8FC4))
                                ),
                                shape = CircleShape
                            ),
                        contentAlignment = Alignment.Center
                    ) {
                        Text(breathCycle[breathPhaseIndex].label, color = BgPage, fontSize = 16.sp, fontWeight = FontWeight.Bold)
                    }
                }
                WarmupMode.HUMMING -> {
                    Box(modifier = Modifier.size(140.dp), contentAlignment = Alignment.Center) {
                        Box(
                            modifier = Modifier
                                .size(140.dp)
                                .scale(pulseScale)
                                .background(BlueAccent.copy(alpha = 0.15f), shape = CircleShape)
                        )
                        Box(
                            modifier = Modifier
                                .size(90.dp)
                                .background(
                                    brush = Brush.radialGradient(
                                        colors = listOf(Color(0xFFA8CDEA), BlueAccent, Color(0xFF5A8FC4))
                                    ),
                                    shape = CircleShape
                                )
                        )
                    }
                }
                WarmupMode.PHRASE -> {
                    Box(
                        modifier = Modifier
                            .fillMaxWidth()
                            .background(BgCard, shape = RoundedCornerShape(14.dp))
                            .padding(18.dp)
                    ) {
                        Text(
                            "\"Hoy... hablo... con calma\"",
                            color = TextPrimary,
                            fontSize = 16.sp,
                            textAlign = TextAlign.Center,
                            modifier = Modifier.fillMaxWidth()
                        )
                    }
                }
            }
        }
        Spacer(modifier = Modifier.height(16.dp))

        Text(secondsLeft.toString(), color = TextPrimary, fontSize = 28.sp, fontWeight = FontWeight.Light, textAlign = TextAlign.Center, modifier = Modifier.fillMaxWidth())
        Spacer(modifier = Modifier.height(8.dp))
        Text(currentStep.instruction, color = TextSecondary, fontSize = 12.sp, textAlign = TextAlign.Center, modifier = Modifier.fillMaxWidth())
        Spacer(modifier = Modifier.height(20.dp))

        Box(
            modifier = Modifier
                .fillMaxWidth()
                .background(BlueAccent, shape = RoundedCornerShape(14.dp))
                .clickable { advance() }
                .padding(vertical = 16.dp),
            contentAlignment = Alignment.Center
        ) {
            Text(
                if (stepIndex == warmupSteps.size - 1) "Finalizar" else "Siguiente paso",
                color = BgPage,
                fontSize = 14.sp,
                fontWeight = FontWeight.Bold
            )
        }
    }
}