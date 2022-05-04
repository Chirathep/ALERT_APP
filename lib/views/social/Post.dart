import 'dart:async';

import 'package:animator/animator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_alert/net/flutterfire.dart';
import 'package:flutter_app_alert/net/user_model.dart';
import 'package:flutter_app_alert/views/progress.dart';
import 'package:flutter_app_alert/views/social/comments.dart';
import 'package:flutter_app_alert/views/social/custom_image.dart';

class Post extends StatefulWidget {
  final String postId;
  final String userId;
  final String name;
  final String location;
  final String description;
  final String mediaURL;
  final dynamic likes;

  Post({
    required this.postId,
    required this.userId,
    required this.name,
    required this.location,
    required this.description,
    required this.mediaURL,
    required this.likes,
  });
  factory Post.fromDocument(DocumentSnapshot doc) {
    return Post(
      postId: doc['postId'],
      userId: doc['userId'],
      name: doc['name'],
      location: doc['location'],
      description: doc['description'],
      mediaURL: doc['mediaURL'],
      likes: doc['likes'],
    );
  }

  int getLikeCount(likes) {
    if (likes == null) {
      return 0;
    }
    int count = 0;
    likes.values.forEach((val) {
      if (val == true) {
        count += 1;
      }
    });
    return count;
  }

  @override
  State<Post> createState() => _PostState(
        postId: this.postId,
        userId: this.userId,
        name: this.name,
        location: this.location,
        description: this.description,
        mediaURL: this.mediaURL,
        likes: this.likes,
        likesCount: getLikeCount(this.likes),
      );
}

class _PostState extends State<Post> {
  UserModel loggedInUser = UserModel();
  // final usersRef = FirebaseFirestore.instance.collection('users');
  final postsRef = FirebaseFirestore.instance.collection('posts');
  final commentsRef = FirebaseFirestore.instance.collection('comments');
  // final commentsRef = FirebaseFirestore.instance.collection('comments');
  // final activityFeedRef = FirebaseFirestore.instance

  //current user
  String user = FirebaseAuth.instance.currentUser!.uid;

  final String postId;
  final String userId;
  final String name;
  final String location;
  final String description;
  final String mediaURL;
  int likesCount;
  Map likes;
  bool isLiked = false;
  bool showHeart = false;

  _PostState({
    required this.postId,
    required this.userId,
    required this.name,
    required this.location,
    required this.description,
    required this.mediaURL,
    required this.likes,
    required this.likesCount,
  });
//delete post firebase
  deletePost({
    required String postId,
    required String userId,
    required String name,
    required String location,
    required String description,
    required String mediaURL,
    required int likesCount,
    required Map likes,
  }) async {
    await postsRef.doc(userId).collection('userPosts').doc(postId).delete();

    await commentsRef.doc(postId).collection('comments').get().then((snapshot) {
      snapshot.docs.forEach((doc) {
        doc.reference.delete();
      });
    });
  }

  //
  buildPostHeader() {
    return StreamBuilder(
      stream: usersRef.doc(userId).snapshots(),
      initialData: null,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }
        // final DocumentSnapshot doc = snapshot.data;
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.white,
            backgroundImage: NetworkImage(
              'https://firebasestorage.googleapis.com/v0/b/flutter-alert-app.appspot.com/o/profile-icon.png?alt=media&token=da62b0f2-0f43-4530-8934-db7bf423aeb5',
            ),
          ),
          title: GestureDetector(
            onTap: () {
              print('show user profile');
            },
            child: Text(
              name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          subtitle: Text(
            location,
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          trailing: IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              showModalBottomSheet(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                context: context,
                builder: (context) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        ' ',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Divider(),
                      //code: open camera
                      ListTile(
                        onTap: () {
                          Navigator.pop(context);
                          //delete post firebase
                          deletePost(
                            postId: postId,
                            userId: userId,
                            name: name,
                            location: location,
                            description: description,
                            mediaURL: mediaURL,
                            likesCount: likesCount,
                            likes: likes,
                          );
                          print('deleted post');
                        },
                        leading: Icon(
                          Icons.dangerous,
                          color: Colors.red,
                        ),
                        title: Text('ลบโพสต์'),
                      ),
                      Divider(),
                      //code: open gallery
                      ListTile(
                        onTap: () {
                          //ปิด modal
                          Navigator.pop(context);
                        },
                        leading: Icon(
                          Icons.arrow_back,
                          color: Colors.grey,
                        ),
                        title: Text('ยกเลิก'),
                      ),
                      Divider(),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  handleLikePost() {
    bool _isLiked = likes[user] == true;
    if (_isLiked) {
      postsRef
          .doc(userId)
          .collection('userPosts')
          .doc(postId)
          .update({'likes.$user': false});
      setState(() {
        likesCount -= 1;
        isLiked = false;
        likes[user] = false;
      });
    } else if (!_isLiked) {
      postsRef
          .doc(userId)
          .collection('userPosts')
          .doc(postId)
          .update({'likes.$user': true});
      setState(() {
        likesCount += 1;
        isLiked = true;
        likes[user] = true;
        showHeart = true;
      });
      Timer(Duration(milliseconds: 500), () {
        setState(() {
          showHeart = false;
        });
      });
    }
  }

  buildPostImage() {
    return GestureDetector(
      onDoubleTap: () {
        handleLikePost();
      },
      child: Stack(
        children: <Widget>[
          cachedNetworkImage(mediaURL),
          showHeart
              ? Animator(
                  duration: Duration(milliseconds: 300),
                  tween: Tween(begin: 0.8, end: 1.4),
                  curve: Curves.elasticOut,
                  cycles: 0,
                  builder: (context, animatorState, child) => Transform.scale(
                    scale: 1.1,
                    child: Icon(
                      Icons.favorite,
                      size: 80.0,
                      color: Colors.red,
                    ),
                  ),
                )
              : Text('')
        ],
      ),
    );
  }

  showComments(
    BuildContext context, {
    String? postId,
    String? userId,
    String? mediaURL,
  }) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Comments(
        postId: postId!,
        postUserId: userId!,
        postMediaURL: mediaURL!,
      );
    }));
  }

  buildPostFooter() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(padding: EdgeInsets.only(top: 40.0, left: 20.0)),
            GestureDetector(
              onTap: handleLikePost,
              child: isLiked
                  ? Icon(
                      Icons.favorite,
                      size: 28.0,
                      color: Colors.pink,
                    )
                  : Icon(
                      Icons.favorite_border,
                      size: 28.0,
                      color: Colors.black,
                    ),
            ),
            Padding(padding: EdgeInsets.only(right: 20.0)),
            GestureDetector(
              onTap: () => showComments(
                context,
                postId: postId,
                userId: userId,
                mediaURL: mediaURL,
              ),
              child: Icon(
                Icons.chat_bubble_outline,
                size: 28.0,
                color: Colors.black,
              ),
            ),
            //timestamp
          ],
        ),
        Row(
          children: [
            Container(
              margin: EdgeInsets.only(left: 20.0),
              child: Text(
                "$likesCount likes",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(left: 20.0),
              child: Text(
                "$name ",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(child: Text(description))
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    isLiked = (likes[user] == true);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        buildPostHeader(),
        buildPostImage(),
        buildPostFooter(),
        Divider(
          thickness: 1.0,
        ),
      ],
    );
  }
}
