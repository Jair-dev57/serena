package com.example.serena.ui.screens

import android.Manifest
import android.content.pm.PackageManager
import android.os.Build
import androidx.activity.compose.rememberLauncherForActivityResult
import androidx.activity.result.contract.ActivityResultContracts
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Chat
import androidx.compose.material.icons.filled.MusicNote
import androidx.compose.material.icons.filled.Notifications
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.Switch
import androidx.compose.material3.SwitchDefaults
import androidx.compose.material3.Text
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.core.content.ContextCompat
import com.example.serena.ReminderScheduler
import com.example.serena.data.AppDatabase
import com.example.serena.data.UserPreferencesEntity
import com.example.serena.ui.theme.*
import kotlinx.coroutines.launch

@Composable
fun ProfileScreen() {
    val context = LocalContext.current
    val db = remember { AppDatabase.getInstance(context) }
    val scope = rememberCoroutineScope()

    var dailyGoal by remember { mutableStateOf(15) }
    var remindersEnabled by remember { mutableStateOf(true) }
    var soundsEnabled by remember { mutableStateOf(true) }
    var shareTherapist by remember { mutableStateOf(false) }
    var loaded by remember { mutableStateOf(false) }

    val notificationPermissionLauncher = rememberLauncherForActivityResult(
        ActivityResultContracts.RequestPermission()
    ) { granted ->
        if (granted) {
            scope.launch { ReminderScheduler.scheduleNext(context, hour = 20, minute = 0) }
        }
    }

    LaunchedEffect(Unit) {
        val saved = db.userPreferencesDao().get()
        if (saved != null) {
            dailyGoal = saved.dailyGoal
            remindersEnabled = saved.remindersEnabled
            soundsEnabled = saved.soundsEnabled
            shareTherapist = saved.shareTherapist
        }
        loaded = true
    }

    fun persist() {
        if (!loaded) return
        scope.launch {
            db.userPreferencesDao().save(
                UserPreferencesEntity(
                    dailyGoal = dailyGoal,
                    remindersEnabled = remindersEnabled,
                    soundsEnabled = soundsEnabled,
                    shareTherapist = shareTherapist
                )
            )
        }
    }

    fun onRemindersToggle(enabled: Boolean) {
        remindersEnabled = enabled
        persist()
        if (enabled) {
            val hasPermission = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                ContextCompat.checkSelfPermission(context, Manifest.permission.POST_NOTIFICATIONS) == PackageManager.PERMISSION_GRANTED
            } else {
                true
            }
            if (hasPermission) {
                scope.launch { ReminderScheduler.scheduleNext(context, hour = 20, minute = 0) }
            } else {
                notificationPermissionLauncher.launch(Manifest.permission.POST_NOTIFICATIONS)
            }
        } else {
            ReminderScheduler.cancel(context)
        }
    }

    Column(
        modifier = Modifier
            .fillMaxSize()
            .background(BgPage)
            .padding(horizontal = 20.dp, vertical = 16.dp)
    ) {
        Text("TU CUENTA", color = BlueAccent, fontSize = 11.sp)
        Text("Perfil", color = TextPrimary, fontSize = 22.sp, fontWeight = FontWeight.Bold)
        Spacer(modifier = Modifier.height(16.dp))

        Row(
            modifier = Modifier
                .fillMaxWidth()
                .background(BgCard, shape = RoundedCornerShape(16.dp))
                .padding(16.dp),
            verticalAlignment = Alignment.CenterVertically
        ) {
            Box(
                modifier = Modifier
                    .size(52.dp)
                    .background(BlueAccent, shape = CircleShape),
                contentAlignment = Alignment.Center
            ) {
                Text("J", color = BgPage, fontSize = 19.sp, fontWeight = FontWeight.Bold)
            }
            Spacer(modifier = Modifier.width(12.dp))
            Column {
                Text("Jair", color = TextPrimary, fontSize = 15.sp, fontWeight = FontWeight.Bold)
                Text("Miembro desde agosto 2026", color = TextSecondary, fontSize = 11.sp)
            }
        }
        Spacer(modifier = Modifier.height(12.dp))

        Column(
            modifier = Modifier
                .fillMaxWidth()
                .background(BgCard, shape = RoundedCornerShape(16.dp))
                .padding(16.dp)
        ) {
            Row(
                modifier = Modifier.fillMaxWidth(),
                verticalAlignment = Alignment.CenterVertically
            ) {
                Column(modifier = Modifier.weight(1f)) {
                    Text("Meta diaria", color = TextPrimary, fontSize = 15.sp, fontWeight = FontWeight.Bold)
                    Text("Minutos de practica", color = TextSecondary, fontSize = 11.sp)
                }
                IconButton(onClick = {
                    dailyGoal = (dailyGoal - 5).coerceAtLeast(5)
                    persist()
                }) {
                    Text("-", color = TextSecondary, fontSize = 18.sp)
                }
                Text("$dailyGoal min", color = TextPrimary, fontSize = 14.sp, fontWeight = FontWeight.Bold)
                IconButton(onClick = {
                    dailyGoal = (dailyGoal + 5).coerceAtMost(60)
                    persist()
                }) {
                    Text("+", color = TextSecondary, fontSize = 18.sp)
                }
            }
            Spacer(modifier = Modifier.height(8.dp))
            ToggleRow(Icons.Filled.Notifications, "Recordatorios diarios", "8:00 p. m.", remindersEnabled) { onRemindersToggle(it) }
            Spacer(modifier = Modifier.height(14.dp))
            ToggleRow(Icons.Filled.MusicNote, "Sonidos suaves", "Guia auditiva en ejercicios", soundsEnabled) {
                soundsEnabled = it
                persist()
            }
            Spacer(modifier = Modifier.height(14.dp))
            ToggleRow(Icons.Filled.Chat, "Compartir con terapeuta", "Enviar resumen semanal", shareTherapist) {
                shareTherapist = it
                persist()
            }
        }
        Spacer(modifier = Modifier.height(12.dp))

        Box(
            modifier = Modifier
                .fillMaxWidth()
                .background(BgPage, shape = RoundedCornerShape(14.dp))
                .clickable { }
                .padding(vertical = 14.dp),
            contentAlignment = Alignment.Center
        ) {
            Text("Cerrar sesion", color = TextPrimary, fontSize = 14.sp, fontWeight = FontWeight.Bold)
        }
    }
}

@Composable
private fun ToggleRow(
    icon: androidx.compose.ui.graphics.vector.ImageVector,
    title: String,
    subtitle: String,
    checked: Boolean,
    onCheckedChange: (Boolean) -> Unit
) {
    Row(verticalAlignment = Alignment.CenterVertically) {
        Icon(icon, contentDescription = null, tint = BlueAccent, modifier = Modifier.size(22.dp))
        Spacer(modifier = Modifier.width(10.dp))
        Column(modifier = Modifier.weight(1f)) {
            Text(title, color = TextPrimary, fontSize = 15.sp, fontWeight = FontWeight.Bold)
            Text(subtitle, color = TextSecondary, fontSize = 11.sp)
        }
        Switch(
            checked = checked,
            onCheckedChange = onCheckedChange,
            colors = SwitchDefaults.colors(
                checkedThumbColor = BgPage,
                checkedTrackColor = BlueAccent,
                uncheckedThumbColor = TextSecondary,
                uncheckedTrackColor = BgCardIcon
            )
        )
    }
}