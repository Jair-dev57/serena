package com.example.serena

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.BarChart
import androidx.compose.material.icons.filled.GraphicEq
import androidx.compose.material.icons.filled.Home
import androidx.compose.material.icons.filled.Person
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import com.example.serena.data.AppDatabase
import com.example.serena.data.Difficulty
import com.example.serena.data.ExerciseCategory
import com.example.serena.data.ExerciseEntity
import com.example.serena.ui.screens.BlockJournalScreen
import com.example.serena.ui.screens.BreathingScreen
import com.example.serena.ui.screens.ExercisesScreen
import com.example.serena.ui.screens.HomeScreen
import com.example.serena.ui.screens.ProfileScreen
import com.example.serena.ui.screens.ProgressScreen
import com.example.serena.ui.screens.ReadingScreen
import com.example.serena.ui.screens.TalkScreen
import com.example.serena.ui.screens.PullOutScreen
import com.example.serena.ui.theme.BgCard
import com.example.serena.ui.theme.BgPage
import com.example.serena.ui.theme.BlueAccent
import com.example.serena.ui.theme.SerenaTheme
import com.example.serena.ui.theme.TextSecondary
import kotlinx.coroutines.launch
import androidx.compose.material.icons.filled.Book
import com.example.serena.ui.screens.WarmupScreen
class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        val db = AppDatabase.getInstance(applicationContext)

        setContent {
            var exercises by remember { mutableStateOf(listOf<ExerciseEntity>()) }
            var selectedTab by remember { mutableStateOf(0) }
            var runningExercise by remember { mutableStateOf<ExerciseEntity?>(null) }
            var showJournal by remember { mutableStateOf(false) }
            var showWarmup by remember { mutableStateOf(false) }
            val scope = rememberCoroutineScope()
            val dao = db.exerciseDao()

            suspend fun reload() {
                if (dao.countExercises() == 0) {
                    dao.insertAll(seedExercises())
                }
                exercises = dao.getAllExercises()
            }

            LaunchedEffect(Unit) { reload() }

            SerenaTheme {
                if (showJournal) {
                    BlockJournalScreen()
                } else if (showWarmup) {
                    WarmupScreen(onFinish = { showWarmup = false })
                } else if (runningExercise != null) {
                    val exercise = runningExercise!!
                    when (exercise.category) {
                        ExerciseCategory.RESPIRACION -> BreathingScreen(
                            exercise = exercise,
                            onFinish = { finished ->
                                if (finished != null) {
                                    scope.launch {
                                        dao.setCompleted(finished.id, true)
                                        db.practiceSessionDao().insert(
                                            com.example.serena.data.PracticeSessionEntity(
                                                exerciseId = finished.id,
                                                completedAt = System.currentTimeMillis(),
                                                durationMinutes = finished.durationMinutes,
                                                fluencyScore = com.example.serena.data.ProgressCalculator.randomFluencyScore()
                                            )
                                        )
                                        val prefs = db.userPreferencesDao().get()
                                        if (prefs?.remindersEnabled == true) {
                                            com.example.serena.ReminderScheduler.scheduleNext(applicationContext)
                                        }
                                        reload()
                                    }
                                }
                                runningExercise = null
                            }
                        )
                        ExerciseCategory.LECTURA -> ReadingScreen(
                            exercise = exercise,
                            onFinish = { finished ->
                                if (finished != null) {
                                    scope.launch {
                                        dao.setCompleted(finished.id, true)
                                        db.practiceSessionDao().insert(
                                            com.example.serena.data.PracticeSessionEntity(
                                                exerciseId = finished.id,
                                                completedAt = System.currentTimeMillis(),
                                                durationMinutes = finished.durationMinutes,
                                                fluencyScore = com.example.serena.data.ProgressCalculator.randomFluencyScore()
                                            )
                                        )
                                        val prefs = db.userPreferencesDao().get()
                                        if (prefs?.remindersEnabled == true) {
                                            com.example.serena.ReminderScheduler.scheduleNext(applicationContext)
                                        }
                                        reload()
                                    }
                                }
                                runningExercise = null
                            }
                        )
                        ExerciseCategory.HABLA -> {
                            val onExerciseFinish: (ExerciseEntity?) -> Unit = { finished ->
                                if (finished != null) {
                                    scope.launch {
                                        dao.setCompleted(finished.id, true)
                                        db.practiceSessionDao().insert(
                                            com.example.serena.data.PracticeSessionEntity(
                                                exerciseId = finished.id,
                                                completedAt = System.currentTimeMillis(),
                                                durationMinutes = finished.durationMinutes,
                                                fluencyScore = com.example.serena.data.ProgressCalculator.randomFluencyScore()
                                            )
                                        )
                                        val prefs = db.userPreferencesDao().get()
                                        if (prefs?.remindersEnabled == true) {
                                            com.example.serena.ReminderScheduler.scheduleNext(applicationContext)
                                        }
                                        reload()
                                    }
                                }
                                runningExercise = null
                            }
                            when (exercise.shortName) {
                                "PullOut" -> PullOutScreen(
                                    exercise = exercise,
                                    onFinish = onExerciseFinish
                                )
                                else -> TalkScreen(
                                    exercise = exercise,
                                    onFinish = onExerciseFinish
                                )
                            }
                        }
                    }
                } else {
                    Scaffold(
                        modifier = Modifier.fillMaxSize(),
                        bottomBar = {
                            NavigationBar(containerColor = BgCard) {
                                NavigationBarItem(
                                    selected = selectedTab == 0,
                                    onClick = { selectedTab = 0 },
                                    icon = { Icon(Icons.Filled.Home, contentDescription = "Inicio") },
                                    label = { Text("Inicio") },
                                    colors = NavigationBarItemDefaults.colors(
                                        selectedIconColor = BgPage,
                                        selectedTextColor = BlueAccent,
                                        indicatorColor = BlueAccent,
                                        unselectedIconColor = TextSecondary,
                                        unselectedTextColor = TextSecondary
                                    )
                                )
                                NavigationBarItem(
                                    selected = selectedTab == 1,
                                    onClick = { selectedTab = 1 },
                                    icon = { Icon(Icons.Filled.GraphicEq, contentDescription = "Ejercicios") },
                                    label = { Text("Ejercicios") },
                                    colors = NavigationBarItemDefaults.colors(
                                        selectedIconColor = BgPage,
                                        selectedTextColor = BlueAccent,
                                        indicatorColor = BlueAccent,
                                        unselectedIconColor = TextSecondary,
                                        unselectedTextColor = TextSecondary
                                    )
                                )
                                NavigationBarItem(
                                    selected = selectedTab == 4,
                                    onClick = { selectedTab = 4 },
                                    icon = { Icon(Icons.Filled.Book, contentDescription = "Diario") },
                                    label = { Text("Diario") },
                                    colors = NavigationBarItemDefaults.colors(
                                        selectedIconColor = BgPage,
                                        selectedTextColor = BlueAccent,
                                        indicatorColor = BlueAccent,
                                        unselectedIconColor = TextSecondary,
                                        unselectedTextColor = TextSecondary
                                    )
                                )
                                NavigationBarItem(
                                    selected = selectedTab == 2,
                                    onClick = { selectedTab = 2 },
                                    icon = { Icon(Icons.Filled.BarChart, contentDescription = "Progreso") },
                                    label = { Text("Progreso") },
                                    colors = NavigationBarItemDefaults.colors(
                                        selectedIconColor = BgPage,
                                        selectedTextColor = BlueAccent,
                                        indicatorColor = BlueAccent,
                                        unselectedIconColor = TextSecondary,
                                        unselectedTextColor = TextSecondary
                                    )
                                )
                                NavigationBarItem(
                                    selected = selectedTab == 3,
                                    onClick = { selectedTab = 3 },
                                    icon = { Icon(Icons.Filled.Person, contentDescription = "Perfil") },
                                    label = { Text("Perfil") },
                                    colors = NavigationBarItemDefaults.colors(
                                        selectedIconColor = BgPage,
                                        selectedTextColor = BlueAccent,
                                        indicatorColor = BlueAccent,
                                        unselectedIconColor = TextSecondary,
                                        unselectedTextColor = TextSecondary
                                    )
                                )
                            }
                        }
                    ) { innerPadding ->
                        Box(modifier = Modifier.padding(innerPadding)) {
                            when (selectedTab) {
                                0 -> {
                                    var sessions by remember { mutableStateOf(listOf<com.example.serena.data.PracticeSessionEntity>()) }
                                    LaunchedEffect(exercises) {
                                        sessions = db.practiceSessionDao().getAll()
                                    }
                                    HomeScreen(
                                        exercises = exercises,
                                        streakDays = com.example.serena.data.ProgressCalculator.getStreakDays(sessions),
                                        onStart = { exercise -> runningExercise = exercise },
                                        onOpenWarmup = { showWarmup = true }
                                    )
                                }
                                1 -> ExercisesScreen(
                                    exercises = exercises,
                                    onToggleCompleted = { exercise ->
                                        scope.launch {
                                            dao.setCompleted(exercise.id, !exercise.completed)
                                            reload()
                                        }
                                    }
                                )
                                2 -> ProgressScreen(onOpenJournal = { showJournal = true })
                                3 -> ProfileScreen()
                                else -> BlockJournalScreen()
                            }
                        }
                    }
                }
            }
        }
    }
}

