import 'package:flutter/material.dart';
import 'package:mark_it_down/database/database_helper.dart';

import '../models/note.dart';

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({
    super.key,
  });

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create note"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: "Title",
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TextField(
                controller: _contentController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: const InputDecoration(
                  hintText: "Write your thoughts here...",
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addNote(
            _titleController.text,
            content: _contentController.text,
          );
          setState(() {
            _contentController.clear();
            _titleController.clear();
          });
          Navigator.of(context).pop();
        },
        child: const Icon(Icons.save),
      ),
    );
  }

  void addNote(String title, {String content = ""}) async {
    if (title.isNotEmpty) {
      await NotesDBHelper.instance.createNote(
        Note(
          title: title,
          date: DateTime.now().toString(),
          content: content,
        ),
      );
    }
  }
}
