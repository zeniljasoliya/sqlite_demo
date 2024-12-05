import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqlite_demo/user.model.dart';

class LocalDatabase {
  static const String _userDb = 'user.db';
  static const String _userMst = 'user_mst';
  static Future<Database> get openDb async {
    return await openDatabase(
      join(await getDatabasesPath(), _userDb),
      version: 1,
      onCreate: (db, version) => db.execute(
          'CREATE TABLE $_userMst (id INTEGER PRIMARY KEY,username TEXT NOT NULL)'),
    );
  }

  static insertData(UserData username) async {
    final db = await openDb;
    db.insert(_userMst, username.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<UserData>> selectData() async {
    final db = await openDb;
    List<Map<String, dynamic>> data = await db.query(_userMst);
    // log('$data');
    return List.generate(data.length, (index) => UserData.fromMap(data[index]));
  }

  static Future<void> updateData(UserData username) async {
    final db = await openDb;
    db.update(
      _userMst,
      username.toMap(),
      where: 'id=?',
      whereArgs: [username.id],
    );
  }

  static Future<void> deletData(int id) async {
    final db = await openDb;
    db.delete(
      _userMst,
      where: 'id=?',
      whereArgs: [id],
    );
  }
}
