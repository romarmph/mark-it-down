import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../models/notebooks.dart';

class NotebooksDBHelper {
  NotebooksDBHelper._dbConst();

  static final NotebooksDBHelper instance = NotebooksDBHelper._dbConst();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory dbDirectory = await getApplicationDocumentsDirectory();
    String path = join(dbDirectory.path, 'mark_id_down.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    const String sql = '''
CREATE TABLE tbl_notebooks(
  id INTEGER PRIMARY KEY,
  notebook TEXT
)
''';

    await db.execute(sql);
  }

  Future<List<Notebook>> getNotebooks() async {
    Database db = await instance.database;

    var notebooks = await db.query('tbl_notebooks', orderBy: 'id');
    List<Notebook> notebookList = notebooks.isNotEmpty
        ? notebooks.map((notebook) => Notebook.fromMap(notebook)).toList()
        : [];

    return notebookList;
  }

  Future<int> add(Notebook notebook) async {
    Database db = await instance.database;
    return await db.insert(
      'tbl_notebooks',
      notebook.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> update(Notebook notebook) async {
    Database db = await instance.database;

    return await db.update(
      'tbl_notebooks',
      notebook.toMap(),
      where: 'id = ?',
      whereArgs: [notebook.id],
    );
  }

  Future<int> remove(int id) async {
    Database db = await instance.database;

    return await db.delete(
      'tbl_notebooks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Future<void> deleteAll() async {
  //   Database db = await instance.database;

  //   await db.execute('DELETE FROM tbl_notebooks WHERE 1');
  // }
}
