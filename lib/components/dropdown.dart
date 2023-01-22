import 'package:flutter/material.dart';
import 'package:mark_it_down/constants/colors.dart';
import 'package:mark_it_down/providers/notes_provider.dart';
import 'package:provider/provider.dart';

import '../providers/notebook_provider.dart';

class NotebookDropdown extends StatefulWidget {
  const NotebookDropdown({super.key});

  @override
  State<NotebookDropdown> createState() => _NotebookDropdownState();
}

class _NotebookDropdownState extends State<NotebookDropdown> {
  @override
  Widget build(BuildContext context) {
    NotebookProvider notebookProvider = Provider.of<NotebookProvider>(context);
    NotesProvider noteProvider = Provider.of<NotesProvider>(
      context,
      listen: false,
    );
    return Container(
      decoration: BoxDecoration(
        color: light,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(14),
      width: double.infinity,
      height: 48,
      child: FutureBuilder(
        future: notebookProvider.notebookList,
        builder: (context, snapshot) {
          List<DropdownMenuItem>? itemList = snapshot.data
              ?.map(
                (e) => DropdownMenuItem(
                  value: e.id,
                  child: Text(e.name),
                ),
              )
              .toList();
          itemList?.insert(
            0,
            const DropdownMenuItem<int>(
              value: 0,
              child: Text("None"),
            ),
          );
          return DropdownButton(
            elevation: 2,
            borderRadius: BorderRadius.circular(8),
            isExpanded: true,
            menuMaxHeight: 400,
            value: noteProvider.selectedNotebook,
            items: itemList,
            onChanged: (value) async {
              noteProvider.selectedNotebook = value;
            },
          );
        },
      ),
    );
  }
}
