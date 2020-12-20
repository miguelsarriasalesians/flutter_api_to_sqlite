import 'dart:io';

import 'package:api_to_sqlite_flutter/src/models/programmer_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  static Database _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get database async {
    // If database exists, return database
    if (_database != null) return _database;

    // If database don't exists, create one
    _database = await initDB();

    return _database;
  }

  // Create the database and the Programmer table
  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'programmer.db');

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE programmers('
          'id INTEGER PRIMARY KEY,'
          'email TEXT,'
          'firstName TEXT,'
          'lastName TEXT,'
          'technologies TEXT'
          'yearsExperience INTEGER'
          ')');
    });
  }

  // Insert employee on database
  createProgrammer(Programmer newProgrammer) async {
    await deleteAllProgrammers();
    final db = await database;
    final res = await db.insert('programmers', newProgrammer.toJson());

    return res;
  }

  // Delete all employees
  Future<int> deleteAllProgrammers() async {
    final db = await database;
    final res = await db.rawDelete('DELETE FROM programmers');

    return res;
  }

  Future<List<Programmer>> getAllProgrammers() async {
    final db = await database;
    final res = await db.rawQuery("SELECT * FROM programmers");

    List<Programmer> list =
        res.isNotEmpty ? res.map((c) => Programmer.fromJson(c)).toList() : [];

    return list;
  }
}
