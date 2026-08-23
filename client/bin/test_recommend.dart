import 'package:serena_poc_client/serena_poc_client.dart';

Future<void> main() async {
  final client = Client('http://localhost:8080/');

  try {
    final result = await client.recommend.recommend(
      [
        ExerciseInfo(
          id: 'resp_1',
          title: 'Respiración diafragmática',
          category: 'respiracion',
          difficulty: 'principiante',
        ),
        ExerciseInfo(
          id: 'ritmo_controlado',
          title: 'Habla con ritmo controlado',
          category: 'ritmo',
          difficulty: 'principiante',
        ),
      ],
      [
        ProgressInfo(exerciseId: 'resp_1', timesCompleted: 3),
      ],
      [
        BlockInfo(severity: 'fuerte', context: 'llamada', daysAgo: 1),
      ],
      [],
      4,
      2,
      3,
    );

    print('Recomendado: ${result.recommendedExerciseId}');
    print('Razón: ${result.reason}');
  } catch (e) {
    print('Error al llamar al endpoint: $e');
  } finally {
    client.close();
  }
}
