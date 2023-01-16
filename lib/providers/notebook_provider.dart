import 'package:flutter/material.dart';

import '../database/notebookdb_helper.dart';
import '../models/notebooks.dart';

class NotebookProvider extends ChangeNotifier {
  List<Notebook> _notebookList = [];

  Future<List<Notebook>> get notebookList async {
    _notebookList = await NotebookDBHelper.instance.getNotebooks();
    notifyListeners();
    return _notebookList;
  }

  void addNotebook(Notebook notebook) async {
    await NotebookDBHelper.instance.createNotebook(notebook);
    notifyListeners();
  }

  void editNotebook(Notebook notebook) async {
    await NotebookDBHelper.instance.updateNotebook(notebook);
    notifyListeners();
  }

  void deleteNotebook(int id) async {
    await NotebookDBHelper.instance.deleteNotebook(id);
    notifyListeners();
  }
}