fun seedExercises(): List<ExerciseEntity> = listOf(
    ExerciseEntity(name = "Respiracion 4-7-8", shortName = "Sosten", description = "Calma el ritmo antes de hablar", durationMinutes = 5, difficulty = Difficulty.SUAVE, category = ExerciseCategory.RESPIRACION, icon = "air"),
    ExerciseEntity(name = "Lectura pausada", shortName = "Lectura", description = "Practica leyendo con calma", durationMinutes = 8, difficulty = Difficulty.SUAVE, category = ExerciseCategory.LECTURA, icon = "menu_book"),
    ExerciseEntity(name = "Silabas ritmicas", shortName = "Ritmo", description = "Marca el ritmo de las silabas", durationMinutes = 6, difficulty = Difficulty.MEDIO, category = ExerciseCategory.HABLA, icon = "graphic_eq"),
    ExerciseEntity(name = "Inicio suave de palabra", shortName = "Inicio", description = "Suaviza el comienzo al hablar", durationMinutes = 7, difficulty = Difficulty.MEDIO, category = ExerciseCategory.HABLA, icon = "mic"),
    ExerciseEntity(name = "Conversacion guiada", shortName = "Charla", description = "Practica en una conversacion real", durationMinutes = 10, difficulty = Difficulty.RETADOR, category = ExerciseCategory.HABLA, icon = "chat_bubble"),
    ExerciseEntity(name = "Lectura con metronomo", shortName = "Metronomo", description = "Lee siguiendo un ritmo constante", durationMinutes = 8, difficulty = Difficulty.MEDIO, category = ExerciseCategory.LECTURA, icon = "graphic_eq"),
    ExerciseEntity(name = "Pull-out", shortName = "PullOut", description = "Practica soltar la tension y deslizar el sonido en un bloqueo", durationMinutes = 6, difficulty = Difficulty.RETADOR, category = ExerciseCategory.HABLA, icon = "mic")
)