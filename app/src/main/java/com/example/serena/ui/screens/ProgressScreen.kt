package com.example.serena.ui.screens

import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.DarkMode
import androidx.compose.material.icons.filled.Mic
import androidx.compose.material.icons.filled.WaterDrop
import androidx.compose.material3.Icon
import androidx.compose.material3.Text
import androidx.compose.runtime.*
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.example.serena.data.AppDatabase
import com.example.serena.data.PracticeSessionEntity
import com.example.serena.data.ProgressCalculator
import com.example.serena.ui.theme.*

private data class Achievement(val icon: androidx.compose.ui.graphics.vector.ImageVector, val title: String, val subtitle: String, val unlocked: Boolean)

@Composable
fun ProgressScreen(onOpenJournal: () -> Unit) {
    val context = LocalContext.current
    val db = remember { AppDatabase.getInstance(context) }
    var sessions by remember { mutableStateOf(listOf<PracticeSessionEntity>()) }

    LaunchedEffect(Unit) {
        sessions = db.practiceSessionDao().getAll()
    }

    val streakDays = ProgressCalculator.getStreakDays(sessions)
    val minutesThisWeek = ProgressCalculator.getMinutesThisWeek(sessions)
    val averageFluency = ProgressCalculator.getAverageFluency(sessions)
    val minutesPerDay = ProgressCalculator.getMinutesPerDayLast7(sessions)
    val fluencyScores = ProgressCalculator.getRecentFluencyScores(sessions)

    val achievements = listOf(
        Achievement(Icons.Filled.WaterDrop, "3 dias seguidos", "Constancia inicial desbloqueada", streakDays >= 3),
        Achievement(Icons.Filled.Mic, "Primera conversacion", "Completaste tu primer ejercicio de habla", sessions.isNotEmpty()),
        Achievement(Icons.Filled.DarkMode, "10 sesiones totales", "Ya llevas 10 practicas en Serena", sessions.size >= 10)
    ).filter { it.unlocked }

    Column(
        modifier = Modifier
            .fillMaxSize()
            .background(BgPage)
            .padding(horizontal = 20.dp, vertical = 16.dp)
    ) {
        Text("TU EVOLUCION", color = BlueAccent, fontSize = 11.sp)
        Text("Progreso", color = TextPrimary, fontSize = 22.sp, fontWeight = FontWeight.Bold)
        Spacer(modifier = Modifier.height(14.dp))

        Row(horizontalArrangement = Arrangement.spacedBy(10.dp)) {
            StatCard(streakDays.toString(), "DIAS SEGUIDOS", Modifier.weight(1f))
            StatCard(minutesThisWeek.toString(), "MIN. ESTA SEMANA", Modifier.weight(1f))
            StatCard("$averageFluency%", "FLUIDEZ", Modifier.weight(1f))
        }
        Spacer(modifier = Modifier.height(14.dp))

        Box(
            modifier = Modifier
                .fillMaxWidth()
                .background(BgCard, shape = RoundedCornerShape(14.dp))
                .clickable { onOpenJournal() }
                .padding(14.dp),
            contentAlignment = Alignment.Center
        ) {
            Text("Ver diario de bloqueos", color = BlueAccent, fontSize = 13.sp, fontWeight = FontWeight.Bold)
        }
        Spacer(modifier = Modifier.height(14.dp))

        Column(
            modifier = Modifier
                .fillMaxWidth()
                .weight(1f)
                .background(BgCard, shape = RoundedCornerShape(14.dp))
                .padding(14.dp)
        ) {
            Text("Minutos por dia", color = TextPrimary, fontSize = 12.sp, fontWeight = FontWeight.Bold)
            Spacer(modifier = Modifier.height(10.dp))
            BarChart(data = minutesPerDay, modifier = Modifier.fillMaxWidth().weight(1f))
        }
        Spacer(modifier = Modifier.height(14.dp))

        Column(
            modifier = Modifier
                .fillMaxWidth()
                .weight(1f)
                .background(BgCard, shape = RoundedCornerShape(14.dp))
                .padding(14.dp)
        ) {
            Text("Puntaje de fluidez - ultimas sesiones", color = TextPrimary, fontSize = 12.sp, fontWeight = FontWeight.Bold)
            Spacer(modifier = Modifier.height(10.dp))
            LineChart(scores = fluencyScores, modifier = Modifier.fillMaxWidth().weight(1f))
        }
        Spacer(modifier = Modifier.height(14.dp))

        if (achievements.isEmpty()) {
            Box(
                modifier = Modifier
                    .fillMaxWidth()
                    .background(BgCard, shape = RoundedCornerShape(14.dp))
                    .padding(16.dp),
                contentAlignment = Alignment.Center
            ) {
                Text(
                    "Todavia no tenes logros. Segui practicando para desbloquear el primero.",
                    color = TextSecondary,
                    fontSize = 12.sp,
                    textAlign = TextAlign.Center
                )
            }
        } else {
            Column(verticalArrangement = Arrangement.spacedBy(10.dp)) {
                achievements.forEach { achievement ->
                    Row(
                        modifier = Modifier
                            .fillMaxWidth()
                            .background(BgCard, shape = RoundedCornerShape(14.dp))
                            .padding(14.dp),
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Box(
                            modifier = Modifier
                                .size(36.dp)
                                .background(BgCardIcon, shape = CircleShape),
                            contentAlignment = Alignment.Center
                        ) {
                            Icon(achievement.icon, contentDescription = null, tint = BlueAccent, modifier = Modifier.size(18.dp))
                        }
                        Spacer(modifier = Modifier.width(12.dp))
                        Column {
                            Text(achievement.title, color = TextPrimary, fontSize = 13.sp, fontWeight = FontWeight.Bold)
                            Text(achievement.subtitle, color = TextSecondary, fontSize = 11.sp)
                        }
                    }
                }
            }
        }
    }
}

