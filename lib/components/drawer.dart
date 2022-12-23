import 'package:flutter/material.dart';
import 'package:mark_it_down/components/alert_title.dart';
import 'package:mark_it_down/components/notebooks_builder.dart';

import '../components/main_category.dart';
import '../constants/colors.dart';
import '../database/database_helper.dart';
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
            child: NotebooksBuilder(
              future: DatabaseHelper.instance.getNotebooks(),
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

  void addNotebook(String name) async {
    if (name.isNotEmpty) {
      await DatabaseHelper.instance.createNotebook(
        Notebook(
          name: name,
        ),
      );
    }
  }
}
