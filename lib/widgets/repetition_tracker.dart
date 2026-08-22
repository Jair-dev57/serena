import 'dart:async';
import 'package:flutter/material.dart';

class RepetitionTracker extends StatefulWidget {
  final VoidCallback? onAllCompleted;

  const RepetitionTracker({super.key, this.onAllCompleted});

  @override
  State<RepetitionTracker> createState() => _RepetitionTrackerState();
}

class _RepetitionTrackerState extends State<RepetitionTracker> {
  int? _targetReps;
  int _completedReps = 0;
  bool _inPause = false;
  int _pauseSecondsLeft = 0;
  Timer? _pauseTimer;

  static const List<int> _repOptions = [1, 2, 3, 4, 5];
  static const int _pauseDuration = 5;

  @override
  void dispose() {
    _pauseTimer?.cancel();
    super.dispose();
  }

  void _markRepetition() {
    if (_targetReps == null || _inPause) return;

    setState(() {
      _completedReps++;
    });

    if (_completedReps >= _targetReps!) {
      widget.onAllCompleted?.call();
      return;
    }

    setState(() {
      _inPause = true;
      _pauseSecondsLeft = _pauseDuration;
    });

    _pauseTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_pauseSecondsLeft <= 1) {
        timer.cancel();
        setState(() {
          _inPause = false;
        });
      } else {
        setState(() {
          _pauseSecondsLeft--;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_targetReps == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '¿Cuántas repeticiones quieres hacer?',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: _repOptions.map((n) {
              return ChoiceChip(
                label: Text('$n'),
                selected: false,
                onSelected: (_) => setState(() => _targetReps = n),
              );
            }).toList(),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_targetReps!, (index) {
            final done = index < _completedReps;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Icon(
                done ? Icons.check_circle : Icons.circle_outlined,
                color: done
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.outlineVariant,
                size: 28,
              ),
            );
          }),
        ),
        const SizedBox(height: 12),
        if (_inPause)
          Column(
            children: [
              Text(
                'Descansa...',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              Text(
                '$_pauseSecondsLeft s',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          )
        else
          OutlinedButton(
            onPressed: _markRepetition,
            child: Text('Marcar repetición ${_completedReps + 1} de $_targetReps'),
          ),
      ],
    );
  }
}