package com.example.serena.ui.screens

import android.Manifest
import android.content.pm.PackageManager
import android.net.Uri
import android.widget.VideoView
import androidx.activity.compose.rememberLauncherForActivityResult
import androidx.activity.result.contract.ActivityResultContracts
import androidx.camera.core.CameraSelector
import androidx.camera.core.Preview
import androidx.camera.lifecycle.ProcessCameraProvider
import androidx.camera.video.FileOutputOptions
import androidx.camera.video.Quality
import androidx.camera.video.QualitySelector
import androidx.camera.video.Recorder
import androidx.camera.video.Recording
import androidx.camera.video.VideoCapture
import androidx.camera.video.VideoRecordEvent
import androidx.camera.view.PreviewView
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Close
import androidx.compose.material.icons.filled.Refresh
import androidx.compose.material.icons.filled.Videocam
import androidx.compose.material3.Icon
import androidx.compose.material3.Text
import androidx.compose.ui.graphics.Color
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.platform.LocalLifecycleOwner
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.compose.ui.viewinterop.AndroidView
import androidx.core.content.ContextCompat
import com.example.serena.data.AppDatabase
import com.example.serena.data.ExerciseEntity
import com.example.serena.data.RecordingEntity
import com.example.serena.ui.theme.*
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch
import java.io.File

private const val MAX_SECONDS = 20

