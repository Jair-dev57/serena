import 'package:flutter/material.dart';
import '../data/exercises_data.dart';
import '../data/local_db.dart';
import '../data/exercise_path_logic.dart';
import '../data/weekly_goal_manager.dart';
import '../models/exercise.dart';
import '../theme/app_styles.dart';
import '../widgets/stat_chip.dart';
import '../widgets/weekly_goal_card.dart';
import 'guided_exercise_screen.dart';
import 'breathing_timer_screen.dart';
import 'progress_screen.dart';
import 'difficult_words_screen.dart';
import 'block_diary_screen.dart';
import 'settings_screen.dart';

class RouteScreen extends StatefulWidget {
  const RouteScreen({super.key});

  @override
  State<RouteScreen> createState() => _RouteScreenState();
}

class _RouteScreenState extends State<RouteScreen> {
  Map<String, ExerciseProgress> _progressById = {};
  bool _loading = true;
  int _streak = 0;
  bool _hasRecentStrongBlock = false;
  int _weeklyTarget = WeeklyGoalManager.defaultTarget;
  int _sessionsThisWeek = 0;

  static const List<ExerciseCategory> _orderedCategories = [
    ExerciseCategory.respiracion,
    ExerciseCategory.inicioSuave,
    ExerciseCategory.ritmo,
    ExerciseCategory.lectura,
  ];

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final allProgress = await LocalDb.instance.getAllProgress();
    final streak = await LocalDb.instance.getCurrentStreak();
    final blockEntries = await LocalDb.instance.getAllBlockEntries();
    final sessions = await LocalDb.instance.getAllSessions();
    final weeklyTarget = await WeeklyGoalManager.getTarget();
    setState(() {
      _progressById = {for (final p in allProgress) p.exerciseId: p};
      _streak = streak;
      _hasRecentStrongBlock = ExercisePathLogic.hasRecentStrongBlock(blockEntries);
      _weeklyTarget = weeklyTarget;
      _sessionsThisWeek = WeeklyGoalManager.sessionsThisWeek(sessions);
      _loading = false;
    });
  }

  Future<void> _onWeeklyTargetChanged(int newTarget) async {
    await WeeklyGoalManager.setTarget(newTarget);
    setState(() {
      _weeklyTarget = newTarget;
    });
  }

  int get _totalExercises => exercises.length;

  int get _completedExercises =>
      exercises.where((e) => (_progressById[e.id]?.timesCompleted ?? 0) > 0).length;

  Future<void> _openExercise(Exercise exercise) async {
    final isBreathing = exercise.category == ExerciseCategory.respiracion;
    final completed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => isBreathing
            ? BreathingTimerScreen(exercise: exercise)
            : GuidedExerciseScreen(exercise: exercise),
      ),
    );
    if (completed == true) {
      _loadProgress();
    }
  }

  void _practiceRespiracion() {
    final respiracionExercises = ExercisePathLogic.exercisesForCategory(
      exercises,
      ExerciseCategory.respiracion,
    );
    final recommended = respiracionExercises.firstWhere(
      (e) => ExercisePathLogic.isUnlocked(e, respiracionExercises, _progressById),
      orElse: () => respiracionExercises.first,
    );
    _openExercise(recommended);
  }

  void _showStreakInfo() {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.local_fire_department, size: 48, color: Colors.orange),
              const SizedBox(height: 12),
              Text(
                _streak == 1 ? '1 día de racha' : '$_streak días de racha',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Practicá al menos un ejercicio por día para mantener tu racha activa.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        );
      },
    );
  }

  void _showGoalInfo() {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              child: WeeklyGoalCard(
                sessionsThisWeek: _sessionsThisWeek,
                target: _weeklyTarget,
                onTargetChanged: (newTarget) async {
                  await _onWeeklyTargetChanged(newTarget);
                  setSheetState(() {});
                },
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildNode(Exercise exercise, bool unlocked, bool alignRight) {
    final progress = _progressById[exercise.id];
    final rank = progress?.rank ?? ExerciseRank.cobre;
    final timesCompleted = progress?.timesCompleted ?? 0;

    Widget node;
    if (!unlocked) {
      node = Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
        ),
        child: Icon(
          Icons.lock_outline,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      );
    } else {
      final color = timesCompleted > 0 ? AppStyles.rankColor(rank) : Theme.of(context).colorScheme.primary;
      node = Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
        child: Icon(
          timesCompleted > 0 ? Icons.emoji_events : Icons.play_arrow,
          color: Colors.white,
          size: 28,
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.only(
        left: alignRight ? 70 : 0,
        right: alignRight ? 0 : 70,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: unlocked ? () => _openExercise(exercise) : null,
            customBorder: const CircleBorder(),
            child: node,
          ),
          const SizedBox(height: 6),
          SizedBox(
            width: 90,
            child: Text(
              exercise.title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (unlocked && timesCompleted > 0) ...[
            Text(
              rank.label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppStyles.rankColor(rank),
                    fontWeight: FontWeight.bold,
                  ),
            ),
            if (progress!.repsToNextRank > 0)
              Text(
                '${progress.repsToNextRank} para subir',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 10,
                    ),
              )
            else
              Text(
                'Rango máximo',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 10,
                    ),
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildCategorySection(ExerciseCategory category, bool categoryUnlocked) {
    final categoryExercises = ExercisePathLogic.exercisesForCategory(exercises, category);

    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Card(
        elevation: 0,
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        shape: AppStyles.cardShape(),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!categoryUnlocked)
                    Icon(Icons.lock_outline, size: 18, color: Theme.of(context).colorScheme.onSurfaceVariant),
                  if (!categoryUnlocked) const SizedBox(width: 6),
                  Text(
                    category.label,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (!categoryUnlocked)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'Completa la sección anterior para desbloquear esta.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                )
              else
                for (int i = 0; i < categoryExercises.length; i++) ...[
                  _buildNode(
                    categoryExercises[i],
                    ExercisePathLogic.isUnlocked(categoryExercises[i], categoryExercises, _progressById),
                    i.isOdd,
                  ),
                  if (i < categoryExercises.length - 1)
                    Container(
                      width: 2,
                      height: 24,
                      color: Theme.of(context).colorScheme.outlineVariant,
                    ),
                ],
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final exercisesByCategory = <ExerciseCategory, List<Exercise>>{
      for (final category in _orderedCategories)
        category: ExercisePathLogic.exercisesForCategory(exercises, category),
    };

    final goalAchieved = _sessionsThisWeek >= _weeklyTarget;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Serena'),
        actions: [
          StatChip(
            icon: Icons.local_fire_department,
            label: '$_streak',
            iconColor: Colors.orange,
            onTap: _showStreakInfo,
          ),
          StatChip(
            icon: goalAchieved ? Icons.emoji_events : Icons.flag_outlined,
            label: '$_sessionsThisWeek/$_weeklyTarget',
            onTap: _showGoalInfo,
          ),
          const SizedBox(width: 8),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
              child: const Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'Serena',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.fitness_center),
              title: const Text('Ruta de práctica'),
              onTap: () => Navigator.of(context).pop(),
            ),
            ListTile(
              leading: const Icon(Icons.show_chart),
              title: const Text('Mi progreso'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const ProgressScreen()),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.book_outlined),
              title: const Text('Diario de bloqueos'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const BlockDiaryScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.spellcheck),
              title: const Text('Palabras difíciles'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const DifficultWordsScreen()),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: const Text('Ajustes'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const SettingsScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (_hasRecentStrongBlock)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Card(
                elevation: 0,
                color: Theme.of(context).colorScheme.errorContainer,
                shape: AppStyles.cardShape(),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Theme.of(context).colorScheme.onErrorContainer,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Notamos bloqueos fuertes recientes',
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                    color: Theme.of(context).colorScheme.onErrorContainer,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Un ejercicio de respiración puede ayudarte a regularte antes de hablar.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onErrorContainer,
                            ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.tonal(
                          onPressed: _practiceRespiracion,
                          child: const Text('Practicar respiración'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          Card(
            elevation: 0,
            color: Theme.of(context).colorScheme.primaryContainer,
            shape: AppStyles.cardShape(),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Tu progreso',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onPrimaryContainer,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        '$_completedExercises / $_totalExercises',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onPrimaryContainer,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: _totalExercises == 0 ? 0 : _completedExercises / _totalExercises,
                      minHeight: 10,
                      backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer.withValues(alpha: 0.15),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          for (final category in _orderedCategories)
            _buildCategorySection(
              category,
              ExercisePathLogic.isCategoryUnlocked(
                category,
                _orderedCategories,
                exercisesByCategory,
                _progressById,
              ),
            ),
        ],
      ),
    );
  }
}