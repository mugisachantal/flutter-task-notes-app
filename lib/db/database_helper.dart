import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../models/task_item.dart';

class DatabaseHelper {
  DatabaseHelper._internal();
  static final DatabaseHelper instance = DatabaseHelper._internal();

  static const _dbName = 'tasks_db.sqlite';
  static const _dbVersion = 1;
  static const _table = 'tasks';

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dir = await getApplicationDocumentsDirectory();
    final path = p.join(dir.path, _dbName);
    return openDatabase(
      path,
      version: _dbVersion,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_table (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            priority TEXT NOT NULL,
            description TEXT NOT NULL,
            isCompleted INTEGER NOT NULL DEFAULT 0
          )
        ''');
      },
    );
  }

  Future<int> insertTask(TaskItem item) async {
    final db = await database;
    return db.insert(_table, {
      ...item.toJson(),
      'isCompleted': item.isCompleted ? 1 : 0,
    });
  }

  Future<List<TaskItem>> getAllTasks() async {
    final db = await database;
    final maps = await db.query(_table, orderBy: 'id DESC');
    return maps.map((m) => TaskItem.fromJson(m)).toList();
  }

  Future<int> deleteTask(int id) async {
    final db = await database;
    return db.delete(_table, where: 'id = ?', whereArgs: [id]);
  }
}
