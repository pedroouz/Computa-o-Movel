import 'package:flutter/material.dart';

class TitleText extends StatelessWidget {
  final String texto;

  const TitleText({
    super.key,
    required this.texto,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      texto,
      style: const TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}