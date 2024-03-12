import 'package:flutter/material.dart';

class CharacterProgress extends StatelessWidget {
  final String buttonText;
  const CharacterProgress({super.key, required this.buttonText});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: 32,
      height: 32,
      decoration: BoxDecoration(
          color: const Color(0xffB4D4FE),
          borderRadius: BorderRadius.circular(100)),
      child: Text(
        buttonText,
        style: const TextStyle(
            fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }
}
