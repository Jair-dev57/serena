package com.example.serena.ui.screens

import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.text.BasicTextField
import androidx.compose.material3.Text
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalFocusManager
import androidx.compose.ui.platform.LocalSoftwareKeyboardController
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.example.serena.data.BlockIntensity
import com.example.serena.ui.theme.*

@Composable
fun AddBlockEntryScreen(
    onCancel: () -> Unit,
    onSave: (word: String, situation: String, intensity: BlockIntensity) -> Unit
) {
    var word by remember { mutableStateOf("") }
    var situation by remember { mutableStateOf("") }
    var intensity by remember { mutableStateOf(BlockIntensity.LEVE) }

    val focusManager = LocalFocusManager.current
    val keyboardController = LocalSoftwareKeyboardController.current

    fun dismissKeyboard() {
        keyboardController?.hide()
        focusManager.clearFocus()
    }

    Column(
        modifier = Modifier
            .fillMaxSize()
            .background(BgPage)
            .clickable(indication = null, interactionSource = remember { androidx.compose.foundation.interaction.MutableInteractionSource() }) {
                dismissKeyboard()
            }
            .padding(20.dp)
    ) {
        Text("NUEVO REGISTRO", color = BlueAccent, fontSize = 11.sp)
        Text("Registrar bloqueo", color = TextPrimary, fontSize = 20.sp, fontWeight = androidx.compose.ui.text.font.FontWeight.Bold)
        Spacer(modifier = Modifier.height(20.dp))

        Text("PALABRA O FRASE", color = TextSecondary, fontSize = 10.sp)
        Spacer(modifier = Modifier.height(4.dp))
        Box(
            modifier = Modifier
                .fillMaxWidth()
                .background(BgCard, shape = RoundedCornerShape(10.dp))
                .padding(12.dp)
        ) {
            BasicTextField(
                value = word,
                onValueChange = { word = it },
                textStyle = TextStyle(color = TextPrimary, fontSize = 14.sp),
                cursorBrush = androidx.compose.ui.graphics.SolidColor(BlueAccent),
                decorationBox = { innerTextField ->
                    if (word.isEmpty()) {
                        Text("ej. \"necesito\"", color = TextSecondary, fontSize = 14.sp)
                    }
                    innerTextField()
                }
            )
        }
        Spacer(modifier = Modifier.height(16.dp))

        Text("SITUACION", color = TextSecondary, fontSize = 10.sp)
        Spacer(modifier = Modifier.height(4.dp))
        Box(
            modifier = Modifier
                .fillMaxWidth()
                .background(BgCard, shape = RoundedCornerShape(10.dp))
                .padding(12.dp)
        ) {
            BasicTextField(
                value = situation,
                onValueChange = { situation = it },
                textStyle = TextStyle(color = TextPrimary, fontSize = 14.sp),
                cursorBrush = androidx.compose.ui.graphics.SolidColor(BlueAccent),
                decorationBox = { innerTextField ->
                    if (situation.isEmpty()) {
                        Text("ej. \"Llamada de trabajo\"", color = TextSecondary, fontSize = 14.sp)
                    }
                    innerTextField()
                }
            )
        }
        Spacer(modifier = Modifier.height(16.dp))

        Text("INTENSIDAD", color = TextSecondary, fontSize = 10.sp)
        Spacer(modifier = Modifier.height(6.dp))
        Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
            BlockIntensity.entries.forEach { level ->
                val isSelected = intensity == level
                Box(
                    modifier = Modifier
                        .weight(1f)
                        .background(if (isSelected) intensityColorFor(level) else BgCard, shape = RoundedCornerShape(10.dp))
                        .clickable {
                            dismissKeyboard()
                            intensity = level
                        }
                        .padding(vertical = 10.dp),
                    contentAlignment = Alignment.Center
                ) {
                    Text(level.label, color = if (isSelected) BgPage else TextSecondary, fontSize = 12.sp)
                }
            }
        }
        Spacer(modifier = Modifier.weight(1f))

        Row(horizontalArrangement = Arrangement.spacedBy(10.dp)) {
            Box(
                modifier = Modifier
                    .weight(1f)
                    .background(BgCard, shape = RoundedCornerShape(12.dp))
                    .clickable {
                        dismissKeyboard()
                        onCancel()
                    }
                    .padding(vertical = 14.dp),
                contentAlignment = Alignment.Center
            ) {
                Text("Cancelar", color = TextSecondary, fontSize = 13.sp)
            }
            Box(
                modifier = Modifier
                    .weight(1f)
                    .background(BlueAccent, shape = RoundedCornerShape(12.dp))
                    .clickable {
                        dismissKeyboard()
                        if (word.isNotBlank()) {
                            onSave(word.trim(), situation.trim().ifBlank { "Sin especificar" }, intensity)
                        }
                    }
                    .padding(vertical = 14.dp),
                contentAlignment = Alignment.Center
            ) {
                Text("Guardar registro", color = BgPage, fontSize = 13.sp, fontWeight = androidx.compose.ui.text.font.FontWeight.Bold)
            }
        }
    }
}

private fun intensityColorFor(intensity: BlockIntensity) = when (intensity) {
    BlockIntensity.LEVE -> GreenSuccess
    BlockIntensity.MEDIO -> AmberMedium
    BlockIntensity.FUERTE -> RedChallenging
}