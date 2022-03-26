import 'package:flutter/material.dart';

class NewsUI extends StatefulWidget {
  const NewsUI({Key? key}) : super(key: key);

  @override
  State<NewsUI> createState() => _NewsUIState();
}

class _NewsUIState extends State<NewsUI> {
  int currentIndex = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
    );
  }
}
