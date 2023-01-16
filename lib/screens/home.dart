import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/notes_builder.dart';
import '../constants/colors.dart';
import '../components/drawer.dart';
import '../providers/notes_provider.dart';
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: background,
        title: const Text("My Notes"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              textAlignVertical: TextAlignVertical.center,
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search Notes",
                suffixIcon: IconButton(
                  focusColor: primaryLight,
                  onPressed: () {},
                  icon: const Icon(
                    Icons.search,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Consumer<NotesProvider>(
              builder: (context, value, child) => const Expanded(
                child: NotesBuilder(),
              ),
            ),
          ],
        ),
      ),
      drawer: const MIDDrawer(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return const AddNoteScreen();
              },
            ),
          );
          setState(() {
            _searchController.clear();
          });
        },
        label: const Text("Create"),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
