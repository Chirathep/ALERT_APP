import 'package:flutter/material.dart';
import 'package:flutter_app_alert/views/social/Post.dart';
import 'package:flutter_app_alert/views/social/custom_image.dart';

class PostTile extends StatelessWidget {
  // const PostTile({ Key? key }) : super(key: key);
  final Post post;
  PostTile(this.post);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => print('show post'),
      child: cachedNetworkImage(post.mediaURL),
    );
  }
}
