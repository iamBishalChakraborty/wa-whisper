import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/chat_log.dart';

class DatabaseService {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'chat_logs.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE chat_logs(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            phoneNumber TEXT NOT NULL,
            message TEXT,
            timestamp TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<void> saveLog(ChatLog log) async {
    final db = await database;
    await db.insert(
      'chat_logs',
      {
        'phoneNumber': log.phoneNumber,
        'message': log.message,
        'timestamp': log.timestamp.toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<ChatLog>> getLogs() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'chat_logs',
      orderBy: 'timestamp DESC',
    );

    return List.generate(maps.length, (i) {
      return ChatLog(
        phoneNumber: maps[i]['phoneNumber'],
        message: maps[i]['message'],
        timestamp: DateTime.parse(maps[i]['timestamp']),
      );
    });
  }
}