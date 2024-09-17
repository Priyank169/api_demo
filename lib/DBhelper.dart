import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _database;

  static Future<Database> getDatabase() async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'dog_images.db');

    return await openDatabase(
      path,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE dogs(id INTEGER PRIMARY KEY AUTOINCREMENT, url TEXT)',
        );
      },
      version: 1,
    );
  }

  static Future<void> insertDog(String url) async {
    final db = await getDatabase();
    await db.insert(
      'dogs',
      {'url': url},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<String>> getDogs() async {
    final db = await getDatabase();
    final List<Map<String, dynamic>> maps = await db.query('dogs');
    return List.generate(maps.length, (i) => maps[i]['url'] as String);
  }
}
