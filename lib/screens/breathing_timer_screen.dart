import 'dart:async';
import 'package:flutter/material.dart';
import '../data/local_db.dart';
import '../models/exercise.dart';
import '../theme/app_styles.dart';
import '../widgets/step_card.dart';

class BreathingTimerScreen extends StatefulWidget {
  final Exercise exercise;

  const BreathingTimerScreen({super.key, required this.exercise});

  @override
  State<BreathingTimerScreen> createState() => _BreathingTimerScreenState();
}

class _BreathingTimerScreenState extends State<BreathingTimerScreen>
    with SingleTickerProviderStateMixin {
  static const List<int> _durationOptions = [2, 3, 5, 7, 10];

  int? _selectedMinutes;
  bool _running = false;
  bool _paused = false;
  bool _completed = false;
  int _secondsRemaining = 0;
  Timer? _countdownTimer;

  final ExpansibleController _stepsController = ExpansibleController();

  late final AnimationController _breathController;
  late final BreathingPattern _pattern;

  ExerciseRank? _newRank;
  bool _rankedUp = false;

  @override
  void initState() {
    super.initState();
    _pattern = widget.exercise.breathingPattern ??
        const BreathingPattern(inhaleSeconds: 4, exhaleSeconds: 6);
    _breathController = AnimationController(
      vsync: this,
      duration: Duration(seconds: _pattern.totalSeconds),
    );
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _breathController.dispose();
    super.dispose();
  }

  void _collapseStepsIfNeeded() {
    if (_stepsController.isExpanded) {
      _stepsController.collapse();
    }
  }

  void _selectDuration(int minutes) {
    setState(() => _selectedMinutes = minutes);
    _collapseStepsIfNeeded();
  }

  void _startSession(int minutes) {
    setState(() {
      _selectedMinutes = minutes;
      _secondsRemaining = minutes * 60;
      _running = true;
    });
    _breathController.repeat();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_secondsRemaining <= 1) {
        _finishSession();
      } else {
        setState(() {
          _secondsRemaining--;
        });
      }
    });
  }

  void _togglePause() {
    setState(() {
      _paused = !_paused;
    });
    if (_paused) {
      _countdownTimer?.cancel();
      _breathController.stop();
    } else {
      _breathController.repeat();
      _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (_secondsRemaining <= 1) {
          _finishSession();
        } else {
          setState(() {
            _secondsRemaining--;
          });
        }
      });
    }
  }

  Future<void> _finishSession() async {
    _countdownTimer?.cancel();
    _breathController.stop();

    final before = await LocalDb.instance.getProgressForExercise(widget.exercise.id);
    await LocalDb.instance.incrementProgress(widget.exercise.id);
    final after = await LocalDb.instance.getProgressForExercise(widget.exercise.id);
    await LocalDb.instance.insertSession(
      PracticeSession(exerciseTitle: widget.exercise.title, date: DateTime.now()),
    );

    final previousRank = before?.rank;
    final newRank = after!.rank;

    setState(() {
      _running = false;
      _completed = true;
      _newRank = newRank;
      _rankedUp = previousRank != null && previousRank != newRank;
    });
  }

  String _phaseLabel(double t) {
    final inhaleFraction = _pattern.inhaleSeconds / _pattern.totalSeconds;
    final holdFraction = _pattern.holdSeconds / _pattern.totalSeconds;
    if (t < inhaleFraction) return 'Inhala';
    if (t < inhaleFraction + holdFraction) return 'Sostén';
    return 'Exhala';
  }

  double _phaseScale(double t) {
    final inhaleFraction = _pattern.inhaleSeconds / _pattern.totalSeconds;
    final holdFraction = _pattern.holdSeconds / _pattern.totalSeconds;
    const minScale = 0.75;
    const maxScale = 1.2;
    if (t < inhaleFraction) {
      final localT = t / inhaleFraction;
      return minScale + (maxScale - minScale) * localT;
    }
    if (t < inhaleFraction + holdFraction) {
      return maxScale;
    }
    final exhaleFraction = 1 - inhaleFraction - holdFraction;
    final localT = (t - inhaleFraction - holdFraction) / exhaleFraction;
    return maxScale - (maxScale - minScale) * localT;
  }

  String _formatTime(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
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

  @override
  Widget build(BuildContext context) {
    if (_completed) {
      final totalSeconds = (_selectedMinutes ?? 0) * 60;
      return Scaffold(
        appBar: AppBar(title: Text(widget.exercise.title)),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _rankedUp ? Icons.emoji_events : Icons.check_circle,
                  size: 80,
                  color: _rankedUp && _newRank != null
                      ? AppStyles.rankColor(_newRank!)
                      : Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 16),
                Text(
                  _rankedUp && _newRank != null
                      ? '¡Subiste a ${_newRank!.label}!'
                      : '¡Completado!',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  'Practicaste "${widget.exercise.title}" durante ${_formatTime(totalSeconds)}.',
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

    if (!_running) {
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
                      const SizedBox(height: 20),
                      _sectionHeader(Icons.timer_outlined, 'Elige cuánto quieres practicar'),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        children: _durationOptions.map((min) {
                          return ChoiceChip(
                            label: Text('$min min'),
                            selected: _selectedMinutes == min,
                            onSelected: (_) => _selectDuration(min),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _selectedMinutes == null
                      ? null
                      : () => _startSession(_selectedMinutes!),
                  child: const Text('Comenzar'),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final totalSeconds = (_selectedMinutes ?? 1) * 60;
    final elapsedSeconds = totalSeconds - _secondsRemaining;

    return Scaffold(
      appBar: AppBar(title: Text(widget.exercise.title)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Card(
              elevation: 0,
              color: Theme.of(context).colorScheme.surfaceContainerLow,
              shape: AppStyles.cardShape(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.timer_outlined,
                              size: 18,
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 6),
                            Text(_formatTime(elapsedSeconds), style: Theme.of(context).textTheme.labelLarge),
                          ],
                        ),
                        Text(
                          'de $_selectedMinutes:00',
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: totalSeconds == 0 ? 0 : elapsedSeconds / totalSeconds,
                        minHeight: 6,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            AnimatedBuilder(
              animation: _breathController,
              builder: (context, child) {
                final t = _breathController.value;
                final scale = _phaseScale(t);
                return Column(
                  children: [
                    Transform.scale(
                      scale: scale,
                      child: Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                          border: Border.all(
                            color: Theme.of(context).colorScheme.primary,
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          Icons.air,
                          size: 40,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _phaseLabel(t),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 32),
            Text(
              _formatTime(_secondsRemaining),
              style: Theme.of(context).textTheme.displaySmall,
            ),
            Text(
              'restantes',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _togglePause,
                icon: Icon(_paused ? Icons.play_arrow : Icons.pause),
                label: Text(_paused ? 'Reanudar' : 'Pausar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}