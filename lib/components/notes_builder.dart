import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import '../constants/colors.dart';
import '../models/note.dart';
import '../screens/view_note.dart';

class NotesBuilder extends StatefulWidget {
  const NotesBuilder({
    super.key,
    this.future,
  });

  final Future<List<Note>>? future;

  @override
  State<NotesBuilder> createState() => _NotesBuilderState();
}

class _NotesBuilderState extends State<NotesBuilder> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: NotesDBHelper.instance.getNotes(),
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
            : ListView(
                children: snapshot.data!.map(
                  (note) {
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
                              note.title,
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              formatDate(note.date),
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
                                return ViewNoteScreen(note: note);
                              },
                            ),
                          );
                        },
                        onLongPress: () {},
                      ),
                    );
                  },
                ).toList(),
              );
      },
    );
  }

  String formatDate(String data) {
    final List<String> months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    final List<String> time = data.split(" ").elementAt(1).split(":");
    final List<String> date = data.split(" ").elementAt(0).split("-");

    String ampm = "PM";

    if (int.parse(time[0]) % 12 == 0 || int.parse(time[0]) == 2) {
      ampm = "AM";
    } else {
      time[0] = (int.parse(time[0]) - 12).toString();
    }

    return "${months[int.parse(date[1]) - 1]} ${date[2]}, ${date[0]} | ${time[0]}:${time[1]} $ampm";
  }
}
