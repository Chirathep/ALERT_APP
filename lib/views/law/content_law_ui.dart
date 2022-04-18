import 'package:flutter/material.dart';
import 'package:flutter_app_alert/net/flutterfire.dart';
import 'package:flutter_app_alert/views/main/index.dart';
import 'package:flutter_app_alert/views/main/register_ui2.dart';

class LawUI extends StatefulWidget {
  const LawUI({Key? key}) : super(key: key);

  @override
  State<LawUI> createState() => _LawUIState();
}

class _LawUIState extends State<LawUI> {
  int currentIndex = 3;
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
                child: Text('ออกจากระบบ'),
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
    );
  }
}