@Composable
fun VideoScanScreen(
    exercise: ExerciseEntity,
    onFinish: (ExerciseEntity?) -> Unit
) {
    val context = LocalContext.current
    val lifecycleOwner = LocalLifecycleOwner.current
    val db = remember { AppDatabase.getInstance(context) }
    val scope = rememberCoroutineScope()

    var hasCameraPermission by remember {
        mutableStateOf(
            ContextCompat.checkSelfPermission(context, Manifest.permission.CAMERA) == PackageManager.PERMISSION_GRANTED
        )
    }
    var hasAudioPermission by remember {
        mutableStateOf(
            ContextCompat.checkSelfPermission(context, Manifest.permission.RECORD_AUDIO) == PackageManager.PERMISSION_GRANTED
        )
    }

    val permissionLauncher = rememberLauncherForActivityResult(
        ActivityResultContracts.RequestMultiplePermissions()
    ) { results ->
        hasCameraPermission = results[Manifest.permission.CAMERA] ?: hasCameraPermission
        hasAudioPermission = results[Manifest.permission.RECORD_AUDIO] ?: hasAudioPermission
    }

    var isRecording by remember { mutableStateOf(false) }
    var secondsElapsed by remember { mutableStateOf(0) }
    var recordedFile by remember { mutableStateOf<File?>(null) }
    var activeRecording by remember { mutableStateOf<Recording?>(null) }
    var videoCapture by remember { mutableStateOf<VideoCapture<Recorder>?>(null) }
    var cameraProviderRef by remember { mutableStateOf<androidx.camera.lifecycle.ProcessCameraProvider?>(null) }

    LaunchedEffect(Unit) {
        val missing = mutableListOf<String>()
        if (!hasCameraPermission) missing.add(Manifest.permission.CAMERA)
        if (!hasAudioPermission) missing.add(Manifest.permission.RECORD_AUDIO)
        if (missing.isNotEmpty()) {
            permissionLauncher.launch(missing.toTypedArray())
        }
    }

    fun startRecording() {
        val capture = videoCapture ?: return
        val outputFile = File(context.filesDir, "serena_video_${System.currentTimeMillis()}.mp4")
        val options = FileOutputOptions.Builder(outputFile).build()

        val pending = capture.output.prepareRecording(context, options)
        val withAudio = if (hasAudioPermission) pending.withAudioEnabled() else pending

        activeRecording = withAudio.start(ContextCompat.getMainExecutor(context)) { event ->
            if (event is VideoRecordEvent.Finalize) {
                if (!event.hasError()) {
                    recordedFile = outputFile
                }
                isRecording = false
                activeRecording = null
            }
        }
        isRecording = true
        secondsElapsed = 0
    }

    fun stopRecording() {
        activeRecording?.stop()
    }

    fun discardAndRetry() {
        recordedFile?.delete()
        recordedFile = null
        secondsElapsed = 0
    }

    fun saveAndFinish() {
        val file = recordedFile
        if (file != null && file.exists() && file.length() > 0) {
            val entity = RecordingEntity(
                exerciseId = exercise.id,
                filePath = file.absolutePath,
                createdAt = System.currentTimeMillis()
            )
            scope.launch {
                db.recordingDao().insert(entity)
            }
        }
        onFinish(exercise)
    }

    LaunchedEffect(isRecording) {
        while (isRecording) {
            delay(1000)
            secondsElapsed += 1
            if (secondsElapsed >= MAX_SECONDS) {
                stopRecording()
            }
        }
    }

    DisposableEffect(Unit) {
        onDispose {
            cameraProviderRef?.unbindAll()
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
                modifier = Modifier.clickable {
                    if (isRecording) stopRecording()
                    recordedFile?.delete()
                    onFinish(null)
                }
            )
        }
        Spacer(modifier = Modifier.height(12.dp))

        Text(exercise.name.uppercase(), color = BlueAccent, fontSize = 11.sp)
        Spacer(modifier = Modifier.height(4.dp))
        Text(exercise.description, color = TextSecondary, fontSize = 13.sp)
        Spacer(modifier = Modifier.height(16.dp))

        Box(
            modifier = Modifier
                .fillMaxWidth()
                .weight(1f)
                .background(BgCard, shape = RoundedCornerShape(16.dp))
        ) {
            if (recordedFile != null) {
                AndroidView(
                    modifier = Modifier.fillMaxSize(),
                    factory = { ctx ->
                        VideoView(ctx).apply {
                            setVideoURI(Uri.fromFile(recordedFile))
                            setOnPreparedListener { it.isLooping = true; start() }
                        }
                    }
                )
            } else if (!hasCameraPermission) {
                Box(modifier = Modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
                    Text("Se necesita permiso de camara", color = TextSecondary, fontSize = 13.sp)
                }
            } else {
                AndroidView(
                    modifier = Modifier.fillMaxSize(),
                    factory = { ctx ->
                        val previewView = PreviewView(ctx)
                        val cameraProviderFuture = ProcessCameraProvider.getInstance(ctx)
                        cameraProviderFuture.addListener({
                            val cameraProvider = cameraProviderFuture.get()
                            cameraProviderRef = cameraProvider
                            val preview = Preview.Builder().build().also {
                                it.surfaceProvider = previewView.surfaceProvider
                            }
                            val recorder = Recorder.Builder()
                                .setQualitySelector(QualitySelector.from(Quality.SD))
                                .build()
                            val capture = VideoCapture.withOutput(recorder)
                            videoCapture = capture

                            try {
                                cameraProvider.unbindAll()
                                cameraProvider.bindToLifecycle(
                                    lifecycleOwner,
                                    CameraSelector.DEFAULT_FRONT_CAMERA,
                                    preview,
                                    capture
                                )
                            } catch (e: Exception) {
                            }
                        }, ContextCompat.getMainExecutor(ctx))
                        previewView
                    }
                )
            }

            if (isRecording) {
                Box(
                    modifier = Modifier
                        .align(Alignment.TopCenter)
                        .padding(top = 12.dp)
                        .background(Color(0x99000000), shape = RoundedCornerShape(12.dp))
                        .padding(horizontal = 12.dp, vertical = 6.dp)
                ) {
                    Text(
                        "${secondsElapsed}s / ${MAX_SECONDS}s",
                        color = androidx.compose.ui.graphics.Color.White,
                        fontSize = 12.sp
                    )
                }
            }
        }
        Spacer(modifier = Modifier.height(16.dp))

        if (recordedFile == null) {
            Box(
                modifier = Modifier
                    .fillMaxWidth()
                    .background(if (isRecording) Color(0xFFD84343) else BlueAccent, shape = RoundedCornerShape(14.dp))
                    .clickable {
                        if (isRecording) stopRecording() else startRecording()
                    }
                    .padding(vertical = 16.dp),
                contentAlignment = Alignment.Center
            ) {
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Icon(Icons.Filled.Videocam, contentDescription = null, tint = BgPage, modifier = Modifier.size(18.dp))
                    Spacer(modifier = Modifier.width(8.dp))
                    Text(if (isRecording) "Detener" else "Grabar", color = BgPage, fontSize = 14.sp, fontWeight = FontWeight.Bold)
                }
            }
        } else {
            Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                Box(
                    modifier = Modifier
                        .size(52.dp)
                        .background(BgCardIcon, shape = RoundedCornerShape(14.dp))
                        .clickable { discardAndRetry() },
                    contentAlignment = Alignment.Center
                ) {
                    Icon(Icons.Filled.Refresh, contentDescription = "Regrabar", tint = TextSecondary)
                }
                Box(
                    modifier = Modifier
                        .weight(1f)
                        .background(BlueAccent, shape = RoundedCornerShape(14.dp))
                        .clickable { saveAndFinish() }
                        .padding(vertical = 16.dp),
                    contentAlignment = Alignment.Center
                ) {
                    Text("Guardar", color = BgPage, fontSize = 14.sp, fontWeight = FontWeight.Bold)
                }
            }
        }
    }
}
