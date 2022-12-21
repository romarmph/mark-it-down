import 'package:flutter/material.dart';
import 'package:mark_it_down/constants/colors.dart';

class MIDDrawer extends StatefulWidget {
  const MIDDrawer({super.key});

  @override
  State<MIDDrawer> createState() => _MIDDrawerState();
}

class _MIDDrawerState extends State<MIDDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).primaryColor,
      elevation: 0,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            width: double.infinity,
            height: 150,
            color: primaryLight,
            child: const Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                "Mark It Down",
                style: TextStyle(
                  color: light,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const ListTile(
            leading: Icon(Icons.list_alt),
            title: Text("All notes"),
            iconColor: light,
            textColor: light,
          ),
          const ExpansionTile(
            leading: Icon(Icons.library_books),
            title: Text("Notebooks"),
            collapsedIconColor: light,
            collapsedTextColor: light,
            iconColor: light,
            textColor: light,
            initiallyExpanded: true,
            children: [],
          ),
        ],
      ),
    );
  }
}
