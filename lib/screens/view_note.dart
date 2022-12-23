import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../database/database_helper.dart';
import '../constants/colors.dart';
import '../models/note.dart';

class ViewNoteScreen extends StatefulWidget {
  const ViewNoteScreen({
    super.key,
    required this.note,
  });

  final Note note;

  @override
  State<ViewNoteScreen> createState() => _ViewNoteScreenState();
}

class _ViewNoteScreenState extends State<ViewNoteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              showDeleteDialog(widget.note);
            },
            icon: const Icon(
              Icons.delete,
              color: danger,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Container(
              color: light,
              child: ListTile(
                title: Text(
                  widget.note.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(formatDate(widget.note.date)),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                color: light,
                child: Markdown(
                  data: widget.note.content,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.edit),
      ),
    );
  }

  void showDeleteDialog(Note note) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Warning"),
          content: const Text("Are you sure to delete this note?"),
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
                  deleteNote(note.id!);
                });
                Navigator.of(context).popAndPushNamed('/');
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

  void deleteNote(int id) {
    DatabaseHelper.instance.deleteNote(id);
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
