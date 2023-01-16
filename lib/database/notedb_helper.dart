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
  title TEXT,
  content TEX,
  date TEXT
)
''';

    await db.execute(notes);
  }

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
}
