// ignore_for_file: unused_local_variable, unused_element
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_alert/views/main/index.dart';
import 'package:flutter_app_alert/views/main/main_home_ui.dart';
import 'package:flutter_app_alert/views/main/register_ui2.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
////

final usersRef = FirebaseFirestore.instance.collection('users');
final storage = FlutterSecureStorage();

FirebaseAuth auth = FirebaseAuth.instance;
FirebaseFirestore firestore = FirebaseFirestore.instance;
GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: [
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

class AuthClass {
  Future googleSignIn(BuildContext context) async {
    try {
      GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken,
        );
        try {
          UserCredential userCredential =
              await auth.signInWithCredential(credential);
          storeTokenAndData(userCredential);
          await Firebase.initializeApp().then((value) async {
            await _googleSignIn.signIn().then((value) async {
              String? name = value?.displayName;
              String? email = value?.email;
              String? photoUrl = value?.photoUrl;
              String? uid = value?.id;
              await value?.authentication.then((value2) async {
                AuthCredential authCredential = GoogleAuthProvider.credential(
                  idToken: value2.idToken,
                  accessToken: value2.accessToken,
                );
                await FirebaseAuth.instance
                    .signInWithCredential(authCredential)
                    .then((value3) {
                  String? uid = value3.user?.uid;
                  print('Login with Google: $name, $email, $uid');
                });
              });
            });
          }, onError: (err) {
            print('Error: $err');
          });
          User? user = FirebaseAuth.instance.currentUser;
          var obtainedName = await FirebaseFirestore.instance
              .collection('users')
              .doc(user!.uid)
              .get()
              .then((value) {
            return value.data()?['name'];
          });
          print('Obtained name: $obtainedName');
          if (obtainedName != null) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MainHomeUI(),
              ),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Register2UI(),
              ),
            );
          }
          Fluttertoast.showToast(
              msg: "เข้าสู่ระบบสำเร็จ",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Color.fromARGB(255, 201, 201, 201),
              textColor: Color.fromARGB(255, 43, 43, 43),
              fontSize: 16.0);
        } catch (e) {
          print(e);
          Fluttertoast.showToast(
              msg: "ไม่สามารถเข้าสู่ระบบได้",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Color.fromARGB(255, 236, 116, 114),
              textColor: Colors.white,
              fontSize: 16.0);
        }
      } else {
        print('Google Sign In failed');
      }
    } catch (e) {
      Navigator.pop(
          context, MaterialPageRoute(builder: (context) => IndexUI()));
      print(e);
    }
  }

  Future storeTokenAndData(UserCredential userCredential) async {
    await storage.write(
        key: 'token', value: userCredential.credential?.token.toString());
    await storage.write(
        key: 'userCredential', value: userCredential.toString());
  }

  Future<String?> getToken() async {
    return await storage.read(key: 'token');
  }

  Future logout() async {
    try {
      await _googleSignIn.signOut();
      await auth.signOut();
      await storage.delete(key: 'token');
      final SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      sharedPreferences.remove('email');
    } catch (e) {}
  }
}

//email login
Future<bool> login(String email, String password) async {
  try {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);

    Fluttertoast.showToast(
        msg: "เข้าสู่ระบบสำเร็จ",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Color.fromARGB(255, 201, 201, 201),
        textColor: Color.fromARGB(255, 43, 43, 43),
        fontSize: 16.0);
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.setString('email', email);
    return true;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      Fluttertoast.showToast(
          msg: "ไม่พบผู้ใช้งาน",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Color.fromARGB(255, 236, 116, 114),
          textColor: Colors.white,
          fontSize: 16.0);
      return false;
    } else if (e.code == 'wrong-password') {
      Fluttertoast.showToast(
          msg: "รหัสผ่านไม่ถูกต้อง",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Color.fromARGB(255, 236, 116, 114),
          textColor: Colors.white,
          fontSize: 16.0);
      return false;
    }
    Fluttertoast.showToast(
        msg: "กรุณากรอกข้อมูลให้ถูกต้อง",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Color.fromARGB(255, 236, 116, 114),
        textColor: Colors.white,
        fontSize: 16.0);
    return false;
  }
}

//register
Future<bool> register(String email, String password) async {
  try {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((respose) {
      print('Register Success = $email');
    });
    Fluttertoast.showToast(
        msg: " สมัครสมาชิกสำเร็จ",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Color.fromARGB(255, 187, 241, 191),
        textColor: Colors.black,
        fontSize: 16.0);

    return true;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      Fluttertoast.showToast(
          msg: "รหัสผ่านต้องมีความยาวอย่างน้อย 6 ตัวอักษร",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Color.fromARGB(255, 236, 116, 114),
          textColor: Colors.white,
          fontSize: 16.0);
    } else if (e.code == 'email-already-in-use') {
      Fluttertoast.showToast(
          msg: "อีเมลนี้มีผู้ใช้แล้ว",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Color.fromARGB(255, 236, 116, 114),
          textColor: Colors.white,
          fontSize: 16.0);
    } else if (e.code == 'invalid-email') {
      Fluttertoast.showToast(
          msg: "อีเมลไม่ถูกต้อง",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Color.fromARGB(255, 236, 116, 114),
          textColor: Colors.white,
          fontSize: 16.0);
    }
    return false;
  }
}
