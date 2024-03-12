import 'package:flutter/material.dart';

class CharacterChoiceScreen extends StatefulWidget {
  const CharacterChoiceScreen({super.key, required this.story});

  final String story;

  @override
  State<CharacterChoiceScreen> createState() => _CharacterChoiceScreenState();
}

class _CharacterChoiceScreenState extends State<CharacterChoiceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Text(widget.story)),
    );
  }
}
