import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:timeago/timeago.dart' as timeago;

class Comments extends StatefulWidget {
  // const Comments({Key? key}) : super(key: key);
  final String postId;

  final String postUserId;
  final String postMediaURL;

  Comments({
    required this.postId,
    required this.postUserId,
    required this.postMediaURL,
  });

  @override
  State<Comments> createState() => _CommentsState(
        postId: this.postId,
        postUserId: this.postUserId,
        postMediaURL: this.postMediaURL,
      );
}

class _CommentsState extends State<Comments> {
  final commentsRef = FirebaseFirestore.instance.collection('comments');
  final String postId;

  final String postUserId;
  final String postMediaURL;

  _CommentsState({
    required this.postId,
    required this.postUserId,
    required this.postMediaURL,
  });
  User? user = FirebaseAuth.instance.currentUser;
  final usersRef = FirebaseFirestore.instance.collection('users');
  //user name

  TextEditingController _commentController = TextEditingController();

  buildComments() {
    return StreamBuilder(
      stream: commentsRef
          .doc(postId)
          .collection('comments')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }
        List<Comment> comments = [];
        snapshot.data.docs.forEach((doc) {
          comments.add(Comment.fromDocument(doc));
        });
        return ListView(
          children: comments,
        );
      },
    );
  }

  addcomment() {
    commentsRef.doc(postId).collection('comments').add({
      'comment': _commentController.text,
      'userId': user!.uid,
      'timestamp': DateTime.now().day,
      "avatar":
          'https://firebasestorage.googleapis.com/v0/b/flutter-alert-app.appspot.com/o/profile-icon.png?alt=media&token=da62b0f2-0f43-4530-8934-db7bf423aeb5',
    });
    _commentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comments'),
      ),
      body: Column(
        children: [
          Expanded(child: buildComments()),
          Divider(),
          ListTile(
            title: TextFormField(
              decoration: InputDecoration(labelText: 'Write a comment...'),
              onFieldSubmitted: (input) {},
              controller: _commentController,
            ),
            trailing: OutlinedButton(
              onPressed: () {
                addcomment();
              },
              style: OutlinedButton.styleFrom(),
              child: Text('Post'),
            ),
          )
        ],
      ),
    );
  }
}

class Comment extends StatelessWidget {
  final String userId;
  final String avatar;
  // final String userName;
  final String comment;
  // final String timestamp;
  Comment({
    required this.userId,
    required this.avatar,
    // required this.userName,
    required this.comment,
    // required this.timestamp,
  });

  factory Comment.fromDocument(DocumentSnapshot doc) {
    return Comment(
      userId: doc['userId'],
      avatar: doc['avatar'],
      comment: doc['comment'],
    );
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.grey[200],
            backgroundImage: NetworkImage(avatar),
          ),
          title: Text(comment, style: TextStyle(fontSize: 16.0)),
        ),
        Divider(),
      ],
    );
  }
}
