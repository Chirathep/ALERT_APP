import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_alert/net/flutterfire.dart';
import 'package:flutter_app_alert/net/user_model.dart';
import 'package:flutter_app_alert/views/main/main_home_ui.dart';
import 'package:flutter_app_alert/views/main/index.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore_for_file: unused_local_variable, unused_element
main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MyApp(),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  State<MyApp> createState() => _MyAppState();
}

//
String? finalEmail;
String? finalName;

//
class _MyAppState extends State<MyApp> {
  //username sync Email
  final Stream<QuerySnapshot> users =
      FirebaseFirestore.instance.collection('users').snapshots();

  //private FirebaseAuth
  //
  Widget currentPage = IndexUI();
  AuthClass authClass = AuthClass();
  UserModel loggedInUser = UserModel();
  //
  @override
  void initState() {
    // authClass.logout();
    super.initState();
    checkLoginEmail();
    checkLoginGmail();
  }

  Future<void> findDisplayname() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    print('login = $login');
  }

  Future getvalidationData() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    var obtainedEmail = sharedPreferences.getString('email');

    setState(() {
      finalEmail = obtainedEmail;
    });
    print(finalEmail);
  }

//
  checkLoginEmail() async {
    await getvalidationData();
    if (finalEmail != null) {
      setState(() {
        currentPage = MainHomeUI();
      });
    }
  }

//chack data
  void checkLoginGmail() async {
    String? token = await authClass.getToken();
    if (token != null) {
      setState(() {
        currentPage = MainHomeUI();
      });
      print(token);
    }
  }

  //createuser in firestore
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: currentPage,
      theme: ThemeData(
        fontFamily: 'SukhumvitSet',
      ),
    );
  }
}
