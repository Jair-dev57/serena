package com.example.serena.ui.screens

import android.Manifest
import android.content.pm.PackageManager
import android.media.MediaPlayer
import android.media.MediaRecorder
import androidx.activity.compose.rememberLauncherForActivityResult
import androidx.activity.result.contract.ActivityResultContracts
import androidx.compose.animation.core.Animatable
import androidx.compose.animation.core.tween
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Close
import androidx.compose.material.icons.filled.Mic
import androidx.compose.material.icons.filled.Pause
import androidx.compose.material.icons.filled.PlayArrow
import androidx.compose.material3.Icon
import androidx.compose.material3.Text
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.core.content.ContextCompat
import com.example.serena.data.AppDatabase
import com.example.serena.data.ExerciseEntity
import com.example.serena.data.RecordingEntity
import com.example.serena.ui.theme.*
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch
import java.io.File

private data class PullPhase(val name: String, val seconds: Int, val instruction: String, val targetFill: Float)

private val pullPhases = listOf(
    PullPhase("Bloqueo", 3, "Finge el bloqueo: alarga el primer sonido", 0.08f),
    PullPhase("Desliza", 6, "Baja la tension y desliza el sonido, lento", 1f),
    PullPhase("Termina", 3, "Completa la palabra con calma", 1f)
)

private val pullOutWords = listOf("Colombia", "Computadora", "Restaurante", "Bicicleta", "Telefono", "Perro")

