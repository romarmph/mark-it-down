import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../models/note.dart';

class NotesDBHelper {
  NotesDBHelper._dbConst();

  static final NotesDBHelper instance = NotesDBHelper._dbConst();

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

  Future<void> _onCreate(Database db, int version) async {
    const String notes = '''
CREATE TABLE tbl_notes(
  id INTEGER PRIMARY KEY,
  notebookID INTEGER,
  notebookName TEXT,
  title TEXT,
  content TEX,
  date TEXT
)
''';

    await db.execute(notes);
  }

  Future<List<Note>> getNotes(int id, String searchText) async {
    Database db = await instance.database;

    var notes = [];

    if (id == 0 && searchText.isEmpty) {
      notes = await db.query('tbl_notes', orderBy: 'id');
    } else if (searchText.isNotEmpty && id == 0) {
      notes = await db.rawQuery(
        'SELECT * FROM tbl_notes WHERE title LIKE ? OR content LIKE ? OR notebookName LIKE ?',
        ['%$searchText%', '%$searchText%', '%$searchText%'],
      );
    } else {
      notes = await db.query(
        'tbl_notes',
        orderBy: 'id',
        where: 'notebookID = ?',
        whereArgs: [id],
      );
    }
    List<Note> notesList = notes.isNotEmpty
        ? notes.map((note) => Note.fromMap(note)).toList()
        : [];

    return notesList;
  }

  Future<int> updateNotebookID(int id) async {
    Database db = await instance.database;

    return await db.update(
      'tbl_notes',
      {
        'notebookID': 0,
      },
      where: 'notebookID = ?',
      whereArgs: [id],
    );
  }

  Future<Note> getSingleNote(int id) async {
    Database db = await instance.database;

    var notes = await db.query(
      'tbl_notes',
      where: 'id = ?',
      whereArgs: [id],
    );
    List<Note> notesList = notes.isNotEmpty
        ? notes.map((note) => Note.fromMap(note)).toList()
        : [];

    return notesList[0];
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
}
