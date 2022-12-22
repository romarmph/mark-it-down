import 'package:flutter/material.dart';
import 'package:mark_it_down/components/alert_title.dart';

import '../components/main_category.dart';
import '../constants/colors.dart';
import '../database/notebooks_db_helper.dart';
import '../models/notebooks.dart';

class MIDDrawer extends StatefulWidget {
  const MIDDrawer({super.key});

  @override
  State<MIDDrawer> createState() => _MIDDrawerState();
}

class _MIDDrawerState extends State<MIDDrawer> {
  final _notebookController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).primaryColor,
      elevation: 0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            width: double.infinity,
            height: 150,
            color: primaryLight,
            child: const Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                "Mark It Down",
                style: TextStyle(
                  color: light,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          MainCategory(
            leading: Icons.list_alt,
            title: "All notes",
            onTap: () {},
          ),
          const MainCategory(
            title: "Notebooks",
            leading: Icons.library_books,
          ),
          Expanded(
            child: FutureBuilder(
              future: NotebooksDBHelper.instance.getNotebooks(),
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
          ),
          Container(
            height: 74,
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.add),
              onPressed: () {
                addNotebookDialog();
              },
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: light,
                foregroundColor: primary,
              ),
              label: const Text(
                "New notebook",
              ),
            ),
          ),
        ],
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

  void deleteNotebook(int id) {
    NotebooksDBHelper.instance.remove(id);
  }

  void addNotebook(String name) async {
    if (name.isNotEmpty) {
      await NotebooksDBHelper.instance.add(
        Notebook(
          name: name,
        ),
      );
    }
  }

  void editNotebook(int id) async {
    if (_notebookController.text.isNotEmpty) {
      await NotebooksDBHelper.instance.update(
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
                Navigator.of(context).popUntil((route) => route.isFirst);
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
                "Add Notebook",
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

  void addNotebookDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: background,
          title: const AlertTitle(
            title: "Add notebook",
          ),
          content: TextField(
            controller: _notebookController,
            decoration: const InputDecoration(
              hintText: "Notebook name",
            ),
          ),
          contentPadding: const EdgeInsets.all(16),
          actionsAlignment: MainAxisAlignment.center,
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
                addNotebook(_notebookController.text);
                setState(() {
                  _notebookController.clear();
                });
                Navigator.of(context).pop();
              },
              child: const Text(
                "Add Notebook",
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
