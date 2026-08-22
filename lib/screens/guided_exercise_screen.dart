import 'package:flutter/material.dart';
import '../data/local_db.dart';
import '../models/exercise.dart';
import '../theme/app_styles.dart';
import '../widgets/recorder_widget.dart';
import '../widgets/metronome_widget.dart';
import '../widgets/step_card.dart';
import '../widgets/repetition_tracker.dart';

class GuidedExerciseScreen extends StatefulWidget {
  final Exercise exercise;

  const GuidedExerciseScreen({super.key, required this.exercise});

  @override
  State<GuidedExerciseScreen> createState() => _GuidedExerciseScreenState();
}

class _GuidedExerciseScreenState extends State<GuidedExerciseScreen>
    with SingleTickerProviderStateMixin {
  bool _completed = false;
  ExerciseRank? _newRank;
  bool _rankedUp = false;

  late final AnimationController _badgeController;
  late final Animation<double> _badgeScale;

  @override
  void initState() {
    super.initState();
    _badgeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _badgeScale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.2), weight: 60),
      TweenSequenceItem(tween: Tween(begin: 1.2, end: 1.0), weight: 40),
    ]).animate(CurvedAnimation(parent: _badgeController, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _badgeController.dispose();
    super.dispose();
  }

  Future<void> _markCompleted() async {
    final before = await LocalDb.instance.getProgressForExercise(widget.exercise.id);
    await LocalDb.instance.incrementProgress(widget.exercise.id);
    final after = await LocalDb.instance.getProgressForExercise(widget.exercise.id);

    await LocalDb.instance.insertSession(
      PracticeSession(exerciseTitle: widget.exercise.title, date: DateTime.now()),
    );

    final previousRank = before?.rank;
    final newRank = after!.rank;

    setState(() {
      _newRank = newRank;
      _rankedUp = previousRank != null && previousRank != newRank;
      _completed = true;
    });

    if (_rankedUp) {
      _badgeController.forward(from: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_completed) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.exercise.title)),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_rankedUp && _newRank != null)
                  ScaleTransition(
                    scale: _badgeScale,
                    child: Column(
                      children: [
                        Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppStyles.rankColor(_newRank!),
                          ),
                          child: const Icon(Icons.emoji_events, color: Colors.white, size: 42),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '¡Subiste a ${_newRank!.label}!',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: AppStyles.rankColor(_newRank!),
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                  )
                else
                  Icon(
                    Icons.check_circle,
                    size: 80,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                const SizedBox(height: 16),
                if (!_rankedUp)
                  Text(
                    '¡Completado!',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                const SizedBox(height: 8),
                Text(
                  'Practicaste "${widget.exercise.title}".',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Volver'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(widget.exercise.title)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.exercise.description,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Pasos',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 10),
                    for (int i = 0; i < widget.exercise.steps.length; i++)
                      StepCard(number: i + 1, text: widget.exercise.steps[i]),
                    if (widget.exercise.id == 'ritmo_controlado') ...[
                      const SizedBox(height: 16),
                      const MetronomeWidget(),
                    ],
                    const SizedBox(height: 20),
                    Text(
                      'Repeticiones',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 10),
                    RepetitionTracker(
                      onAllCompleted: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('¡Repeticiones completadas!')),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Grabación',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 10),
                    RecorderWidget(
                      exerciseId: widget.exercise.id,
                      exerciseTitle: widget.exercise.title,
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _markCompleted,
                child: const Text('Completado'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}