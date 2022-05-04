// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_app_alert/views/social/Post.dart';

// class TimelineUI extends StatefulWidget {
//   const TimelineUI({Key? key}) : super(key: key);

//   @override
//   State<TimelineUI> createState() => _TimelineUIState();
// }

// class _TimelineUIState extends State<TimelineUI> {
//   final timelineRef = FirebaseFirestore.instance.collection('timeline');
//   List<Post> posts = [];
//   @override
//   void initState() {
//     super.initState();
//     gettimeline();
//   }

//   gettimeline() async {
//     QuerySnapshot snapshot = await timelineRef
//         .doc('timeline')
//         .collection('timelinePosts')
//         .orderBy('timestamp', descending: true)
//         .get();
//     List<Post> posts =
//         snapshot.docs.map((doc) => Post.fromDocument(doc)).toList();

//     setState(() {
//       this.posts = posts;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return RefreshIndicator(
//       onRefresh: (() => gettimeline()),
//       child: buildTimeline(),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_alert/views/progress.dart';
import 'package:flutter_app_alert/views/social/Post.dart';
import 'package:flutter_app_alert/views/social/upload.dart';

final usersRef = FirebaseFirestore.instance.collection('users');
final postsRef = FirebaseFirestore.instance.collection('posts');
User? user = FirebaseAuth.instance.currentUser;
final userPostsRef = FirebaseFirestore.instance.collection('userPosts');

class TimelineUI extends StatefulWidget {
  const TimelineUI({Key? key}) : super(key: key);

  @override
  State<TimelineUI> createState() => _SocialUIState();
}

class _SocialUIState extends State<TimelineUI> {
  @override
  void initState() {
    super.initState();
    getProfilePosts();

    //print Id
    print(user!.uid);
  }

  List<Post> posts = [];
  int currentIndex = 1;
  bool isLoading = false;

  getProfilePosts() async {
    setState(() {
      isLoading = true;
    });
    // QuerySnapshot snapshot = await postsRef
    //     .doc(user!.uid)
    //     .collection('userPosts')
    //     .orderBy('timestamp', descending: true)
    //     .get();

    //streambuilder .map
    Stream<QuerySnapshot> snapshot = postsRef
        .doc(user!.uid)
        .collection('userPosts')
        .orderBy('timestamp', descending: true)
        .snapshots();
    // .doc()
    // .snapshots();
    setState(() {
      isLoading = false;
      snapshot.listen((event) {
        setState(() {
          posts = event.docs.map((doc) => Post.fromDocument(doc)).toList();
        });
      });
      // posts = snapshot.docs.map((doc) => Post.fromDocument(doc)).toList();
    });
  }

  buildProfilePosts() {
    if (isLoading) {
      return circularProgress();
    } else if (posts.isEmpty) {
      return Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              Icon(
                Icons.photo_library,
                size: 200,
              ),
              Text(
                'ไม่มีโพสต์',
                style: TextStyle(fontSize: 30),
              ),
            ],
          ),
        ),
      );
    } else {
      return Column(
        children: posts,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leadingWidth: 0,
        elevation: 1,
        title: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
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
      body: ListView(
        children: [buildProfilePosts()],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Upload()),
          );
        },
        //color
        backgroundColor: Colors.blue,
        child: Icon(Icons.add),
      ),
    );
  }
}


// // body: StreamBuilder<QuerySnapshot>(
// //         stream: usersRef.snapshots(),
// //         builder: (context, snapshot) {
// //           if (!snapshot.hasData) {
// //             return circularProgress();
// //           }
// //           final List<Text> children =
// //               snapshot.data!.docs.map((doc) => Text(doc['name'])).toList();
// //           return Container(
// //             child: ListView(children: children),
// //           );
// //           //floatbutton
// //         },
// //       ),