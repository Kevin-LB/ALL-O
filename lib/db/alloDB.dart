import 'package:allo/models/categorie.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// ignore: camel_case_types
class allDB {
  static Future<Database> createDB() async {
    return openDatabase(
      join(await getDatabasesPath(), 'allo_database.db'),
      onCreate: (db, version) {
        return db.execute(
            "CREATE TABLE categorie(id INTEGER PRIMARY KEY, name TEXT)");
      },
      version: 1,
    );
  }

  static Future<void> insertCategorie(Categorie categorie) async {
    final Database db = await createDB();
    await db.insert(
      'categorie',
      categorie.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  
}
