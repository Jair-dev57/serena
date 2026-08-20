import '../models/exercise.dart';

final List<Exercise> exercises = [
  const Exercise(
    title: 'Habla con ritmo controlado',
    category: ExerciseCategory.ritmo,
    description: 'Hablar despacio y con ritmo ayuda a reducir bloqueos.',
    steps: [
      'Di una palabra por cada segundo, contando mentalmente.',
      'Cuando te sientas cómodo, arma frases cortas.',
      'Sube la velocidad poco a poco en sesiones futuras.',
    ],
  ),
  const Exercise(
    title: 'Lectura en voz alta guiada',
    category: ExerciseCategory.lectura,
    description: 'Lee un texto corto aplicando respiración e inicio suave.',
    steps: [
      'Elige un párrafo corto de un libro o noticia.',
      'Haz 3 respiraciones diafragmáticas antes de empezar.',
      'Lee en voz alta, sin detenerte si hay un bloqueo.',
    ],
  ),
];