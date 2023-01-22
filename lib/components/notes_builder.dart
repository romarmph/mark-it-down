import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mark_it_down/providers/notebook_provider.dart';
import 'package:provider/provider.dart';

import '../constants/colors.dart';
import '../providers/notes_provider.dart';
import '../screens/view_note.dart';

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
        future: value.noteList(value.notebookID),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: Text("Loading.."),
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
                            Text(
                              note!.title,
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 8,
                                  child: Text(
                                    formatDate(DateTime.parse(note.date)),
                                    style: const TextStyle(
                                      color: primary,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: FutureBuilder(
                                      future: notebookProvider.notebookName(
                                        note.notebookID!,
                                      ),
                                      builder: (context, snapshot) {
                                        if (!snapshot.hasData ||
                                            snapshot.data!.isEmpty) {
                                          return Container();
                                        }
                                        return Text(
                                          snapshot.data!,
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
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
                        onLongPress: () {},
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
}
