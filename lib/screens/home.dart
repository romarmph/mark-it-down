import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/notes_provider.dart';
import '../components/notes_builder.dart';
import '../constants/colors.dart';
import '../components/drawer.dart';
import '../screens/add_note.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NotesProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: background,
        title: const Text("My Notes"),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          TextEditingController().clear();
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              TextField(
                onChanged: (value) {
                  if (_searchController.text.isNotEmpty) {
                    provider.searchText = _searchController.text;
                    provider.setNotebookID = 0;
                  } else {
                    provider.searchText = "";
                    provider.setNotebookID = 0;
                  }
                },
                textAlignVertical: TextAlignVertical.center,
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Search Notes",
                  suffixIcon: _searchController.text.isEmpty
                      ? IconButton(
                          focusColor: primaryLight,
                          onPressed: () {
                            if (_searchController.text.isNotEmpty) {
                              provider.searchText = _searchController.text;
                              provider.setNotebookID = 0;
                            } else {
                              provider.searchText = "";
                              provider.setNotebookID = 0;
                            }
                          },
                          icon: const Icon(
                            Icons.search,
                          ),
                        )
                      : IconButton(
                          focusColor: primaryLight,
                          onPressed: () {
                            setState(() {
                              _searchController.clear();
                            });
                            provider.searchText = "";
                            provider.setNotebookID = 0;
                          },
                          icon: const Icon(
                            Icons.close,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 16),
              const Expanded(
                child: NotesBuilder(),
              ),
            ],
          ),
        ),
      ),
      drawer: const MIDDrawer(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return const AddNoteScreen();
              },
            ),
          );
        },
        label: const Text("Create"),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
