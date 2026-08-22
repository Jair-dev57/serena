import 'package:shared_preferences/shared_preferences.dart';

class FavoritesManager {
  static const _key = 'favoriteExerciseIds';

  static Future<Set<String>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key) ?? [];
    return list.toSet();
  }

  static Future<void> toggleFavorite(String exerciseId) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_key) ?? [];
    if (favorites.contains(exerciseId)) {
      favorites.remove(exerciseId);
    } else {
      favorites.add(exerciseId);
    }
    await prefs.setStringList(_key, favorites);
  }

  static Future<bool> isFavorite(String exerciseId) async {
    final favorites = await getFavorites();
    return favorites.contains(exerciseId);
  }
}