@Composable
fun PullOutScreen(
    exercise: ExerciseEntity,
    onFinish: (ExerciseEntity?) -> Unit
) {
    val context = LocalContext.current
    val db = remember { AppDatabase.getInstance(context) }
    val scope = rememberCoroutineScope()

    var wordIndex by remember { mutableStateOf(0) }
    var phaseIndex by remember { mutableStateOf(0) }
    var secondsLeft by remember { mutableStateOf(pullPhases[0].seconds) }
    var paused by remember { mutableStateOf(false) }
    val fillAnim = remember { Animatable(0.08f) }

    var hasPermission by remember {
        mutableStateOf(
            ContextCompat.checkSelfPermission(context, Manifest.permission.RECORD_AUDIO) == PackageManager.PERMISSION_GRANTED
        )
    }
    var recorder by remember { mutableStateOf<MediaRecorder?>(null) }
    var currentFile by remember { mutableStateOf<File?>(null) }
    var lastRecordingPath by remember { mutableStateOf<String?>(null) }
    var player by remember { mutableStateOf<MediaPlayer?>(null) }
    var isPlaying by remember { mutableStateOf(false) }

    val permissionLauncher = rememberLauncherForActivityResult(
        ActivityResultContracts.RequestPermission()
    ) { granted -> hasPermission = granted }

    fun startRecordingForWord() {
        if (!hasPermission) return
        try {
            val outputFile = File(context.filesDir, "serena_pullout_${System.currentTimeMillis()}.3gp")
            val newRecorder = MediaRecorder().apply {
                setAudioSource(MediaRecorder.AudioSource.MIC)
                setOutputFormat(MediaRecorder.OutputFormat.THREE_GPP)
                setAudioEncoder(MediaRecorder.AudioEncoder.AMR_NB)
                setOutputFile(outputFile.absolutePath)
                prepare()
                start()
            }
            recorder = newRecorder
            currentFile = outputFile
        } catch (e: Exception) {
            recorder = null
            currentFile = null
        }
    }

    fun stopAndSaveRecording() {
        try {
            recorder?.stop()
            recorder?.release()
        } catch (e: Exception) {
        }
        recorder = null
        val savedFile = currentFile
        if (savedFile != null && savedFile.exists() && savedFile.length() > 0) {
            lastRecordingPath = savedFile.absolutePath
            val entity = RecordingEntity(
                exerciseId = exercise.id,
                filePath = savedFile.absolutePath,
                createdAt = System.currentTimeMillis()
            )
            scope.launch {
                db.recordingDao().insert(entity)
            }
        }
        currentFile = null
    }

    fun playLastRecording() {
        val path = lastRecordingPath ?: return
        player?.release()
        player = MediaPlayer().apply {
            setDataSource(path)
            prepare()
            setOnCompletionListener { isPlaying = false }
            start()
        }
        isPlaying = true
    }

    fun goToPhase(newWord: Int, newPhase: Int) {
        wordIndex = newWord
        phaseIndex = newPhase
        secondsLeft = pullPhases[newPhase].seconds
        scope.launch {
            fillAnim.animateTo(
                pullPhases[newPhase].targetFill,
                animationSpec = tween(durationMillis = pullPhases[newPhase].seconds * 1000)
            )
        }
    }

    fun advance(): Boolean {
        val nextPhase = phaseIndex + 1
        if (nextPhase < pullPhases.size) {
            goToPhase(wordIndex, nextPhase)
            return true
        }
        stopAndSaveRecording()
        val nextWord = wordIndex + 1
        if (nextWord < pullOutWords.size) {
            scope.launch { fillAnim.snapTo(pullPhases[0].targetFill) }
            goToPhase(nextWord, 0)
            startRecordingForWord()
            return true
        }
        onFinish(exercise)
        return false
    }

    LaunchedEffect(Unit) {
        if (!hasPermission) {
            permissionLauncher.launch(Manifest.permission.RECORD_AUDIO)
        }
    }

    LaunchedEffect(hasPermission) {
        if (hasPermission && recorder == null && wordIndex == 0 && phaseIndex == 0) {
            startRecordingForWord()
        }
    }

    LaunchedEffect(Unit) {
        scope.launch {
            fillAnim.animateTo(pullPhases[0].targetFill, animationSpec = tween(durationMillis = pullPhases[0].seconds * 1000))
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

    DisposableEffect(Unit) {
        onDispose {
            try {
                recorder?.stop()
                recorder?.release()
            } catch (e: Exception) {
            }
            player?.release()
        }
    }

    val currentPhase = pullPhases[phaseIndex]

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
                modifier = Modifier.clickable {
                    try {
                        recorder?.stop()
                        recorder?.release()
                    } catch (e: Exception) {
                    }
                    currentFile?.delete()
                    onFinish(null)
                }
            )
            Icon(Icons.Filled.Mic, contentDescription = null, tint = BlueAccent)
        }
        Spacer(modifier = Modifier.height(14.dp))

        Row(horizontalArrangement = Arrangement.spacedBy(4.dp), modifier = Modifier.fillMaxWidth()) {
            pullOutWords.forEachIndexed { index, _ ->
                Box(
                    modifier = Modifier
                        .weight(1f)
                        .height(4.dp)
                        .background(if (index < wordIndex) GreenSuccess else BgCardIcon, shape = RoundedCornerShape(2.dp))
                )
            }
        }
        Spacer(modifier = Modifier.height(16.dp))

        Text("PULL-OUT", color = BlueAccent, fontSize = 11.sp, textAlign = TextAlign.Center, modifier = Modifier.fillMaxWidth())
        Spacer(modifier = Modifier.height(4.dp))
        Text(pullOutWords[wordIndex], color = TextPrimary, fontSize = 22.sp, fontWeight = FontWeight.Bold, textAlign = TextAlign.Center, modifier = Modifier.fillMaxWidth())
        Spacer(modifier = Modifier.height(4.dp))
        Text(currentPhase.instruction, color = TextSecondary, fontSize = 13.sp, textAlign = TextAlign.Center, modifier = Modifier.fillMaxWidth())

        Box(
            modifier = Modifier.fillMaxWidth().weight(1f),
            contentAlignment = Alignment.Center
        ) {
            Column(modifier = Modifier.fillMaxWidth()) {
                Box(
                    modifier = Modifier
                        .fillMaxWidth()
                        .height(14.dp)
                        .background(BgCardIcon, shape = RoundedCornerShape(7.dp))
                ) {
                    Box(
                        modifier = Modifier
                            .fillMaxHeight()
                            .fillMaxWidth(fillAnim.value.coerceIn(0.04f, 1f))
                            .background(BlueAccent, shape = RoundedCornerShape(7.dp))
                    )
                }
                Spacer(modifier = Modifier.height(18.dp))
                Text(secondsLeft.toString(), color = TextPrimary, fontSize = 30.sp, fontWeight = FontWeight.Light, textAlign = TextAlign.Center, modifier = Modifier.fillMaxWidth())
                Text("segundos", color = TextSecondary, fontSize = 11.sp, textAlign = TextAlign.Center, modifier = Modifier.fillMaxWidth())
            }
        }
        Spacer(modifier = Modifier.height(16.dp))

        Row(
            modifier = Modifier
                .fillMaxWidth()
                .background(BgCard, shape = RoundedCornerShape(14.dp))
                .padding(12.dp),
            verticalAlignment = Alignment.CenterVertically
        ) {
            Box(
                modifier = Modifier
                    .size(34.dp)
                    .background(BgCardIcon, shape = CircleShape),
                contentAlignment = Alignment.Center
            ) {
                Icon(Icons.Filled.Mic, contentDescription = null, tint = BlueAccent, modifier = Modifier.size(15.dp))
            }
            Spacer(modifier = Modifier.width(10.dp))
            Text(
                if (!hasPermission) "Se necesita permiso de microfono" else "Grabando tu intento...",
                color = TextSecondary,
                fontSize = 12.sp,
                modifier = Modifier.weight(1f)
            )
            Icon(
                Icons.Filled.PlayArrow,
                contentDescription = "Escuchar intento anterior",
                tint = if (lastRecordingPath != null) TextSecondary else BgCardIcon,
                modifier = Modifier.clickable(enabled = lastRecordingPath != null) { playLastRecording() }
            )
        }
        Spacer(modifier = Modifier.height(12.dp))

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
                Text("Siguiente palabra", color = BgPage, fontSize = 14.sp, fontWeight = FontWeight.Bold)
            }
        }
    }
}
