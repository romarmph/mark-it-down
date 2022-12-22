import 'package:flutter/material.dart';
import 'package:mark_it_down/constants/colors.dart';

class AlertTitle extends StatelessWidget {
  const AlertTitle({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: dark,
        fontSize: 16,
      ),
    );
  }
}
