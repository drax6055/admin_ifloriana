import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  factory DatabaseHelper() {
    return _instance;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'salon_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE salon_owners (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            full_name TEXT,
            salon_name TEXT,
            phone_number TEXT,
            email TEXT,
            address TEXT,
            package_id INTEGER
          )
        ''');
      },
    );
  }

  Future<int> insertSalonOwner(Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert('salon_owners', data, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getSalonOwners() async {
    final db = await database;
    return await db.query('salon_owners');
  }
}
