// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:mark_it_down/providers/notebook_provider.dart';
import 'package:mark_it_down/providers/notes_provider.dart';
import 'package:mark_it_down/screens/edit_note.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

import '../constants/colors.dart';
import '../models/note.dart';

// ignore: must_be_immutable
class ViewNoteScreen extends StatelessWidget {
  ViewNoteScreen({
    super.key,
    required this.id,
    required this.passed,
  });

  final int id;
  Note passed;
  int notebookID = 0;
  String notebookName = "";

  @override
  Widget build(BuildContext context) {
    final notebookProvider = Provider.of<NotebookProvider>(
      context,
      listen: false,
    );
    return Consumer<NotesProvider>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {
                showDeleteDialog(id, context);
              },
              icon: const Icon(
                Icons.delete,
                color: danger,
              ),
            ),
          ],
        ),
        body: FutureBuilder(
          future: value.getNote(id),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var note = snapshot.data!;
              passed = snapshot.data!;
              return Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    Container(
                      color: light,
                      child: ListTile(
                        title: Row(
                          children: [
                            Expanded(
                              flex: 6,
                              child: Text(
                                note.title,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
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
                                  notebookID = note.notebookID!;
                                  notebookName = snapshot.data!;
                                  return Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: primaryLight,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      snapshot.data!,
                                      textAlign: TextAlign.center,
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
                        subtitle: Text(
                          formatDate(
                            DateTime.parse(note.date),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: Container(
                        color: light,
                        child: Markdown(
                          data: note.content,
                          extensionSet: md.ExtensionSet(
                            md.ExtensionSet.gitHubFlavored.blockSyntaxes,
                            [
                              md.EmojiSyntax(),
                              ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes
                            ],
                          ),
                          onTapLink: (text, href, title) async {
                            try {
                              await launchUrl(Uri.parse(href!));
                            } catch (e) {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text(
                                        "You don't have a browser to open this link."),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text("Okay"),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                          styleSheet: MarkdownStyleSheet(
                            code: const TextStyle(
                              backgroundColor: greyMute,
                            ),
                            codeblockDecoration: BoxDecoration(
                              color: greyMute,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            value.selectedNotebook = notebookID;
            value.selectedNotebookName = notebookName;
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => EditNoteScreen(
                  note: passed,
                ),
              ),
            );
          },
          child: const Icon(Icons.edit),
        ),
      ),
    );
  }

  void showDeleteDialog(int id, BuildContext context) {
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
                Navigator.of(context).pop();
                NotesProvider provider = Provider.of<NotesProvider>(
                  context,
                  listen: false,
                );
                provider.deleteNote(id);
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

  int setNotebookID(int id) {
    return id;
  }

  String setNotebookName(String name) {
    return name;
  }

  String formatDate(DateTime dateTime) {
    final DateFormat formatter = DateFormat("MMM d, yyyy | h:mm a");
    return formatter.format(dateTime);
  }
}
