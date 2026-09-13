package com.example.serena.ui.screens

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Air
import androidx.compose.material.icons.filled.Chat
import androidx.compose.material.icons.filled.GraphicEq
import androidx.compose.material.icons.filled.Mic
import androidx.compose.material.icons.filled.MenuBook
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.Icon
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.font.FontStyle
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.example.serena.data.ExerciseEntity
import com.example.serena.ui.theme.*
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable

@Composable
fun HomeScreen(
    exercises: List<ExerciseEntity>,
    streakDays: Int,
    onStart: (ExerciseEntity) -> Unit,
    onOpenWarmup: () -> Unit
) {
    val featured = exercises.firstOrNull { !it.completed } ?: exercises.firstOrNull()
    val others = exercises.filter { it.id != featured?.id }.take(4)

    Column(
        modifier = Modifier
            .fillMaxSize()
            .background(BgPage)
            .padding(horizontal = 20.dp, vertical = 16.dp)
    ) {
        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.SpaceBetween
        ) {
            Column {
                Text("Hola, Jair!", color = TextPrimary, fontSize = 22.sp, fontWeight = FontWeight.Bold)
                Text("Sigamos practicando hoy", color = TextSecondary, fontSize = 12.sp)
            }
            Box(
                modifier = Modifier
                    .background(OrangeStreak, shape = RoundedCornerShape(16.dp))
                    .padding(horizontal = 10.dp, vertical = 5.dp)
            ) {
                Text("$streakDays dias", color = TextPrimary, fontSize = 11.sp, fontWeight = FontWeight.Bold)
            }
        }
        Spacer(modifier = Modifier.height(16.dp))

        featured?.let { exercise ->
            Column(
                modifier = Modifier
                    .fillMaxWidth()
                    .background(BgCard, shape = RoundedCornerShape(18.dp))
                    .padding(28.dp),
                horizontalAlignment = Alignment.CenterHorizontally
            ) {
                Text("EJERCICIO DESTACADO", color = BlueAccent, fontSize = 11.sp)
                Spacer(modifier = Modifier.height(16.dp))
                Box(
                    modifier = Modifier
                        .size(110.dp)
                        .background(BlueAccent, shape = CircleShape),
                    contentAlignment = Alignment.Center
                ) {
                    Text(exercise.shortName, color = BgPage, fontSize = 15.sp, fontWeight = FontWeight.Bold)
                }
                Spacer(modifier = Modifier.height(16.dp))
                Text(exercise.name, color = TextPrimary, fontSize = 20.sp, fontWeight = FontWeight.Bold)
                Spacer(modifier = Modifier.height(4.dp))
                Text("${exercise.description} - ${exercise.durationMinutes} min", color = TextSecondary, fontSize = 13.sp, textAlign = TextAlign.Center)
                Spacer(modifier = Modifier.height(18.dp))
                Button(
                    onClick = { onStart(exercise) },
                    colors = ButtonDefaults.buttonColors(containerColor = BlueAccent),
                    modifier = Modifier.fillMaxWidth()
                ) {
                    Text("Comenzar", color = BgPage, fontSize = 15.sp)
                }
            }
        }
        Spacer(modifier = Modifier.height(14.dp))

        Column(
            modifier = Modifier.weight(1f),
            verticalArrangement = Arrangement.spacedBy(10.dp)
        ) {
            others.chunked(2).forEach { pair ->
                Row(
                    modifier = Modifier.weight(1f),
                    horizontalArrangement = Arrangement.spacedBy(10.dp)
                ) {
                    pair.forEach { exercise ->
                        Column(
                            modifier = Modifier
                                .weight(1f)
                                .fillMaxHeight()
                                .background(BgCard, shape = RoundedCornerShape(12.dp))
                                .padding(12.dp),
                            verticalArrangement = Arrangement.Center
                        ) {
                            Box(
                                modifier = Modifier
                                    .size(30.dp)
                                    .background(BgCardIcon, shape = RoundedCornerShape(9.dp)),
                                contentAlignment = Alignment.Center
                            ) {
                                Icon(iconForExercise(exercise.icon), contentDescription = null, tint = BlueAccent, modifier = Modifier.size(16.dp))
                            }
                            Spacer(modifier = Modifier.height(6.dp))
                            Text(exercise.name, color = TextPrimary, fontSize = 13.sp, fontWeight = FontWeight.Bold)
                            Spacer(modifier = Modifier.height(3.dp))
                            Text("${exercise.durationMinutes} min - ${exercise.difficulty.label}", color = TextSecondary, fontSize = 11.sp)
                        }
                    }
                    if (pair.size == 1) {
                        Spacer(modifier = Modifier.weight(1f))
                    }
                }
            }
        }

        Spacer(modifier = Modifier.height(14.dp))

        Row(
            modifier = Modifier
                .fillMaxWidth()
                .background(BgCard, shape = RoundedCornerShape(14.dp))
                .border(1.dp, BlueAccent, shape = RoundedCornerShape(14.dp))
                .clickable { onOpenWarmup() }
                .padding(12.dp),
            verticalAlignment = Alignment.CenterVertically
        ) {
            Box(
                modifier = Modifier
                    .size(30.dp)
                    .background(BlueAccent, shape = RoundedCornerShape(8.dp)),
                contentAlignment = Alignment.Center
            ) {
                Text("\uD83D\uDD25", fontSize = 14.sp)
            }
            Spacer(modifier = Modifier.width(10.dp))
            Column(modifier = Modifier.weight(1f)) {
                Text("Calentamiento rapido", color = TextPrimary, fontSize = 12.sp, fontWeight = FontWeight.Bold)
                Text("3 min - 3 pasos", color = TextSecondary, fontSize = 10.sp)
            }
            Text("\u203A", color = BlueAccent, fontSize = 16.sp)
        }
        Spacer(modifier = Modifier.height(14.dp))

        Box(
            modifier = Modifier
                .fillMaxWidth()
                .background(BgCard, shape = RoundedCornerShape(14.dp))
                .padding(12.dp),
            contentAlignment = Alignment.Center
        ) {
            Text(
                "\"Cada palabra practicada con calma es una victoria\"",
                color = TextSecondary,
                fontSize = 11.sp,
                fontStyle = FontStyle.Italic,
                textAlign = TextAlign.Center
            )
        }
    }
}

private fun iconForExercise(icon: String) = when (icon) {
    "air" -> Icons.Filled.Air
    "menu_book" -> Icons.Filled.MenuBook
    "mic" -> Icons.Filled.Mic
    "chat_bubble" -> Icons.Filled.Chat
    "graphic_eq" -> Icons.Filled.GraphicEq
    else -> Icons.Filled.Air
}