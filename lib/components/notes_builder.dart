import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
    return Consumer<NotesProvider>(
      builder: (context, value, child) => FutureBuilder(
        future: value.noteList,
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
                          print(note.notebookID);
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
