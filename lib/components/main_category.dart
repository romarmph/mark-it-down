import 'package:flutter/material.dart';

import '../constants/colors.dart';

class MainCategory extends StatelessWidget {
  const MainCategory({
    Key? key,
    required this.title,
    required this.leading,
    this.onTap,
  }) : super(key: key);

  final String title;
  final IconData leading;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(leading),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
        ),
      ),
      onTap: onTap,
      iconColor: light,
      textColor: light,
    );
  }
}
