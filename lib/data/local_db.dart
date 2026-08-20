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
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE practice_sessions (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            exerciseTitle TEXT NOT NULL,
            date TEXT NOT NULL
          )
        ''');
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
}