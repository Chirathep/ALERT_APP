// ignore_for_file: unused_element
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_alert/net/flutterfire.dart';
import 'package:flutter_app_alert/net/user_model.dart';
import 'package:flutter_app_alert/views/main/index.dart';
import 'package:flutter_app_alert/views/progress.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserUI extends StatefulWidget {
  const UserUI({Key? key}) : super(key: key);

  @override
  State<UserUI> createState() => _UserUIState();
}

class _UserUIState extends State<UserUI> {
  //

  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  // database

  String login = '...';
  showLogin() {
    return Text('Login by $login');
  }

//

  //
  AuthClass authClass = AuthClass();
  int currentIndex = 4;
  final auth = FirebaseAuth.instance;
  final storage = new FlutterSecureStorage();
  @override
  void initState() {
    super.initState();

    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
      print(this.loggedInUser.name);
    });
  }

  // getUser() {
  //   usersRef.get().then((QuerySnapshot snapshot) {
  //     snapshot.docs.forEach((DocumentSnapshot doc) {
  //       print(doc.data());
  //     });
  //   });
  // }

  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
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
        backgroundColor: Colors.grey[50],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      StreamBuilder(
                        stream: usersRef.doc(user!.uid).snapshots(),
                        initialData: null,
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (!snapshot.hasData) {
                            return circularProgress();
                          }
                          final DocumentSnapshot doc = snapshot.data;
                          return Text(doc['name']);
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(auth.currentUser?.email ?? ''),
                    ],
                  ),
                  Text(auth.currentUser?.uid ?? ''),
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
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // deleteUser() async {
  //   usersRef.doc(loggedInUser.uid ?? "").delete();
  // }
}
