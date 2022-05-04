// ignore_for_file: unused_element
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_alert/net/flutterfire.dart';
import 'package:flutter_app_alert/views/progress.dart';
import 'package:flutter_app_alert/views/social/Post.dart';
import 'package:flutter_app_alert/views/social/post_tile.dart';
import 'package:flutter_app_alert/views/user/user_edit.dart';

class UserUI extends StatefulWidget {
  const UserUI({Key? key}) : super(key: key);

  @override
  State<UserUI> createState() => _UserUIState();
}

class _UserUIState extends State<UserUI> {
  int posttoggle = 0;
  int currentIndex = 4;
  //
  User? user = FirebaseAuth.instance.currentUser;
  final postsRef = FirebaseFirestore.instance.collection('posts');
  //
  AuthClass authClass = AuthClass();

  bool isLoading = false;
  List<Post> posts = [];
  //
  @override
  void initState() {
    super.initState();
    getProfilePosts();
  }

  getProfilePosts() async {
    setState(() {
      isLoading = true;
    });
    QuerySnapshot snapshot = await postsRef
        .doc(user!.uid)
        .collection('userPosts')
        .orderBy('timestamp', descending: true)
        .get();
    setState(() {
      isLoading = false;
      posts = snapshot.docs.map((doc) => Post.fromDocument(doc)).toList();
    });
  }

  buildProfileHead() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 15, bottom: 10),
                child: InkWell(
                  onTap: (() {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditProfileUI(),
                      ),
                    );
                  }),
                  child: Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.05,
                      ),
                      Container(
                        // height: MediaQuery.of(context).size.height * 0.15,
                        // width: MediaQuery.of(context).size.width * 0.15,
                        child: CircleAvatar(
                          radius: 33.0,
                          backgroundColor: Colors.grey,
                          backgroundImage: CachedNetworkImageProvider(
                            'https://firebasestorage.googleapis.com/v0/b/flutter-alert-app.appspot.com/o/profile-icon.png?alt=media&token=da62b0f2-0f43-4530-8934-db7bf423aeb5',
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.05,
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 17.0),
                            child: StreamBuilder(
                              stream: usersRef.doc(user!.uid).snapshots(),
                              initialData: null,
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                if (!snapshot.hasData) {
                                  return circularProgress();
                                }
                                final DocumentSnapshot doc = snapshot.data;
                                return Text(
                                  doc['name'],
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              },
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'แก้ไขข้อมูลส่วนตัว >',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  //
  buildProfilePosts() {
    if (isLoading) {
      return circularProgress();
    } else if (posts.isEmpty) {
      return Container(
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
      );
    } else if (posttoggle == 0) {
      List<GridTile> gridTiles = [];
      posts.forEach((post) {
        gridTiles.add(GridTile(child: PostTile(post)));
      });
      return GridView.count(
        crossAxisCount: 3,
        childAspectRatio: 1.0,
        mainAxisSpacing: 1.5,
        crossAxisSpacing: 1.5,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: gridTiles,
      );
    } else if (posttoggle == 1) {
      return Column(
        children: posts,
      );
    }
  }

  buildToggledPosts() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          onPressed: () {
            setState(() {
              posttoggle = 0;
            });
          },
          icon: Icon(Icons.grid_on),
          color: posttoggle == 0 ? Colors.blue : Colors.grey,
        ),
        IconButton(
          onPressed: () {
            setState(() {
              posttoggle = 1;
            });
          },
          icon: Icon(Icons.list),
          color: posttoggle == 1 ? Colors.blue : Colors.grey,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leadingWidth: 0,
        elevation: 0.3,
        centerTitle: true,
        title: Text(
          'โปรไฟล์',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.grey[50],
      ),
      body: ListView(
        children: [
          buildProfileHead(),
          Divider(
            color: Colors.grey,
            height: 0.05,
          ),
          buildToggledPosts(),
          Divider(
            color: Colors.grey,
            height: 0.1,
          ),
          buildProfilePosts(),
        ],
      ),
    );
  }

  // deleteUser() async {
  //   usersRef.doc(loggedInUser.uid ?? "").delete();
  // }
}
