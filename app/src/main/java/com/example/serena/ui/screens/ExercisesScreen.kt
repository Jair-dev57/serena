package com.example.serena.ui.screens

import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.LazyRow
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Air
import androidx.compose.material.icons.filled.Chat
import androidx.compose.material.icons.filled.Check
import androidx.compose.material.icons.filled.GraphicEq
import androidx.compose.material.icons.filled.Mic
import androidx.compose.material.icons.filled.MenuBook
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.example.serena.data.ExerciseCategory
import com.example.serena.data.ExerciseEntity
import com.example.serena.ui.theme.*

@Composable
fun ExercisesScreen(
    exercises: List<ExerciseEntity>,
    onToggleCompleted: (ExerciseEntity) -> Unit
) {
    var selectedFilter by remember { mutableStateOf("Todos") }
    val filters = listOf("Todos") + ExerciseCategory.entries.map { it.label }
    val filtered = if (selectedFilter == "Todos") exercises else exercises.filter { it.category.label == selectedFilter }

    Column(
        modifier = Modifier
            .fillMaxSize()
            .background(BgPage)
            .padding(horizontal = 20.dp, vertical = 16.dp)
    ) {
        Text("PRACTICA", color = BlueAccent, fontSize = 11.sp)
        Text("Ejercicios", color = TextPrimary, fontSize = 20.sp, fontWeight = FontWeight.Bold)
        Spacer(modifier = Modifier.height(12.dp))

        LazyRow(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
            items(filters) { label ->
                val isSelected = selectedFilter == label
                Box(
                    modifier = Modifier
                        .background(if (isSelected) BlueAccent else BgCard, shape = RoundedCornerShape(20.dp))
                        .clickable { selectedFilter = label },
                    contentAlignment = Alignment.Center
                ) {
                    Text(
                        label,
                        color = if (isSelected) BgPage else TextSecondary,
                        fontSize = 12.sp,
                        modifier = Modifier.padding(horizontal = 14.dp, vertical = 8.dp)
                    )
                }
            }
        }
        Spacer(modifier = Modifier.height(12.dp))

        LazyColumn(
            modifier = Modifier.weight(1f),
            verticalArrangement = Arrangement.spacedBy(10.dp)
        ) {
            items(filtered) { exercise ->
                Row(
                    modifier = Modifier
                        .fillMaxWidth()
                        .background(BgCard, shape = RoundedCornerShape(14.dp))
                        .padding(14.dp),
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Box(
                        modifier = Modifier
                            .size(38.dp)
                            .background(BgCardIcon, shape = RoundedCornerShape(10.dp)),
                        contentAlignment = Alignment.Center
                    ) {
                        Icon(exerciseIcon(exercise.icon), contentDescription = null, tint = BlueAccent, modifier = Modifier.size(18.dp))
                    }
                    Spacer(modifier = Modifier.width(12.dp))
                    Column(modifier = Modifier.weight(1f)) {
                        Text(exercise.name, color = TextPrimary, fontSize = 14.sp, fontWeight = FontWeight.Bold)
                        Text("${exercise.durationMinutes} min - ${exercise.difficulty.label}", color = TextSecondary, fontSize = 11.sp)
                    }
                    Box(
                        modifier = Modifier
                            .size(28.dp)
                            .background(if (exercise.completed) BlueAccent else BgCardIcon, shape = CircleShape)
                            .clickable { onToggleCompleted(exercise) },
                        contentAlignment = Alignment.Center
                    ) {
                        if (exercise.completed) {
                            Icon(Icons.Filled.Check, contentDescription = null, tint = BgPage, modifier = Modifier.size(14.dp))
                        }
                    }
                }
            }
        }
    }
}

private fun exerciseIcon(icon: String) = when (icon) {
    "air" -> Icons.Filled.Air
    "menu_book" -> Icons.Filled.MenuBook
    "mic" -> Icons.Filled.Mic
    "chat_bubble" -> Icons.Filled.Chat
    "graphic_eq" -> Icons.Filled.GraphicEq
    else -> Icons.Filled.Air
}