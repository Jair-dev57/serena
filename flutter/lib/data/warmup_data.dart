import '../models/exercise.dart';

final List<WarmupStep> warmupSteps = [
  const WarmupStep(
    title: 'Relajación cervical',
    instruction: 'Movimientos lentos de cuello y hombros mientras inhalás y exhalás.',
    durationSeconds: 45,
    type: WarmupStepType.cervical,
  ),
  const WarmupStep(
    title: 'Vibración de labios (trompetilla)',
    instruction: 'Hacé sonar los labios mientras sacás aire con un tono continuo.',
    durationSeconds: 45,
    type: WarmupStepType.lipTrill,
  ),
  const WarmupStep(
    title: 'Sonido Mmm (humming)',
    instruction: 'Creá resonancia en la zona nasal y labios con la boca cerrada.',
    durationSeconds: 45,
    type: WarmupStepType.humming,
  ),
  const WarmupStep(
    title: 'Inicios suaves (easy onset)',
    instruction: 'Emití vocales suaves, empezando casi desde un suspiro.',
    durationSeconds: 45,
    type: WarmupStepType.easyOnset,
  ),
];

int get warmupTotalSeconds => warmupSteps.fold(0, (sum, step) => sum + step.durationSeconds);