import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_alert/net/flutterfire.dart';
import 'package:flutter_app_alert/views/home/content_home_ui.dart';
import 'package:flutter_app_alert/views/law/content_law_ui.dart';
import 'package:flutter_app_alert/views/map/content_location_ui.dart';
import 'package:flutter_app_alert/views/social/content_social_ui.dart';
import 'package:flutter_app_alert/views/user/content_user_ui.dart';
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
    SocialUI(),
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
        body: Screens[currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          selectedItemColor: Color.fromARGB(255, 0, 133, 241),
          unselectedItemColor: Color.fromARGB(255, 143, 143, 143),
          elevation: 0,
          enableFeedback: true,
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
