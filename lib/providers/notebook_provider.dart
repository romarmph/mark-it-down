import 'package:flutter/material.dart';

import '../database/notebookdb_helper.dart';
import '../models/note.dart';
import '../models/notebooks.dart';

class NotebookProvider extends ChangeNotifier {
  List<Notebook> _notebookList = [];

  List<Notebook> get notebookList => _notebookList;

  void getNotes() async {
    _notebookList = await NotebookDBHelper.instance.getNotebooks();
  }
}
