import 'package:flutter/material.dart';
import 'package:mark_it_down/database/database_helper.dart';

import '../constants/colors.dart';
import '../models/note.dart';

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
      future: DatabaseHelper.instance.getNotes(),
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
                    return ListTile(
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
                            note.date,
                            style: const TextStyle(
                              color: primary,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      onTap: () {},
                      onLongPress: () {
                        setState(() {
                          deleteNote(note.id!);
                        });
                      },
                    );
                  },
                ).toList(),
              );
      },
    );
  }

  void deleteNote(int id) {
    DatabaseHelper.instance.deleteNote(id);
  }
}
