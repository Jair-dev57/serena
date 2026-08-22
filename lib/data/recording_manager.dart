import 'package:shared_preferences/shared_preferences.dart';

class RecordingManager {
  static String _keyFor(String exerciseId) => 'recording_$exerciseId';

  static Future<void> saveRecordingPath(String exerciseId, String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyFor(exerciseId), path);
  }

  static Future<String?> getRecordingPath(String exerciseId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyFor(exerciseId));
  }
}