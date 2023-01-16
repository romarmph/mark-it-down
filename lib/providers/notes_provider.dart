import 'package:flutter/material.dart';

import '../database/notedb_helper.dart';
import '../models/note.dart';

class NotesProvider extends ChangeNotifier {
  List<Note> _noteList = [];

  Future<List<Note>> get noteList async {
    _noteList = await NotesDBHelper.instance.getNotes();
    notifyListeners();
    return _noteList;
  }

  Future<Note> getNote(int id) async {
    return await NotesDBHelper.instance.getSingleNote(id);
  }

  void addNote(Note note) async {
    await NotesDBHelper.instance.createNote(note);
    notifyListeners();
  }

  void editNote(Note note) async {
    await NotesDBHelper.instance.updateNote(note);
    notifyListeners();
  }

  void deleteNote(int id) async {
    await NotesDBHelper.instance.deleteNote(id);
    notifyListeners();
  }
}
