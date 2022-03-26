// ignore_for_file: unused_element
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_alert/net/flutterfire.dart';
import 'package:flutter_app_alert/views/index.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserUI extends StatefulWidget {
  const UserUI({Key? key}) : super(key: key);

  @override
  State<UserUI> createState() => _UserUIState();
}

class _UserUIState extends State<UserUI> {
  //

  // database
  String? displayname;
  String login = '...';
  showLogin() {
    return Text('Login by $login');
  }

  //
  AuthClass authClass = AuthClass();
  int currentIndex = 4;
  final auth = FirebaseAuth.instance;
  final storage = new FlutterSecureStorage();

  //
  @override
  Widget build(BuildContext context) {
    Future<Null> findDisplayName() async {
      await Firebase.initializeApp().then((value) async {
        await FirebaseAuth.instance.authStateChanges().listen((event) {
          displayname = event?.displayName;
          print('##### displayname=$displayname');
        });
      });
    }

    // final Stream<QuerySnapshot> users =
    //     FirebaseFirestore.instance.collection('users').snapshots();
    return Scaffold(
      backgroundColor: Colors.red,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(auth.currentUser?.displayName ?? ''),
                  Text(auth.currentUser?.email ?? ''),
                  Text(auth.currentUser?.uid ?? ''),

                  //read token in text("")

                  // Text(
                  //   (storage.read(key: 'token')?"").toString(),
                  // ),
                ],
              ),
              SizedBox(
                height: 50,
              ),
              ElevatedButton(
                child: Text('ออกจากระบบ'),
                onPressed: () async {
                  await authClass.logout();
                  {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => IndexUI()),
                    );
                  }
                  ;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
