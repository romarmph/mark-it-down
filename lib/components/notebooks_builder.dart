import 'package:flutter/material.dart';
import '../database/notebooks_db_helper.dart';
import '../constants/colors.dart';
import '../models/notebooks.dart';

class NotebooksBuilder extends StatefulWidget {
  const NotebooksBuilder({
    super.key,
    this.future,
  });

  final Future<List<Notebook>>? future;

  @override
  State<NotebooksBuilder> createState() => _NotebooksBuilderState();
}

class _NotebooksBuilderState extends State<NotebooksBuilder> {
  final _notebookController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.future,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: Text("Loading.."),
          );
        }

        return snapshot.data!.isEmpty
            ? const Center(
                child: Text(
                  "Add your first notebook now",
                  style: TextStyle(
                    color: light,
                  ),
                ),
              )
            : ListView(
                children: snapshot.data!.map(
                  (notebook) {
                    return ListTile(
                      contentPadding: const EdgeInsets.only(
                        left: 32,
                      ),
                      iconColor: light,
                      textColor: light,
                      minLeadingWidth: 0,
                      leading: const Icon(
                        Icons.book,
                      ),
                      title: Text(
                        notebook.name,
                        style: const TextStyle(fontSize: 16),
                      ),
                      onTap: () {},
                      onLongPress: () {},
                    );
                  },
                ).toList(),
              );
      },
    );
  }
}
