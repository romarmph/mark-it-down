import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/colors.dart';
import '../models/note.dart';
import '../providers/notebook_provider.dart';
import '../providers/notes_provider.dart';

class EditNoteScreen extends StatefulWidget {
  const EditNoteScreen({
    super.key,
    required this.note,
  });

  final Note note;

  @override
  State<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  void initState() {
    _titleController.text = widget.note.title;
    _contentController.text = widget.note.content;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NotesProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Note"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(
              maxLength: 32,
              controller: _titleController,
              decoration: const InputDecoration(
                counterText: "",
                hintText: "Title",
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text(
                  "Notebook",
                  style: TextStyle(
                    color: greyMute,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      showNotebooks();
                    },
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(12),
                        backgroundColor: light,
                        foregroundColor: primary,
                        shadowColor: greyMute,
                        elevation: 0),
                    child: Text(
                      provider.selectedNotebookName.isEmpty
                          ? "None"
                          : provider.selectedNotebookName,
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
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
          NotesProvider provider = Provider.of<NotesProvider>(
            context,
            listen: false,
          );
          provider.editNote(
            Note(
              id: widget.note.id,
              content: _contentController.text,
              title: _titleController.text,
              date: DateTime.now().toString(),
              notebookID: provider.selectedNotebook,
            ),
          );

          provider.selectedNotebook = 0;
          provider.selectedNotebookName = "";
          Navigator.of(context).pop();
        },
        child: const Icon(Icons.save),
      ),
    );
  }

  void showNotebooks() {
    showModalBottomSheet(
      barrierColor: const Color.fromARGB(50, 0, 0, 0),
      backgroundColor: const Color.fromARGB(0, 0, 0, 0),
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          height: 400,
          width: double.infinity,
          child: Center(
            child: SizedBox(
              width: 300,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 16,
                      child: Consumer<NotebookProvider>(
                        builder: (context, provider, child) {
                          return FutureBuilder(
                            future: provider.notebookList,
                            builder: (context, snapshot) {
                              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                return const Center(
                                  child: Text("No notebooks available"),
                                );
                              }
                              return ListView.builder(
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, index) {
                                  return TextButton(
                                    style: TextButton.styleFrom(
                                      padding: const EdgeInsets.all(16),
                                    ),
                                    onPressed: () {
                                      final noteProvider =
                                          Provider.of<NotesProvider>(
                                        context,
                                        listen: false,
                                      );

                                      noteProvider.selectedNotebookName =
                                          snapshot.data![index].name;
                                      noteProvider.selectedNotebook =
                                          snapshot.data![index].id!;

                                      Navigator.of(context).pop();
                                    },
                                    child: Text(
                                      snapshot.data![index].name,
                                      style: const TextStyle(
                                        color: primary,
                                        fontSize: 16,
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        elevation: 16,
                        backgroundColor: light,
                        foregroundColor: primary,
                        padding: const EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        )),
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
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
