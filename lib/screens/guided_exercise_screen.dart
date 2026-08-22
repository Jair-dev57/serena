
import 'package:flutter/material.dart';
import '../data/local_db.dart';
import '../models/exercise.dart';
import '../widgets/recorder_widget.dart';
import '../widgets/metronome_widget.dart';

class GuidedExerciseScreen extends StatefulWidget {
  final Exercise exercise;

  const GuidedExerciseScreen({super.key, required this.exercise});

  @override
  State<GuidedExerciseScreen> createState() => _GuidedExerciseScreenState();
}

class _GuidedExerciseScreenState extends State<GuidedExerciseScreen> {
  int _currentStep = 0;
  bool _completed = false;

  bool get _isLastStep => _currentStep == widget.exercise.steps.length - 1;

  bool get _showsRecorder =>
      widget.exercise.category != ExerciseCategory.respiracion;

  Future<void> _nextStep() async {
    if (!_isLastStep) {
      setState(() {
        _currentStep++;
      });
    } else {
      await LocalDb.instance.incrementProgress(widget.exercise.id);
      setState(() {
        _completed = true;
      });
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
                Icon(
                  Icons.check_circle,
                  size: 80,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 16),
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

    final progress = (_currentStep + 1) / widget.exercise.steps.length;

    return Scaffold(
      appBar: AppBar(title: Text(widget.exercise.title)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Paso ${_currentStep + 1} de ${widget.exercise.steps.length}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    Text(
                      widget.exercise.steps[_currentStep],
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    if (_isLastStep && widget.exercise.id == 'ritmo_controlado') ...[
                      const SizedBox(height: 24),
                      const MetronomeWidget(),
                    ],
                    if (_isLastStep && _showsRecorder) ...[
                      const SizedBox(height: 24),
                      RecorderWidget(exerciseTitle: widget.exercise.title),
                    ],
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _nextStep,
                child: Text(_isLastStep ? 'Terminar' : 'Siguiente'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}