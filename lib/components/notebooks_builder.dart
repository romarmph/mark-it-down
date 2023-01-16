import 'package:flutter/material.dart';
import 'package:mark_it_down/providers/notebook_provider.dart';
import 'package:provider/provider.dart';

import '../components/alert_title.dart';
import '../database/notebookdb_helper.dart';
import '../constants/colors.dart';
import '../models/notebooks.dart';

class NotebooksBuilder extends StatefulWidget {
  const NotebooksBuilder({
    super.key,
  });

  @override
  State<NotebooksBuilder> createState() => _NotebooksBuilderState();
}

class _NotebooksBuilderState extends State<NotebooksBuilder> {
  final _notebookController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<NotebookProvider>(
      builder: (context, value, child) => FutureBuilder(
        future: value.notebookList,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: Text("Loading.."),
            );
          }

          return snapshot.data!.isEmpty
              ? const Center(
                  child: Text(
                    "Add your first notebook now",
                    style: TextStyle(
                      color: light,
                    ),
                  ),
                )
              : ListView(
                  children: snapshot.data!.map(
                    (notebook) {
                      return ListTile(
                        contentPadding: const EdgeInsets.only(
                          left: 32,
                        ),
                        iconColor: light,
                        textColor: light,
                        minLeadingWidth: 0,
                        leading: const Icon(
                          Icons.book,
                        ),
                        title: Text(
                          notebook.name,
                          style: const TextStyle(fontSize: 16),
                        ),
                        onTap: () {},
                        onLongPress: () {
                          showMenu(notebook);
                        },
                      );
                    },
                  ).toList(),
                );
        },
      ),
    );
  }

  void showMenu(Notebook notebook) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: background,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                  ),
                  onPressed: () {
                    editDialog(notebook);
                  },
                  child: const Text(
                    "Edit",
                    style: TextStyle(
                      color: primary,
                      fontSize: 16,
                    ),
                  ),
                ),
                TextButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    deleteConfirmation(notebook);
                  },
                  child: const Text(
                    "Delete",
                    style: TextStyle(
                      color: danger,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void deleteNotebook(int id) async {
    await NotebookDBHelper.instance.deleteNotebook(id);
  }

  void editNotebook(int id) async {
    if (_notebookController.text.isNotEmpty) {
      await NotebookDBHelper.instance.updateNotebook(
        Notebook(
          id: id,
          name: _notebookController.text,
        ),
      );
    }
  }

  void deleteConfirmation(Notebook notebook) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: background,
          title: const AlertTitle(
            title: "Edit notebook",
          ),
          content: Text(
            "Are you sure to delete $notebook?",
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                "Cancel",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: danger,
              ),
              onPressed: () {
                setState(() {
                  deleteNotebook(notebook.id!);
                  _notebookController.clear();
                });
                Navigator.of(context).pop();
              },
              child: const Text(
                "Yes, delete",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void editDialog(Notebook notebook) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: background,
          title: const AlertTitle(
            title: "Edit notebook",
          ),
          content: TextField(
            controller: _notebookController,
            decoration: InputDecoration(
              hintText: notebook.name,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                "Cancel",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
              ),
              onPressed: () {
                setState(() {
                  editNotebook(notebook.id!);
                  _notebookController.clear();
                });
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: const Text(
                "Save",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
