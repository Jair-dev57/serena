import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/exercise.dart';

class LocalDb {
  LocalDb._internal();
  static final LocalDb instance = LocalDb._internal();
  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'fluidez_app.db');
    return openDatabase(
      path,
      version: 5,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE practice_sessions (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            exerciseTitle TEXT NOT NULL,
            date TEXT NOT NULL
          )
        ''');
        await db.execute('''
          CREATE TABLE difficult_words (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            word TEXT NOT NULL,
            dateAdded TEXT NOT NULL,
            note TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE block_entries (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            dateTime TEXT NOT NULL,
            severity TEXT NOT NULL,
            context TEXT NOT NULL,
            note TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE exercise_progress (
            exerciseId TEXT PRIMARY KEY,
            timesCompleted INTEGER NOT NULL,
            lastCompletedAt TEXT
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('''
            CREATE TABLE difficult_words (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              word TEXT NOT NULL,
              dateAdded TEXT NOT NULL
            )
          ''');
        }
        if (oldVersion < 3) {
          await db.execute('ALTER TABLE difficult_words ADD COLUMN note TEXT');
        }
        if (oldVersion < 4) {
          await db.execute('''
            CREATE TABLE block_entries (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              dateTime TEXT NOT NULL,
              severity TEXT NOT NULL,
              context TEXT NOT NULL,
              note TEXT
            )
          ''');
        }
        if (oldVersion < 5) {
          await db.execute('''
            CREATE TABLE exercise_progress (
              exerciseId TEXT PRIMARY KEY,
              timesCompleted INTEGER NOT NULL,
              lastCompletedAt TEXT
            )
          ''');
        }
      },
    );
  }

  Future<void> insertSession(PracticeSession session) async {
    final db = await database;
    await db.insert('practice_sessions', session.toMap()..remove('id'));
  }

  Future<List<PracticeSession>> getAllSessions() async {
    final db = await database;
    final maps = await db.query('practice_sessions', orderBy: 'date DESC');
    return maps.map((m) => PracticeSession.fromMap(m)).toList();
  }

  Future<int> getCurrentStreak() async {
    final sessions = await getAllSessions();
    if (sessions.isEmpty) return 0;
    final days = sessions
        .map((s) => DateTime(s.date.year, s.date.month, s.date.day))
        .toSet();
    int streak = 0;
    DateTime cursor = DateTime.now();
    cursor = DateTime(cursor.year, cursor.month, cursor.day);
    while (days.contains(cursor)) {
      streak++;
      cursor = cursor.subtract(const Duration(days: 1));
    }
    return streak;
  }

  Future<void> insertWord(DifficultWord word) async {
    final db = await database;
    await db.insert('difficult_words', word.toMap()..remove('id'));
  }

  Future<List<DifficultWord>> getAllWords() async {
    final db = await database;
    final maps = await db.query('difficult_words', orderBy: 'dateAdded DESC');
    return maps.map((m) => DifficultWord.fromMap(m)).toList();
  }

  Future<void> deleteWord(int id) async {
    final db = await database;
    await db.delete('difficult_words', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> updateWord(DifficultWord word) async {
    final db = await database;
    await db.update(
      'difficult_words',
      word.toMap(),
      where: 'id = ?',
      whereArgs: [word.id],
    );
  }

  Future<void> insertBlockEntry(BlockEntry entry) async {
    final db = await database;
    await db.insert('block_entries', entry.toMap()..remove('id'));
  }

  Future<List<BlockEntry>> getAllBlockEntries() async {
    final db = await database;
    final maps = await db.query('block_entries', orderBy: 'dateTime DESC');
    return maps.map((m) => BlockEntry.fromMap(m)).toList();
  }

  Future<void> updateBlockEntry(BlockEntry entry) async {
    final db = await database;
    await db.update(
      'block_entries',
      entry.toMap(),
      where: 'id = ?',
      whereArgs: [entry.id],
    );
  }

  Future<void> deleteBlockEntry(int id) async {
    final db = await database;
    await db.delete('block_entries', where: 'id = ?', whereArgs: [id]);
  }

  Future<ExerciseProgress?> getProgressForExercise(String exerciseId) async {
    final db = await database;
    final maps = await db.query(
      'exercise_progress',
      where: 'exerciseId = ?',
      whereArgs: [exerciseId],
    );
    if (maps.isEmpty) return null;
    return ExerciseProgress.fromMap(maps.first);
  }

  Future<List<ExerciseProgress>> getAllProgress() async {
    final db = await database;
    final maps = await db.query('exercise_progress');
    return maps.map((m) => ExerciseProgress.fromMap(m)).toList();
  }

  Future<void> incrementProgress(String exerciseId) async {
    final db = await database;
    final existing = await getProgressForExercise(exerciseId);
    if (existing == null) {
      final progress = ExerciseProgress(
        exerciseId: exerciseId,
        timesCompleted: 1,
        lastCompletedAt: DateTime.now(),
      );
      await db.insert('exercise_progress', progress.toMap());
    } else {
      final updated = ExerciseProgress(
        exerciseId: exerciseId,
        timesCompleted: existing.timesCompleted + 1,
        lastCompletedAt: DateTime.now(),
      );
      await db.update(
        'exercise_progress',
        updated.toMap(),
        where: 'exerciseId = ?',
        whereArgs: [exerciseId],
      );
    }
  }
}