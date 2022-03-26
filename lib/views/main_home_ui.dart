import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_alert/net/flutterfire.dart';
import 'package:flutter_app_alert/views/content_home_ui.dart';
import 'package:flutter_app_alert/views/content_law_ui.dart';
import 'package:flutter_app_alert/views/content_location_ui.dart';
import 'package:flutter_app_alert/views/content_news_ui.dart';
import 'package:flutter_app_alert/views/content_user_ui.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MainHomeUI extends StatefulWidget {
  const MainHomeUI({Key? key}) : super(key: key);

  @override
  State<MainHomeUI> createState() => _ContentHomeUIState();
}

class _ContentHomeUIState extends State<MainHomeUI> {
//
  AuthClass authClass = AuthClass();
  final auth = FirebaseAuth.instance;
  final storage = new FlutterSecureStorage();
  int currentIndex = 0;

  final Screens = [
    HomeUI(),
    NewsUI(),
    LocatUI(),
    LawUI(),
    UserUI(),
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(
          leadingWidth: 0,
          elevation: 0,
          title: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/images/alertlogo.png',
                  width: 85,
                ),
              ],
            ),
          ),
          // actions: [
          //   IconButton(
          //     onPressed: () {},
          //     icon: Icon(Icons.search),
          //     color: Colors.grey,
          //   ),
          // ],
          backgroundColor: Colors.grey[50],
        ),
        body: Screens[currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          elevation: 0,
          onTap: (index) => setState(() => currentIndex = index),
          backgroundColor: Colors.grey[50],
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'หน้าหลัก',
              backgroundColor: Colors.blue,
            ),
            BottomNavigationBarItem(
              //fontawesome
              icon: Icon(FontAwesomeIcons.solidHeart),
              label: 'สังคม',
              backgroundColor: Colors.green,
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.solidMap),
              label: 'แผนที่',
              backgroundColor: Colors.orange,
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.gavel),
              label: 'กฏหมาย',
              backgroundColor: Colors.brown[600],
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'ผู้ใช้งาน',
              backgroundColor: Colors.purple,
            ),
          ],
        ),
      ),
    );
  }
}
