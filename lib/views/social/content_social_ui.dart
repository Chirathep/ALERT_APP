import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_alert/views/progress.dart';

final usersRef = FirebaseFirestore.instance.collection('users');

class SocialUI extends StatefulWidget {
  const SocialUI({Key? key}) : super(key: key);

  @override
  State<SocialUI> createState() => _SocialUIState();
}

class _SocialUIState extends State<SocialUI> {
  // List<dynamic> users = [];
  @override
  void initState() {
    // getUserById();
    // getUser();
    super.initState();
  }

  createUser() {}
  // getUserById() async {
  //   final String id = "SVpWe24angPfYmVojREbrgkH2Wa2";
  //   final DocumentSnapshot doc = await usersRef.doc(id).get();
  //   {
  //     print(doc.data());
  //     print(doc.id);
  //     print(doc.exists);
  //   }
  // }

  // getUser() async {
  //   final QuerySnapshot snapshot = await usersRef.get();
  //   {
  //     // snapshot.docs.forEach((DocumentSnapshot doc) {
  //     //   print(doc.data());
  //     //   print(doc.id);
  //     //   print(doc.exists);
  //     // });
  //     setState(() {
  //       users = snapshot.docs;
  //     });
  //   }
  // }

  int currentIndex = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
      body: StreamBuilder<QuerySnapshot>(
        stream: usersRef.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress();
          }
          final List<Text> children =
              snapshot.data!.docs.map((doc) => Text(doc['name'])).toList();
          return Container(
            child: ListView(children: children),
          );
        },
      ),
    );
  }
}
