package com.example.serena.ui.screens

import android.Manifest
import android.content.pm.PackageManager
import android.media.MediaPlayer
import android.media.MediaRecorder
import androidx.activity.compose.rememberLauncherForActivityResult
import androidx.activity.result.contract.ActivityResultContracts
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
import androidx.compose.material.icons.filled.Refresh
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

private val prompts = listOf(
    "Cual fue el mejor momento de tu semana?",
    "Describe un lugar donde te sientas en calma.",
    "Cuentame sobre algo que te gustaria aprender."
)

@Composable
fun TalkScreen(
    exercise: ExerciseEntity,
    onFinish: (ExerciseEntity?) -> Unit
) {
    val context = LocalContext.current
    val db = remember { AppDatabase.getInstance(context) }
    val scope = rememberCoroutineScope()

    var promptIndex by remember { mutableStateOf(0) }
    var secondsElapsed by remember { mutableStateOf(0) }
    var isPaused by remember { mutableStateOf(false) }
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
    val barHeights = remember { mutableStateListOf(0.2f, 0.2f, 0.2f, 0.2f, 0.2f, 0.2f, 0.2f) }

    val permissionLauncher = rememberLauncherForActivityResult(
        ActivityResultContracts.RequestPermission()
    ) { granted -> hasPermission = granted }

    var showSummary by remember { mutableStateOf(false) }
    val savedRecordings = remember { mutableStateListOf<com.example.serena.data.RecordingEntity>() }

    fun startRecording() {
        if (!hasPermission) return
        try {
            val outputFile = File(context.filesDir, "serena_recording_${System.currentTimeMillis()}.3gp")
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
            isPaused = false
            secondsElapsed = 0
        } catch (e: Exception) {
            recorder = null
            currentFile = null
        }
    }

    fun togglePause() {
        val current = recorder ?: return
        try {
            if (isPaused) {
                current.resume()
                isPaused = false
            } else {
                current.pause()
                isPaused = true
            }
        } catch (e: Exception) {
            // pausar/reanudar no soportado en este momento, ignoramos
        }
    }

    fun cancelAndReRecord() {
        try {
            recorder?.stop()
            recorder?.release()
        } catch (e: Exception) { }
        recorder = null
        currentFile?.delete()
        currentFile = null
        startRecording()
    }

    fun stopRecordingAndSave() {
        try {
            recorder?.stop()
            recorder?.release()
        } catch (e: Exception) {
            // grabacion muy corta, ignoramos
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
            savedRecordings.add(entity)
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

    fun saveAndAdvance(): Boolean {
        stopRecordingAndSave()
        val next = promptIndex + 1
        if (next < prompts.size) {
            promptIndex = next
            startRecording()
            return true
        }
        showSummary = true
        return false
    }

    LaunchedEffect(Unit) {
        if (!hasPermission) {
            permissionLauncher.launch(Manifest.permission.RECORD_AUDIO)
        }
    }

    LaunchedEffect(hasPermission) {
        if (hasPermission && recorder == null) {
            startRecording()
        }
    }

    LaunchedEffect(Unit) {
        var tick = 0
        while (true) {
            delay(350)
            if (isPaused) continue
            val amplitude = recorder?.maxAmplitude ?: 0
            val normalized = (amplitude / 20000f).coerceIn(0.15f, 1f)
            for (i in barHeights.indices) {
                barHeights[i] = normalized * (0.6f + kotlin.random.Random.nextFloat() * 0.4f)
            }
            tick += 1
            if (tick % 3 == 0) {
                secondsElapsed += 1
            }
        }
    }

    DisposableEffect(Unit) {
        onDispose {
            try {
                recorder?.stop()
                recorder?.release()
            } catch (e: Exception) { }
            player?.release()
        }
    }

    if (showSummary) {
        TalkSummaryScreen(
            recordings = savedRecordings,
            prompts = prompts,
            onDone = { onFinish(exercise) }
        )
        return
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
                modifier = Modifier.clickable {
                    try {
                        recorder?.stop()
                        recorder?.release()
                    } catch (e: Exception) { }
                    currentFile?.delete()
                    onFinish(null)
                }
            )
        }
        Spacer(modifier = Modifier.height(16.dp))

        Row(horizontalArrangement = Arrangement.spacedBy(4.dp), modifier = Modifier.fillMaxWidth()) {
            prompts.forEachIndexed { index, _ ->
                Box(
                    modifier = Modifier
                        .weight(1f)
                        .height(4.dp)
                        .background(if (index <= promptIndex) GreenSuccess else BgCardIcon, shape = RoundedCornerShape(2.dp))
                )
            }
        }
        Spacer(modifier = Modifier.height(24.dp))

        Text(exercise.name.uppercase(), color = BlueAccent, fontSize = 11.sp, textAlign = TextAlign.Center, modifier = Modifier.fillMaxWidth())
        Spacer(modifier = Modifier.height(16.dp))

        Box(
            modifier = Modifier
                .fillMaxWidth()
                .background(BgCard, shape = RoundedCornerShape(16.dp))
                .padding(18.dp)
        ) {
            Text(prompts[promptIndex], color = TextPrimary, fontSize = 16.sp, textAlign = TextAlign.Center, modifier = Modifier.fillMaxWidth())
        }
        Spacer(modifier = Modifier.height(12.dp))

        if (lastRecordingPath != null) {
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .background(BgCard, shape = RoundedCornerShape(12.dp))
                    .clickable { playLastRecording() }
                    .padding(12.dp),
                verticalAlignment = Alignment.CenterVertically
            ) {
                Icon(Icons.Filled.PlayArrow, contentDescription = null, tint = BlueAccent)
                Spacer(modifier = Modifier.width(8.dp))
                Text(
                    if (isPlaying) "Reproduciendo tu respuesta anterior..." else "Escuchar tu respuesta anterior",
                    color = TextSecondary,
                    fontSize = 12.sp
                )
            }
            Spacer(modifier = Modifier.height(16.dp))
        }

        Box(
            modifier = Modifier.fillMaxWidth().weight(1f),
            contentAlignment = Alignment.Center
        ) {
            Column(horizontalAlignment = Alignment.CenterHorizontally) {
                Box(
                    modifier = Modifier
                        .size(64.dp)
                        .background(if (isPaused) BgCardIcon else BlueAccent, shape = CircleShape),
                    contentAlignment = Alignment.Center
                ) {
                    Icon(Icons.Filled.Mic, contentDescription = null, tint = if (isPaused) TextSecondary else BgPage, modifier = Modifier.size(28.dp))
                }
                Spacer(modifier = Modifier.height(20.dp))
                Row(
                    verticalAlignment = Alignment.Bottom,
                    horizontalArrangement = Arrangement.spacedBy(5.dp),
                    modifier = Modifier.height(36.dp)
                ) {
                    barHeights.forEach { height ->
                        Box(
                            modifier = Modifier
                                .width(6.dp)
                                .fillMaxHeight(height)
                                .background(if (isPaused) BgCardIcon else BlueAccent, shape = RoundedCornerShape(3.dp))
                        )
                    }
                }
                Spacer(modifier = Modifier.height(12.dp))
                Text(
                    when {
                        !hasPermission -> "Se necesita permiso de microfono"
                        isPaused -> "Pausado - ${secondsElapsed / 60}:${(secondsElapsed % 60).toString().padStart(2, '0')}"
                        else -> "Grabando... ${secondsElapsed / 60}:${(secondsElapsed % 60).toString().padStart(2, '0')}"
                    },
                    color = TextSecondary,
                    fontSize = 13.sp
                )
            }
        }
        Spacer(modifier = Modifier.height(16.dp))

        Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
            Box(
                modifier = Modifier
                    .size(52.dp)
                    .background(BgCard, shape = RoundedCornerShape(14.dp))
                    .clickable { togglePause() },
                contentAlignment = Alignment.Center
            ) {
                Icon(if (isPaused) Icons.Filled.PlayArrow else Icons.Filled.Pause, contentDescription = null, tint = TextSecondary)
            }
            Box(
                modifier = Modifier
                    .size(52.dp)
                    .background(BgCard, shape = RoundedCornerShape(14.dp))
                    .clickable { cancelAndReRecord() },
                contentAlignment = Alignment.Center
            ) {
                Icon(Icons.Filled.Refresh, contentDescription = "Cancelar y regrabar", tint = TextSecondary)
            }
            Box(
                modifier = Modifier
                    .weight(1f)
                    .background(BlueAccent, shape = RoundedCornerShape(14.dp))
                    .clickable { saveAndAdvance() }
                    .padding(vertical = 16.dp),
                contentAlignment = Alignment.Center
            ) {
                Text("Guardar y continuar", color = BgPage, fontSize = 14.sp, fontWeight = FontWeight.Bold)
            }
        }
    }
}