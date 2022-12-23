import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../models/notebooks.dart';
import '../models/note.dart';

class DatabaseHelper {
  DatabaseHelper._dbConst();

  static final DatabaseHelper instance = DatabaseHelper._dbConst();

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
    const String notebook = '''
CREATE TABLE tbl_notebooks(
  id INTEGER PRIMARY KEY,
  notebook TEXT
)
''';

    const String notes = '''
CREATE TABLE tbl_notes(
  id INTEGER PRIMARY KEY,
  notebookID INTEGER,
  title TEXT,
  content TEX,
  date TEXT
)
''';

    await db.execute(notebook);
    await db.execute(notes);
  }

  Future<List<Notebook>> getNotebooks() async {
    Database db = await instance.database;

    var notebooks = await db.query('tbl_notebooks', orderBy: 'id');
    List<Notebook> notebookList = notebooks.isNotEmpty
        ? notebooks.map((notebook) => Notebook.fromMap(notebook)).toList()
        : [];

    return notebookList;
  }

  Future<int> createNotebook(Notebook notebook) async {
    Database db = await instance.database;
    return await db.insert(
      'tbl_notebooks',
      notebook.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> updateNotebook(Notebook notebook) async {
    Database db = await instance.database;

    return await db.update(
      'tbl_notebooks',
      notebook.toMap(),
      where: 'id = ?',
      whereArgs: [notebook.id],
    );
  }

  Future<int> deleteNotebook(int id) async {
    Database db = await instance.database;

    return await db.delete(
      'tbl_notebooks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  //

  Future<List<Note>> getNotes() async {
    Database db = await instance.database;

    var notes = await db.query('tbl_notes', orderBy: 'id');
    List<Note> notesList = notes.isNotEmpty
        ? notes.map((note) => Note.fromMap(note)).toList()
        : [];

    return notesList;
  }

  Future<int> createNote(Note note) async {
    Database db = await instance.database;
    return await db.insert(
      'tbl_notes',
      note.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> updateNote(Note note) async {
    Database db = await instance.database;

    return await db.update(
      'tbl_notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> deleteNote(int id) async {
    Database db = await instance.database;

    return await db.delete(
      'tbl_notes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    Database db = await instance.database;

    db.close();
  }
}
