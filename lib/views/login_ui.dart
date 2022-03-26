// ignore_for_file: unused_element

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_app_alert/net/flutterfire.dart';
import 'package:flutter_app_alert/views/main_home_ui.dart';
import 'package:flutter_app_alert/views/register_1_ui.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginUI extends StatefulWidget {
  const LoginUI({Key? key}) : super(key: key);

  @override
  _LoginUIState createState() => _LoginUIState();
}

class _LoginUIState extends State<LoginUI> {
  String? displayName;

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    // findDisplayName();
  }

  // Future findDisplayName() async {
  //   await Firebase.initializeApp().then((value) async {
  //     await FirebaseAuth.instance.authStateChanges().listen((event) {
  //       displayName = event?.displayName;
  //       print('##### displayName=$DisplayName');
  //     });
  //   });
  // }

  //
  final storage = FlutterSecureStorage();
  //
  AuthClass authClass = AuthClass();
  //
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
//
  final auth = FirebaseAuth.instance;
//
  bool _isObscure = true;
//
//_formkey
  // final GlobalKey<FormState> _formkey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(' '),
          centerTitle: true,
          backgroundColor: Colors.grey[50],
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new),
            //คำสั่งกลับไปหน้าก่อนหน้า
            onPressed: () {
              Navigator.pop(context);
            },
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.grey[50],
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'เข้าสู่ระบบ',
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                Text(
                  'กรุณากรอกข้อมูล',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.04,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.75,
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                      ),
                      child: TextField(
                        keyboardType: TextInputType.emailAddress,
                        controller: _email,
                        // onChanged: (value) {
                        //   setState(() {
                        //     _email = value.trim();
                        //   });
                        // },
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.email,
                            color: Colors.grey[400],
                          ),
                          labelText: 'อีเมล  ',
                          labelStyle: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: TextField(
                        obscureText: _isObscure,
                        keyboardType: TextInputType.text,
                        controller: _password,
                        // onChanged: (value) {
                        //   setState(() {
                        //     _password = value.trim();
                        //   });
                        // },
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            FontAwesomeIcons.key,
                            color: Colors.grey[400],
                          ),
                          labelText: 'รหัสผ่าน  ',
                          labelStyle: TextStyle(
                            color: Colors.grey,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isObscure
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.grey[400],
                            ),
                            onPressed: () {
                              setState(() {
                                _isObscure = !_isObscure;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 40,
                    right: 40,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'ลืมรหัสผ่าน ?',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.09,
                ),
                ElevatedButton(
                  onPressed: () async {
                    bool shouldNavigate =
                        await login(_email.text, _password.text);
                    if (shouldNavigate) {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MainHomeUI()));
                    }
                  },
                  child: Text(
                    'เข้าสู่ระบบ',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(
                      MediaQuery.of(context).size.width - 80,
                      50,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(45),
                    ),
                    primary: Color(0xff39b54a),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'ยังไม่มีบัญชีใช่หรือไม่ ?',
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 5),
                    InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Register1UI(),
                          ),
                        );
                      },
                      child: Text(
                        'สมัครสมาชิก',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
