import '../models/exercise.dart';

final List<Exercise> exercises = [
  const Exercise(
    id: 'respiracion_diafragmatica',
    title: 'Respiración diafragmática',
    category: ExerciseCategory.respiracion,
    description: 'Aprende a respirar desde el diafragma para dar soporte constante a tu voz.',
    steps: [
      'Siéntate o acuéstate cómodamente, con una mano en el pecho y otra en el abdomen.',
      'Inhala por la nariz durante 4 segundos, sintiendo cómo se expande el abdomen (no el pecho).',
      'Sostén el aire 2 segundos.',
      'Exhala lentamente por la boca durante 6 segundos.',
      'Repite el ciclo 8 a 10 veces, sin forzar.',
    ],
    difficulty: ExerciseDifficulty.principiante,
    durationMinutes: 5,
    tags: ['respiración', 'relajación', 'base'],
  ),
  const Exercise(
    id: 'inicio_suave',
    title: 'Inicio suave de palabras',
    category: ExerciseCategory.inicioSuave,
    description: 'Practica comenzar palabras con un ataque vocal suave, reduciendo la tensión al iniciar el habla.',
    steps: [
      'Elige 5 palabras que empiecen con vocal (ej: "amigo", "escuela").',
      'Antes de decir cada palabra, deja salir un poco de aire suavemente antes de que empiece el sonido.',
      'Di la palabra alargando un poco la primera sílaba, sin tensión en la garganta.',
      'Repite cada palabra 3 veces, bajando la tensión cada vez.',
      'Cuando te sientas cómodo, intenta lo mismo con frases cortas.',
    ],
    difficulty: ExerciseDifficulty.principiante,
    durationMinutes: 8,
    tags: ['inicio suave', 'tensión', 'vocales'],
  ),
  const Exercise(
    id: 'ritmo_controlado',
    title: 'Habla con ritmo controlado',
    category: ExerciseCategory.ritmo,
    description: 'Hablar despacio y con ritmo ayuda a reducir bloqueos.',
    steps: [
      'Di una palabra por cada segundo, contando mentalmente.',
      'Cuando te sientas cómodo, arma frases cortas.',
      'Sube la velocidad poco a poco en sesiones futuras.',
    ],
    difficulty: ExerciseDifficulty.intermedio,
    durationMinutes: 10,
    tags: ['ritmo', 'metrónomo', 'frases'],
  ),
  const Exercise(
    id: 'lectura_guiada',
    title: 'Lectura en voz alta guiada',
    category: ExerciseCategory.lectura,
    description: 'Lee un texto corto aplicando respiración e inicio suave.',
    steps: [
      'Elige un párrafo corto de un libro o noticia.',
      'Haz 3 respiraciones diafragmáticas antes de empezar.',
      'Lee en voz alta, sin detenerte si hay un bloqueo.',
    ],
    difficulty: ExerciseDifficulty.avanzado,
    durationMinutes: 12,
    tags: ['lectura', 'integración', 'texto largo'],
  ),
];