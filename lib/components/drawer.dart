import 'package:flutter/material.dart';
import 'package:mark_it_down/providers/notes_provider.dart';
import 'package:provider/provider.dart';

import '../components/alert_title.dart';
import '../components/main_category.dart';
import '../components/notebooks_builder.dart';
import '../constants/colors.dart';
import '../providers/notebook_provider.dart';
import '../models/notebooks.dart';

class MIDDrawer extends StatefulWidget {
  const MIDDrawer({super.key});

  @override
  State<MIDDrawer> createState() => _MIDDrawerState();
}

class _MIDDrawerState extends State<MIDDrawer> {
  final _notebookController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

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
            onTap: () {
              final provider = Provider.of<NotesProvider>(
                context,
                listen: false,
              );

              provider.searchText = "";
              provider.setNotebookID = 0;
              Navigator.of(context).pop();
            },
          ),
          const MainCategory(
            title: "Notebooks",
            leading: Icons.library_books,
          ),
          const Expanded(
            child: NotebooksBuilder(),
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
        return Form(
          key: _formKey,
          child: AlertDialog(
            backgroundColor: background,
            title: const AlertTitle(
              title: "Add notebook",
            ),
            content: TextFormField(
              maxLength: 12,
              controller: _notebookController,
              decoration: const InputDecoration(
                hintText: "Notebook name",
                counterText: "",
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: danger,
                    width: 1,
                  ),
                ),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return "Enter notebook name";
                } else {
                  return null;
                }
              },
            ),
            contentPadding: const EdgeInsets.all(16),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              TextButton(
                onPressed: () {
                  setState(() {
                    _notebookController.clear();
                  });
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
                  if (_formKey.currentState!.validate()) {
                    NotebookProvider provider = Provider.of<NotebookProvider>(
                      context,
                      listen: false,
                    );
                    provider.addNotebook(
                      Notebook(
                        name: _notebookController.text,
                      ),
                    );
                    setState(() {
                      _notebookController.clear();
                    });
                    Navigator.of(context).pop();
                  }
                },
                child: const Text(
                  "Add Notebook",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