@Composable
private fun StatCard(value: String, label: String, modifier: Modifier = Modifier) {
    Column(
        modifier = modifier
            .background(BgCard, shape = RoundedCornerShape(10.dp))
            .padding(10.dp),
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Text(value, color = TextPrimary, fontSize = 17.sp, fontWeight = FontWeight.Bold)
        Text(label, color = TextSecondary, fontSize = 8.sp, textAlign = TextAlign.Center)
    }
}

@Composable
private fun BarChart(data: List<Pair<String, Int>>, modifier: Modifier = Modifier) {
    val maxValue = (data.maxOfOrNull { it.second } ?: 1).coerceAtLeast(1).toFloat()
    Row(modifier = modifier, horizontalArrangement = Arrangement.spacedBy(6.dp)) {
        data.forEach { (label, minutes) ->
            val isPeak = minutes.toFloat() == maxValue && minutes > 0
            Column(
                modifier = Modifier.weight(1f).fillMaxHeight(),
                horizontalAlignment = Alignment.CenterHorizontally,
                verticalArrangement = Arrangement.Bottom
            ) {
                Box(
                    modifier = Modifier
                        .fillMaxWidth()
                        .fillMaxHeight((minutes / maxValue).coerceIn(0.02f, 1f))
                        .background(if (isPeak) OrangeStreak else BlueAccent, shape = RoundedCornerShape(3.dp))
                )
                Spacer(modifier = Modifier.height(4.dp))
                Text(label, color = TextSecondary, fontSize = 9.sp)
            }
        }
    }
}

@Composable
private fun LineChart(scores: List<Int>, modifier: Modifier = Modifier) {
    val minScore = (scores.minOrNull() ?: 0).toFloat()
    val maxScore = (scores.maxOrNull() ?: 100).toFloat()
    val range = (maxScore - minScore).coerceAtLeast(1f)

    androidx.compose.foundation.Canvas(modifier = modifier) {
        if (scores.size < 2) return@Canvas
        val stepX = size.width / (scores.size - 1)
        val points = scores.mapIndexed { index, score ->
            val x = stepX * index
            val normalized = (score - minScore) / range
            val y = size.height - (normalized * size.height * 0.85f) - (size.height * 0.05f)
            androidx.compose.ui.geometry.Offset(x, y)
        }

        val linePath = androidx.compose.ui.graphics.Path().apply {
            points.forEachIndexed { index, point ->
                if (index == 0) moveTo(point.x, point.y) else lineTo(point.x, point.y)
            }
        }

        val fillPath = androidx.compose.ui.graphics.Path().apply {
            addPath(linePath)
            lineTo(points.last().x, size.height)
            lineTo(points.first().x, size.height)
            close()
        }

        drawPath(
            path = fillPath,
            brush = androidx.compose.ui.graphics.Brush.verticalGradient(
                colors = listOf(BlueAccent.copy(alpha = 0.35f), BlueAccent.copy(alpha = 0f))
            )
        )
        drawPath(
            path = linePath,
            color = BlueAccent,
            style = androidx.compose.ui.graphics.drawscope.Stroke(width = 3f, cap = androidx.compose.ui.graphics.StrokeCap.Round)
        )
        points.dropLast(1).forEach { point ->
            drawCircle(color = BlueAccent, radius = 3f, center = point)
        }
        drawCircle(color = OrangeStreak, radius = 5f, center = points.last())
    }
}