import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mark_it_down/models/note.dart';
import 'package:mark_it_down/screens/edit_note.dart';
import 'package:provider/provider.dart';

import '../providers/notebook_provider.dart';
import '../constants/colors.dart';
import '../providers/notes_provider.dart';
import '../screens/view_note.dart';
import 'alert_title.dart';

class NotesBuilder extends StatefulWidget {
  const NotesBuilder({
    super.key,
  });

  @override
  State<NotesBuilder> createState() => _NotesBuilderState();
}

class _NotesBuilderState extends State<NotesBuilder> {
  @override
  Widget build(BuildContext context) {
    final notebookProvider = Provider.of<NotebookProvider>(
      context,
      listen: false,
    );
    return Consumer<NotesProvider>(
      builder: (context, value, child) => FutureBuilder(
        future: value.noteList(value.notebookID, value.searchText),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: Text("Loading.."),
            );
          }

          if (snapshot.data!.isEmpty && value.searchText.isNotEmpty) {
            return const Center(
              child: Text("Note not found"),
            );
          }

          return snapshot.data!.isEmpty
              ? const Center(
                  child: Text(
                    "You don't have any notes yet",
                    style: TextStyle(
                      color: dark,
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context, index) {
                    var note = snapshot.data?[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      color: light,
                      elevation: 0,
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  flex: 6,
                                  child: Text(
                                    note!.title,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: FutureBuilder(
                                    future: notebookProvider.notebookName(
                                      note.notebookID ?? 0,
                                    ),
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData ||
                                          snapshot.data!.isEmpty) {
                                        return Container();
                                      }
                                      return Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: primaryLight,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          snapshot.data!,
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: light,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              formatDate(DateTime.parse(note.date)),
                              style: const TextStyle(
                                color: primary,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                        subtitle: Text(
                          note.content.split('\n').elementAt(0).length > 32
                              ? note.content.replaceRange(36, null, "...")
                              : note.content.split('\n').elementAt(0),
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return ViewNoteScreen(
                                  id: note.id!,
                                  passed: note,
                                );
                              },
                            ),
                          );
                        },
                        onLongPress: () {
                          showMenu(note);
                        },
                      ),
                    );
                  },
                );
        },
      ),
    );
  }

  String formatDate(DateTime dateTime) {
    final DateFormat formatter = DateFormat("MMM d, yyyy | h:mm a");
    return formatter.format(dateTime);
  }

  void showMenu(Note note) {
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
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => EditNoteScreen(
                          note: note,
                        ),
                      ),
                    );
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
                    deleteConfirmation(note);
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

  void deleteConfirmation(Note note) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: background,
          title: const AlertTitle(
            title: "Delete notebook",
          ),
          content: Text(
            "Are you sure to delete '${note.title}'?",
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
                NotesProvider notesProvider = Provider.of<NotesProvider>(
                  context,
                  listen: false,
                );

                notesProvider.deleteNote(note.id!);

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
}
