import 'package:flutter/material.dart';
import 'package:flutter_app_alert/net/flutterfire.dart';
import 'package:flutter_app_alert/views/login_ui.dart';
import 'package:flutter_app_alert/views/register_1_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class IndexUI extends StatefulWidget {
  const IndexUI({Key? key}) : super(key: key);

  @override
  State<IndexUI> createState() => _HomeUIState();
}

class _HomeUIState extends State<IndexUI> {
  AuthClass authClass = AuthClass();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.05,
                ),
                Text(
                  'ALERT',
                  style: TextStyle(
                    fontSize: 70,
                    fontWeight: FontWeight.bold,
                    color: Colors.red[700],
                  ),
                ),
                Image.asset(
                  'assets/images/logo-v.png',
                  width: 57,
                ),
              ],
            ),
            Text(
              'แอปพลิเคชั่นแจ้งเตือนอุบัติเหตุบนท้องถนน',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.33,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginUI()));
              },
              child: Text(
                'เข้าสู่ระบบ',
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 95, 81, 0)),
              ),
              style: ElevatedButton.styleFrom(
                  fixedSize: Size(
                    MediaQuery.of(context).size.width - 80,
                    50,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(45),
                  ),
                  // side: BorderSide(
                  //   color: Colors.grey,
                  //   width: 1,
                  // ),
                  primary: Color.fromARGB(255, 231, 209, 168)),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Register1UI()));
              },
              child: Text(
                'สมัครสมาชิก',
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                  fixedSize: Size(
                    MediaQuery.of(context).size.width - 80,
                    50,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(45),
                  ),
                  // side: BorderSide(
                  //   color: Colors.black,
                  //   width: 1,
                  // ),
                  primary: Color.fromARGB(255, 101, 180, 104)),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            ElevatedButton.icon(
              onPressed: () async {
                authClass.googleSignIn(context);
                await authClass.googleSignIn(context);
              },
              icon: Icon(
                FontAwesomeIcons.google,
              ),
              label: Text(
                '  ล็อคอินด้วย Google',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                fixedSize: Size(
                  MediaQuery.of(context).size.width - 80,
                  50,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(45),
                  // side: BorderSide(
                  //   color: Color.fromARGB(255, 0, 0, 0),
                  // ),
                ),
                primary: Color(0xffDB4437),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
