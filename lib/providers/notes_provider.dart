import 'package:flutter/material.dart';

import '../database/notedb_helper.dart';
import '../models/note.dart';

class NotesProvider extends ChangeNotifier {
  int _notebookID = 0;
  List<Note> _noteList = [];
  int _selectedNotebook = 0;
  String _selectedNotebookName = "";

  String get selectedNotebookName => _selectedNotebookName;
  int get selectedNotebook => _selectedNotebook;
  int get notebookID => _notebookID;

  set selectedNotebookName(String name) {
    _selectedNotebookName = name;
    notifyListeners();
  }

  set setNotebookID(int id) {
    _notebookID = id;
    notifyListeners();
  }

  set selectedNotebook(int value) {
    _selectedNotebook = value;
    notifyListeners();
  }

  Future<List<Note>> noteList(int notebookID) async {
    _noteList = await NotesDBHelper.instance.getNotes(_notebookID);

    notifyListeners();
    return _noteList;
  }

  void changeNotebookID(int id) async {
    await NotesDBHelper.instance.updateNotebookID(id);
    _notebookID = 0;
    notifyListeners();
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
