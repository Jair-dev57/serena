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
    final path = join(dbPath, 'serena.db');
    return openDatabase(
      path,
      version: 6,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE recordings (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            exerciseId TEXT NOT NULL,
            path TEXT NOT NULL,
            dateTime TEXT NOT NULL
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 6) {
          await db.execute('''
            CREATE TABLE recordings (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              exerciseId TEXT NOT NULL,
              path TEXT NOT NULL,
              dateTime TEXT NOT NULL
            )
          ''');
        }
      },
    );
  }

  Future<void> insertRecording(Recording recording) async {
    final db = await database;
    await db.insert('recordings', recording.toMap()..remove('id'));
  }

  Future<List<Recording>> getRecordingsForExercise(String exerciseId) async {
    final db = await database;
    final maps = await db.query(
      'recordings',
      where: 'exerciseId = ?',
      whereArgs: [exerciseId],
      orderBy: 'dateTime DESC',
    );
    return maps.map((m) => Recording.fromMap(m)).toList();
  }
}