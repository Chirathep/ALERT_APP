import 'package:flutter/material.dart';

class LocatUI extends StatefulWidget {
  const LocatUI({Key? key}) : super(key: key);

  @override
  State<LocatUI> createState() => _LocatUIState();
}

class _LocatUIState extends State<LocatUI> {
  int currentIndex = 2;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text('Map')],
        ),
      ),
    );
  }
}
