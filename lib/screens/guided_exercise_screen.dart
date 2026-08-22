import 'dart:async';
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

  int _completedReps = 0;
  bool _hasRecorded = false;
  final ExpansionTileController _stepsController = ExpansionTileController();

  Duration _elapsed = Duration.zero;
  Timer? _sessionTimer;

  late final AnimationController _badgeController;
  late final Animation<double> _badgeScale;

  bool get _canComplete => _completedReps > 0 || _hasRecorded;

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

    _sessionTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _elapsed += const Duration(seconds: 1);
      });
    });
  }

  @override
  void dispose() {
    _badgeController.dispose();
    _sessionTimer?.cancel();
    super.dispose();
  }

  String get _elapsedLabel {
    final minutes = _elapsed.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = _elapsed.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void _collapseStepsIfNeeded() {
    if (_stepsController.isExpanded) {
      _stepsController.collapse();
    }
  }

  Future<void> _markCompleted() async {
    _sessionTimer?.cancel();

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

  Widget _sectionHeader(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 8),
        Text(label, style: Theme.of(context).textTheme.titleMedium),
      ],
    );
  }

  Widget _buildSessionBar() {
    final repsColor = _completedReps > 0
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.onSurfaceVariant;
    final recColor = _hasRecorded
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.onSurfaceVariant;

    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      shape: AppStyles.cardShape(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.timer_outlined, size: 18, color: Theme.of(context).colorScheme.onSurfaceVariant),
                const SizedBox(width: 6),
                Text(_elapsedLabel, style: Theme.of(context).textTheme.labelLarge),
                if (widget.exercise.durationMinutes > 0) ...[
                  const SizedBox(width: 6),
                  Text(
                    '· ~${widget.exercise.durationMinutes} min',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ],
            ),
            Row(
              children: [
                Icon(
                  _completedReps > 0 ? Icons.check_circle : Icons.circle_outlined,
                  size: 18,
                  color: repsColor,
                ),
                const SizedBox(width: 4),
                Text('Rep.', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: repsColor)),
                const SizedBox(width: 12),
                Icon(
                  _hasRecorded ? Icons.check_circle : Icons.circle_outlined,
                  size: 18,
                  color: recColor,
                ),
                const SizedBox(width: 4),
                Text('Grab.', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: recColor)),
              ],
            ),
          ],
        ),
      ),
    );
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
                  'Practicaste "${widget.exercise.title}" durante $_elapsedLabel.',
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
            _buildSessionBar(),
            const SizedBox(height: 16),
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
                    Theme(
                      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        controller: _stepsController,
                        initiallyExpanded: true,
                        tilePadding: EdgeInsets.zero,
                        childrenPadding: const EdgeInsets.only(top: 4),
                        title: Row(
                          children: [
                            Icon(Icons.list_alt, size: 20, color: Theme.of(context).colorScheme.primary),
                            const SizedBox(width: 8),
                            Text('Pasos', style: Theme.of(context).textTheme.titleMedium),
                          ],
                        ),
                        children: [
                          for (int i = 0; i < widget.exercise.steps.length; i++)
                            StepCard(number: i + 1, text: widget.exercise.steps[i]),
                        ],
                      ),
                    ),
                    if (widget.exercise.id == 'ritmo_controlado') ...[
                      const SizedBox(height: 16),
                      _sectionHeader(Icons.music_note, 'Ritmo'),
                      const SizedBox(height: 10),
                      MetronomeWidget(
                        onStarted: _collapseStepsIfNeeded,
                      ),
                    ],
                    const SizedBox(height: 20),
                    _sectionHeader(Icons.repeat, 'Repeticiones'),
                    const SizedBox(height: 10),
                    RepetitionTracker(
                      onProgress: (completed) {
                        setState(() {
                          _completedReps = completed;
                        });
                        if (completed == 1) {
                          _collapseStepsIfNeeded();
                        }
                      },
                      onAllCompleted: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('¡Repeticiones completadas!')),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    _sectionHeader(Icons.mic, 'Grabación'),
                    const SizedBox(height: 10),
                    RecorderWidget(
                      exerciseId: widget.exercise.id,
                      exerciseTitle: widget.exercise.title,
                      onRecordingStarted: _collapseStepsIfNeeded,
                      onRecorded: () {
                        setState(() {
                          _hasRecorded = true;
                        });
                      },
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            if (!_canComplete)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  'Completá al menos una repetición o grabá tu voz para continuar.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _canComplete ? _markCompleted : null,
                child: const Text('Completado'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}