import 'dart:async';
import 'package:flutter/material.dart';
import '../data/warmup_data.dart';
import '../models/exercise.dart';
import '../theme/app_styles.dart';
import '../data/server_client.dart';
class WarmupScreen extends StatefulWidget {
  const WarmupScreen({super.key});

  @override
  State<WarmupScreen> createState() => _WarmupScreenState();
}

class _WarmupScreenState extends State<WarmupScreen> with SingleTickerProviderStateMixin {
  static const List<String> _easyOnsetVowels = ['Aaa', 'Ooo'];
  static const int _vowelChangeSeconds = 3;

  bool _started = false;
  bool _completed = false;
  int _currentStepIndex = 0;
  int _secondsRemainingInStep = 0;
  int _totalSecondsElapsed = 0;
  Timer? _timer;

  late final AnimationController _loopController;

  WarmupStep get _currentStep => warmupSteps[_currentStepIndex];

  @override
  void initState() {
    super.initState();
    _loopController = AnimationController(vsync: this, duration: const Duration(seconds: 1));
  }

  @override
  void dispose() {
    _timer?.cancel();
    _loopController.dispose();
    super.dispose();
  }

  void _startWarmup() {
    setState(() {
      _started = true;
      _currentStepIndex = 0;
      _secondsRemainingInStep = warmupSteps.first.durationSeconds;
      _totalSecondsElapsed = 0;
    });
    _configureLoopFor(warmupSteps.first.type);
    _tick();
  }

  void _configureLoopFor(WarmupStepType type) {
    switch (type) {
      case WarmupStepType.cervical:
        _loopController.duration = const Duration(milliseconds: 2200);
        break;
      case WarmupStepType.lipTrill:
        _loopController.duration = const Duration(milliseconds: 220);
        break;
      case WarmupStepType.humming:
        _loopController.duration = const Duration(seconds: 10);
        break;
      case WarmupStepType.easyOnset:
        _loopController.duration = const Duration(milliseconds: 1500);
        break;
    }
    _loopController.repeat(reverse: type != WarmupStepType.humming);
  }

  void _tick() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_secondsRemainingInStep <= 1) {
        _advanceStep();
      } else {
        setState(() {
          _secondsRemainingInStep--;
          _totalSecondsElapsed++;
        });
      }
    });
  }

  Future<void> _advanceStep() async {
    if (_currentStepIndex >= warmupSteps.length - 1) {
      await _finishWarmup();
      return;
    }
    setState(() {
      _currentStepIndex++;
      _secondsRemainingInStep = _currentStep.durationSeconds;
      _totalSecondsElapsed++;
    });
    _configureLoopFor(_currentStep.type);
  }

  Future<void> _finishWarmup() async {
    _timer?.cancel();
    _loopController.stop();
    await ServerClient.instance.practiceSession.insertSession(
      'Calentamiento previo',
      DateTime.now(),
    );
    setState(() {
      _completed = true;
    });
  }

  String _formatTime(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  Widget _buildVisual(WarmupStep step, int secondsElapsedInStep) {
    switch (step.type) {
      case WarmupStepType.cervical:
        return AnimatedBuilder(
          animation: _loopController,
          builder: (context, child) {
            final angle = (_loopController.value - 0.5) * 0.5;
            return Transform.rotate(
              angle: angle,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.primaryContainer,
                ),
                child: Icon(
                  Icons.self_improvement,
                  size: 56,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
            );
          },
        );
      case WarmupStepType.lipTrill:
        return AnimatedBuilder(
          animation: _loopController,
          builder: (context, child) {
            final scale = 0.9 + (_loopController.value * 0.25);
            return Transform.scale(
              scale: scale,
              child: Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                  border: Border.all(color: Theme.of(context).colorScheme.primary, width: 2),
                ),
                child: Icon(
                  Icons.graphic_eq,
                  size: 48,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            );
          },
        );
      case WarmupStepType.humming:
        return AnimatedBuilder(
          animation: _loopController,
          builder: (context, child) {
            final t = _loopController.value;
            final inhaling = t < 0.4;
            final scale = inhaling ? 0.8 + (t / 0.4) * 0.4 : 1.2 - ((t - 0.4) / 0.6) * 0.4;
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Transform.scale(
                  scale: scale,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.primaryContainer,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  inhaling ? 'Inhala' : 'Exhala',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            );
          },
        );
      case WarmupStepType.easyOnset:
        final vowelIndex = (secondsElapsedInStep ~/ _vowelChangeSeconds) % _easyOnsetVowels.length;
        final vowel = _easyOnsetVowels[vowelIndex];
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Text(
            vowel,
            key: ValueKey(vowel),
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 72,
                ),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_completed) {
      return Scaffold(
        appBar: AppBar(title: const Text('Calentamiento')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle, size: 80, color: Theme.of(context).colorScheme.primary),
                const SizedBox(height: 16),
                Text('¡Listo para hablar!', style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 8),
                Text(
                  'Completaste el calentamiento previo.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Volver'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (!_started) {
      return Scaffold(
        appBar: AppBar(title: const Text('Calentamiento')),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Una rutina corta de ${_formatTime(warmupTotalSeconds)} para preparar tu voz '
                'antes de una situación difícil (una llamada, una presentación, etc.).',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.separated(
                  itemCount: warmupSteps.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final step = warmupSteps[index];
                    return Card(
                      elevation: 0,
                      color: Theme.of(context).colorScheme.surfaceContainerLow,
                      shape: AppStyles.cardShape(),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                          child: Text('${index + 1}'),
                        ),
                        title: Text(step.title),
                        subtitle: Text(step.instruction),
                        trailing: Text('${step.durationSeconds}s'),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _startWarmup,
                  child: const Text('Comenzar'),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final secondsElapsedInStep = _currentStep.durationSeconds - _secondsRemainingInStep;

    return Scaffold(
      appBar: AppBar(title: const Text('Calentamiento')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: _totalSecondsElapsed / warmupTotalSeconds,
                minHeight: 8,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Paso ${_currentStepIndex + 1} de ${warmupSteps.length}',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const Spacer(),
            Text(
              _currentStep.title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              _currentStep.instruction,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 32),
            _buildVisual(_currentStep, secondsElapsedInStep),
            const Spacer(),
            Text(
              _formatTime(_secondsRemainingInStep),
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}