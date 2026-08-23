import 'local_db.dart';
import '../models/exercise.dart';

class RecordingManager {
  static Future<void> addRecording(String exerciseId, String path) async {
    await LocalDb.instance.insertRecording(
      Recording(exerciseId: exerciseId, path: path, dateTime: DateTime.now()),
    );
  }

  static Future<List<Recording>> getRecordings(String exerciseId) async {
    return LocalDb.instance.getRecordingsForExercise(exerciseId);
  }
}