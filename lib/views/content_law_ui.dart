import 'package:flutter/material.dart';

class LawUI extends StatefulWidget {
  const LawUI({Key? key}) : super(key: key);

  @override
  State<LawUI> createState() => _LawUIState();
}

class _LawUIState extends State<LawUI> {
  int currentIndex = 3;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
    );
  }
}
