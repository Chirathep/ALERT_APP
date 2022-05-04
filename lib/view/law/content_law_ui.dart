import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_alert/net/flutterfire.dart';
import 'package:flutter_app_alert/net/user_model.dart';
import 'package:flutter_app_alert/views/main/index.dart';
import 'package:flutter_app_alert/views/main/register_ui2.dart';
import 'package:flutter_app_alert/views/social/upload.dart';

class LawUI extends StatefulWidget {
  const LawUI({Key? key}) : super(key: key);

  @override
  State<LawUI> createState() => _LawUIState();
}

class _LawUIState extends State<LawUI> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel userModel = UserModel();
  // int currentIndex = 3;
  //image

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
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
              ElevatedButton(
                child: Text('ออกจากsะบบ'),
                onPressed: () async {
                  await AuthClass().logout();
                  {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => IndexUI()),
                    );
                  }
                },
              ),
              ElevatedButton(
                child: Text('upload'),
                onPressed: () {
                  {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Upload()),
                    );
                  }
                },
              ),
              ElevatedButton(
                child: Text('regis'),
                onPressed: () async {
                  {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Register2UI()),
                    );
                  }
                },
              ),
            ],
          ),
        ),
        backgroundColor: Colors.grey[50],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              ListBody(
                children: [
                  Text(
                    "Welcome",
                  ),
                  Text(
                    "to",
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
